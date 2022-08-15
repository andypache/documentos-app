import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render bill application
class ManagementBill extends StatelessWidget {
  const ManagementBill({Key? key}) : super(key: key);

  //Render principal widgets load background, body and float buttom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ManagementBillBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for bill into sroll view
class _ManagementBillBody extends StatelessWidget {
  const _ManagementBillBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Facturas'),
      SizedBox(
        height: 60,
      ),
      _ManagementBillForm()
    ]));
  }
}

///Create widgets form of bill
class _ManagementBillForm extends StatelessWidget {
  const _ManagementBillForm({Key? key}) : super(key: key);

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
