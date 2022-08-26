import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render client application
class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  //Render principal widgets load background, body and float buttom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: const [BrackgroundWidget(), _ClientScreenBody()]),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for bill into sroll view
class _ClientScreenBody extends StatelessWidget {
  const _ClientScreenBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitleWidget(title: 'Clientes'),
      SizedBox(height: 60),
      _ClientScreenForm()
    ]));
  }
}

///Create widgets form of bill
class _ClientScreenForm extends StatelessWidget {
  const _ClientScreenForm({Key? key}) : super(key: key);

  //Create form
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(children: const [
      InputFieldWidget(
          prefixIcon: Icons.person_outline_outlined,
          labelText: 'Nombre',
          hintText: 'Nombre (requerido)',
          onChanged: null),
      SizedBox(height: 30)
    ]));
  }
}
