import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render item application
class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: const [BrackgroundWidget(), _ItemScreenBody()]),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for item into sroll view
class _ItemScreenBody extends StatelessWidget {
  const _ItemScreenBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitleWidget(title: 'Productos'),
      SizedBox(height: 60),
      _ItemScreenForm()
    ]));
  }
}

///Create widgets form of configuration
class _ItemScreenForm extends StatelessWidget {
  const _ItemScreenForm({Key? key}) : super(key: key);

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
