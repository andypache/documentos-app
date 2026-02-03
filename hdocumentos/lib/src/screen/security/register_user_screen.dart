import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render home application
class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainerWidget(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Registrar usuario',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          AppTheme.primary.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Ya tiene una cuenta ?',
                    style: TextStyle(fontSize: 18, color: AppTheme.black),
                  )),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginForm.formKey,
        child: Column(
          children: [
            InputFieldWidget(
                prefixIcon: Icons.supervised_user_circle_outlined,
                labelText: 'Usuario',
                hintText: 'Nombre del usuario',
                onChanged: (value) => loginForm.username = value,
                validator: validatorName),
            const SizedBox(height: 30),
            InputFieldWidget(
              prefixIcon: Icons.password_outlined,
              labelText: 'Password',
              hintText: 'Contraseña de usuario',
              obscureText: true,
              onChanged: (value) => loginForm.password = value,
              validator: validatorPassword,
            ),
            const SizedBox(height: 30),
            MaterialButtonWidget(
                textButton: 'Iniciar',
                onPressed: loginForm.isLoading
                    ? null
                    : () => onClickLogin(context, loginForm))
          ],
        ));
  }

  String? validatorName(value) {
    if (value == null) return 'Este campo es requerido';
    return value.length < 3 ? 'Mínimo de 3 caractéres' : null;
  }

  String? validatorPassword(value) {
    if (value == null) return 'Contraseña requerida';
    return value.length < 4 ? 'Mínimo de 4 caractéres' : null;
  }

  Future<void> onClickLogin(
      BuildContext context, LoginFormProvider loginForm) async {
    FocusScope.of(context).unfocus();
    if (!loginForm.isValidForm()) return;
    Navigator.pushReplacementNamed(context, 'home');
  }
}
