import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render configuration application
class ConfigurationUserBill extends StatelessWidget {
  const ConfigurationUserBill({Key? key}) : super(key: key);

  //Render principal widgets load background, body and float buttom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ConfigurationUserBillBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for configuration into sroll view
class _ConfigurationUserBillBody extends StatelessWidget {
  const _ConfigurationUserBillBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Configuración'),
      SizedBox(
        height: 60,
      ),
      _ConfigurationUserBillForm()
    ]));
  }
}

///Create widgets form of configuration
class _ConfigurationUserBillForm extends StatelessWidget {
  const _ConfigurationUserBillForm({Key? key}) : super(key: key);

  //Create form
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(children: const [
      CustomInputField(
          prefixIcon: Icons.person_outline_outlined,
          labelText: 'Archivo',
          hintText: 'Seleccione (requerido)',
          onChanged: null),
      SizedBox(height: 30),
    ]));
  }
}
