import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for review item application
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: const [BrackgroundWidget(), _ReviewScreenBody()]),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for review into sroll view
class _ReviewScreenBody extends StatelessWidget {
  const _ReviewScreenBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitleWidget(title: 'Revisión documentos'),
      SizedBox(height: 60),
      _ReviewScreenForm()
    ]));
  }
}

///Create widgets form of review
class _ReviewScreenForm extends StatelessWidget {
  const _ReviewScreenForm({Key? key}) : super(key: key);

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
