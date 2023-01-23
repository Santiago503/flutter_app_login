import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/login_form_provider.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_background.dart';
import '../widgets/card_container.dart';
import '../widgets/input_decoration.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackGround(
          child: SingleChildScrollView(
              child: Column(
        children: [
          const SizedBox(height: 250),
          _cardContainer(context),
          const SizedBox(height: 50),
          _textButton(context)
        ],
      ))),
    );
  }

  TextButton _textButton(BuildContext context) {
    return TextButton(
        onPressed: (() => Navigator.pushReplacementNamed(context, 'login')),
        style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
            shape: MaterialStateProperty.all(const StadiumBorder())),
        child: const Text(
          'Ya tienes una cuenta?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ));
  }

CardContainer _cardContainer(BuildContext context) {
    return CardContainer(
        child: Column(
      children: [
        const SizedBox(height: 10),
        Text('Registrarse', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 30),
        ChangeNotifierProvider(
            create: (_) => LoginFormProvider(), child: _LoginForm()),
      ],
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Form(
          key: loginForm.formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _textFormEmail(context, loginForm),
              const SizedBox(height: 30),
              _textFormPassword(context, loginForm),
              const SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Theme.of(context).primaryColor,
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (loginForm.isValidForm() == false) return;
                        loginForm.isLoading = true;

                        //await Future.delayed(const Duration(seconds: 3));

                        final String? msg = await authService.createUser(
                            loginForm.email, loginForm.password);

                        if (msg == null) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, 'home');
                          NotificationService.shoSnackBar('Login');

                        } else {
                            NotificationService.shoSnackBar(msg);
                        }

                        loginForm.isLoading = false;
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(loginForm.isLoading ? 'Cargando' : 'Ingresar',
                      style: const TextStyle(color: Colors.white)),
                ),
              )
            ],
          )),
    );
  }

  TextFormField _textFormEmail(
      BuildContext context, LoginFormProvider loginForm) {
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
          context: context,
          labelText: 'Correo Electrónico',
          hintText: 'example@gmail.com',
          prefixIcon: Icons.alternate_email_rounded),
      onChanged: (value) => loginForm.email = value,
      validator: (value) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '') ? null : 'Correo invalidó';
      },
    );
  }

  TextFormField _textFormPassword(
      BuildContext context, LoginFormProvider loginForm) {
    return TextFormField(
        autocorrect: false,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecorations.authInputDecoration(
            context: context,
            labelText: '*****',
            hintText: 'Contraseña',
            prefixIcon: Icons.lock_outline),
        onChanged: (value) => loginForm.password = value,
        validator: (value) {
          if (value != null && value.isNotEmpty) return null;
          return 'La contraseña es requerida';
        });
  }
}
