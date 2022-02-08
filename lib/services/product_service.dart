import 'dart:convert';
import 'dart:io';

import 'package:demo_productos_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-9f0ab-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  File? newPicture;

  ProductService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
        _baseUrl, 'products.json', {'auth': await storage.read(key: 'token')});
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
        _baseUrl, 'products.json', {'auth': await storage.read(key: 'token')});
    final response = await http.post(url, body: product.toJson());
    final decodedData = json.decode(response.body);
    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'token')});
    await http.put(url, body: product.toJson());

    final int index =
        products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPicture = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPicture == null) {
      return null;
    }

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ds4eig8io/image/upload?upload_preset=lskhgmw1');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.body);
      return null;
    }

    newPicture = null;
    final decodeData = json.decode(response.body);
    print(response.body);

    return decodeData['secure_url'];
  }
}
