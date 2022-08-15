import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for report item application
class ManagementReport extends StatelessWidget {
  const ManagementReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: const [Brackground(), _ManagementReportBody()],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for report into sroll view
class _ManagementReportBody extends StatelessWidget {
  const _ManagementReportBody({Key? key}) : super(key: key);

  ///Put title and form into principal widgets
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Reportes'),
      SizedBox(
        height: 60,
      ),
      _ManagementReportForm()
    ]));
  }
}

///Create widgets form of report
class _ManagementReportForm extends StatelessWidget {
  const _ManagementReportForm({Key? key}) : super(key: key);

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
