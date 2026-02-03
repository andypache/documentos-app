import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for report item application
class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Stack(children: [BrackgroundWidget(), _ReportScreenBody()]),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for report into sroll view
class _ReportScreenBody extends StatelessWidget {
  const _ReportScreenBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Column(children: [
      PageTitleWidget(title: 'Reportes'),
      SizedBox(height: 60),
      _ReportScreenForm()
    ]));
  }
}

///Create widgets form of report
class _ReportScreenForm extends StatelessWidget {
  const _ReportScreenForm({Key? key}) : super(key: key);

  //Create form
  @override
  Widget build(BuildContext context) {
    return const Form(
        child: Column(children: [
      InputFieldWidget(
          prefixIcon: Icons.person_outline_outlined,
          labelText: 'Nombre',
          hintText: 'Nombre (requerido)',
          onChanged: null),
      SizedBox(height: 30)
    ]));
  }
}
