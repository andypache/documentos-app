import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render login application
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //Create background login and put form login
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: LoginBackgroundWidget(
            //Scroll view that float form
            child: SingleChildScrollView(
                child: Column(children: [
      SizedBox(height: size.height * 0.25),
      //Card container for form
      CardContainerWidget(
          child: Column(children: [
        Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            child: const Icon(Icons.lock_open_rounded,
                color: AppTheme.primary, size: 80)),
        const SizedBox(height: 10),
        //Title for container
        Text('Iniciar sesión',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 30),
        //Load form and provider login
        ChangeNotifierProvider(
            create: (_) => LoginFormProvider(), child: _LoginScreenForm()),
        const SizedBox(height: 10),
        //Widgets for send register form
        TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    AppTheme.primary.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            child: const Text('Registrar una cuenta',
                style: TextStyle(fontSize: 16, color: AppTheme.grey)))
      ])),
      const SizedBox(height: 50)
    ]))));
  }
}

///Widgets to forms login
class _LoginScreenForm extends StatelessWidget {
  //Create form login
  @override
  Widget build(BuildContext context) {
    //Load providers from context
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);
    //Create forms from login
    return Form(
        key: loginForm.formKey,
        child: Column(children: [
          if (loginForm.isLoading) const LoadingWidget(),
          InputFieldWidget(
              prefixIcon: Icons.person_outline_outlined,
              labelText: 'Usuario',
              hintText: 'Usuario (requerido)',
              textStyleColor: AppTheme.primary,
              floatingLabelStyleColor: AppTheme.primary,
              hintStyleColor: AppTheme.primary,
              onChanged: (value) => loginForm.username = value,
              validator: validatorUsername),
          const SizedBox(height: 30),
          InputFieldWidget(
              prefixIcon: Icons.lock_open_outlined,
              labelText: 'Password',
              hintText: 'Password (requerido)',
              textStyleColor: AppTheme.primary,
              floatingLabelStyleColor: AppTheme.primary,
              hintStyleColor: AppTheme.primary,
              obscureText: true,
              onChanged: (value) => loginForm.password = value,
              validator: validatorPassword),
          InputCheckboxFieldWidget(
            label: "Mantener sesión ?",
            onChanged: (isChecked) => loginForm.keepSession = isChecked!,
          ),
          MaterialButtonWidget(
              textButton: 'Ingresar',
              onPressed: loginForm.isLoading
                  ? null
                  : () => onClickLoginScreen(context, loginForm, authService))
        ]));
  }

  //Create function for validate username
  String? validatorUsername(value) {
    if (value == null) return 'Este campo es requerido';
    return value.length < 3 ? 'Mínimo de 3 caractéres' : null;
  }

  //Create function for validate password
  String? validatorPassword(value) {
    if (value == null) return 'Contraseña requerida';
    return value.length < 4 ? 'Mínimo de 4 caractéres' : null;
  }

  //Function that execute login,
  Future<void> onClickLoginScreen(BuildContext context,
      LoginFormProvider loginForm, AuthService authService) async {
    //Hide keyboard
    FocusScope.of(context).unfocus();
    //Verify form
    if (!loginForm.isValidForm()) return;
    //Create login
    loginForm.isLoading = true;
    try {
      ServiceResponseModel response =
          await authService.login(loginForm.username, loginForm.password);
      loginForm.isLoading = false;
      if (response.statusHttp == 200) {
        Preferences.keepSession = loginForm.keepSession;
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        NotificationService.showSnackbarError(
            response.error ?? response.message);
      }
    } catch (error) {
      loginForm.isLoading = false;
      NotificationService.showSnackbarError(
          "No se puede crear las sesión, por favor intente mas tarde");
    }
  }
}
