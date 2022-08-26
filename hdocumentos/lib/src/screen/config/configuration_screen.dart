import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

///Widgets for generate settings company
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  //Build general widgets, background title and body
  @override
  Widget build(BuildContext context) {
    final configurationService = Provider.of<ConfigurationService>(context);
    return ChangeNotifierProvider(
        create: (_) =>
            ConfigurationFormProvider(configurationService.configuration),
        child: Scaffold(
            body: Stack(children: [
              const BrackgroundWidget(),
              const PageTitleWidget(title: 'Configuración'),
              _ConfigurationScreenBody(
                  configurationService: configurationService)
            ]),
            floatingActionButton: FloatingActionButton(
                elevation: 20,
                child: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context))));
  }
}

///Widget body screen header of image and body form
class _ConfigurationScreenBody extends StatelessWidget {
  const _ConfigurationScreenBody({Key? key, required this.configurationService})
      : super(key: key);

  final ConfigurationService configurationService;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(children: [
              Stack(children: [
                CardImageWidget(
                    url: configurationService.configuration.pathImage),
                Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final PickedFile? pickedFile = await picker.getImage(
                              source: ImageSource.gallery, imageQuality: 100);
                          if (pickedFile == null) {
                            return;
                          }
                          configurationService
                              .updateSelectedImage(pickedFile.path);
                        },
                        icon: const Icon(Icons.search_outlined,
                            size: 40, color: Colors.white))),
                Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final PickedFile? pickedFile = await picker.getImage(
                              source: ImageSource.camera, imageQuality: 100);
                          if (pickedFile == null) {
                            return;
                          }
                          configurationService
                              .updateSelectedImage(pickedFile.path);
                        },
                        icon: const Icon(Icons.camera_alt_outlined,
                            size: 40, color: Colors.white)))
              ]),
              _ConfigurationScreenForm()
            ])));
  }
}

//Widgets configuration form
class _ConfigurationScreenForm extends StatelessWidget {
  //build form with provider
  @override
  Widget build(BuildContext context) {
    final configurationForm = Provider.of<ConfigurationFormProvider>(context);
    final configuration = configurationForm.configuration;

    List<KeyValueModel> itemsEnviroment = <KeyValueModel>[];
    itemsEnviroment.addAll([
      KeyValueModel(key: '1', value: 'Pruebas'),
      KeyValueModel(key: '2', value: 'Producción')
    ]);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: _buildBoxDecoration(),
            child: Form(
                key: configurationForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: [
                  const SizedBox(height: 30),
                  MaterialButtonWidget(
                      type: AppTheme.secondaryButton,
                      icon: Icons.upload,
                      textButton: 'Certificado para firma electrónica',
                      minWidth: double.infinity,
                      onPressed: () async {
                        final picker = ImagePicker();
                        final PickedFile? pickedFile = await picker.getImage(
                            source: ImageSource.gallery, imageQuality: 100);
                        if (pickedFile == null) {
                          return;
                        }
                        configurationForm.updateCertificate(pickedFile.path);
                      }),
                  const SizedBox(height: 20),
                  InputFieldWidget(
                      prefixIcon: Icons.lock_open_outlined,
                      labelText: 'Password certificado',
                      hintText: 'Password certificado (requerido)',
                      obscureText: true,
                      filled: true,
                      fillColor: AppTheme.whiteGradient,
                      onChanged: (value) =>
                          configuration.passwordCertificate = value),
                  const SizedBox(height: 20),
                  InputDateFieldWidget(
                      labelText: 'Fecha caducidad certificado',
                      hintText: 'Fecha caducidad certificado (requerido)',
                      filled: true,
                      fillColor: AppTheme.whiteGradient,
                      /*onChanged: (value) => configuration
                      .certificateExpirationDate = value as DateTime?*/
                      onChanged: (value) {}),
                  const SizedBox(height: 20),
                  InputFieldWidget(
                      prefixIcon: Icons.email_outlined,
                      labelText: 'Email de envío',
                      hintText: 'Email (requerido)',
                      keyboardType: TextInputType.emailAddress,
                      filled: true,
                      fillColor: AppTheme.whiteGradient,
                      onChanged: (value) => configuration.email = value),
                  const SizedBox(height: 20),
                  DropdownButtonFieldWidget(
                      prefixIcon: Icons.send_to_mobile_sharp,
                      labelText: 'Ambiente',
                      hintText: 'Ambiente (requerido)',
                      items: itemsEnviroment,
                      filled: true,
                      fillColor: AppTheme.whiteGradient,
                      onChanged: (value) {}),
                  const SizedBox(height: 20),
                  MaterialButtonWidget(
                      textButton: 'Guardar',
                      icon: Icons.save,
                      onPressed: () => {}),
                  const SizedBox(height: 30)
                ]))));
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: AppTheme.targetGradient,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(1),
                offset: const Offset(15, 15),
                blurRadius: 5)
          ]);
}
