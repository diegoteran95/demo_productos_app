import 'package:demo_productos_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    product.available = value;

    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
