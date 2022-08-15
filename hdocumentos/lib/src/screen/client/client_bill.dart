import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render client application
class ClientBill extends StatelessWidget {
  const ClientBill({Key? key}) : super(key: key);

  //Render principal widgets load background, body and float buttom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ClientBillBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for bill into sroll view
class _ClientBillBody extends StatelessWidget {
  const _ClientBillBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Clientes'),
      SizedBox(
        height: 60,
      ),
      _ClientBillForm()
    ]));
  }
}

///Create widgets form of bill
class _ClientBillForm extends StatelessWidget {
  const _ClientBillForm({Key? key}) : super(key: key);

  //Create form
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(children: const [
      CustomInputField(
          prefixIcon: Icons.person_outline_outlined,
          labelText: 'Nombre',
          hintText: 'Nombre (requerido)',
          onChanged: null),
      SizedBox(height: 30),
    ]));
  }
}
