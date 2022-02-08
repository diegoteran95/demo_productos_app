import 'package:demo_productos_app/providers/login_form_provider.dart';
import 'package:demo_productos_app/services/services.dart';
import 'package:demo_productos_app/ui/input_decorations.dart';
import 'package:demo_productos_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          childBG: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
              childCard: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Crear cuenta',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const _LoginForm(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: const Text(
                'Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'diego.teran@mail.com',
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icons.alternate_email_rounded),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Debe ingresar un correo válido';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;

                  return 'La contraseña debe tener 6 caracteres';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (!loginForm.isValidForm()) {
                            return;
                          }
                          loginForm.isLoading = true;
                          final String? errorMessage = await authService
                              .createUser(loginForm.email, loginForm.password);
                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            print(errorMessage);
                          }
                          loginForm.isLoading = false;
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere...' : 'Ingresar',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          )),
    );
  }
}
