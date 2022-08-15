import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render item application
class ManagementItem extends StatelessWidget {
  const ManagementItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ManagementItemBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for item into sroll view
class _ManagementItemBody extends StatelessWidget {
  const _ManagementItemBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Productos'),
      SizedBox(
        height: 60,
      ),
      _ManagementItemForm()
    ]));
  }
}

///Create widgets form of configuration
class _ManagementItemForm extends StatelessWidget {
  const _ManagementItemForm({Key? key}) : super(key: key);

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
