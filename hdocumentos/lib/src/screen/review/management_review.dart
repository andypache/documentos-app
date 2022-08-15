import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for review item application
class ManagementReview extends StatelessWidget {
  const ManagementReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ManagementReviewBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for review into sroll view
class _ManagementReviewBody extends StatelessWidget {
  const _ManagementReviewBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Revisión documentos'),
      SizedBox(
        height: 60,
      ),
      _ManagementReviewForm()
    ]));
  }
}

///Create widgets form of review
class _ManagementReviewForm extends StatelessWidget {
  const _ManagementReviewForm({Key? key}) : super(key: key);

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
