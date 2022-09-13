import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/provider/provider.dart';

///Widgets for render configuration application
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  //Render principal widgets load background, session, title and body
  @override
  Widget build(BuildContext context) {
    final configurationService = Provider.of<ConfigurationService>(context);

    //Create screen
    return Scaffold(
        body: Stack(children: [
          const BrackgroundWidget(),
          //Put user session title and cart bill menu
          UserSessionTitle(),
          //Put title screen
          const PageTitleWidget(title: "Configuración"),
          //Scroll view padding top and left create provider form
          SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 135, left: 20),
                  child: _ConfigurationScreenBody(
                      configurationService: configurationService)))
        ]),
        //Button close
        floatingActionButton: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.close, color: AppTheme.red),
            onPressed: () => Navigator.pop(context)));
  }
}

///Body for configuration into sroll view
class _ConfigurationScreenBody extends StatelessWidget {
  const _ConfigurationScreenBody({Key? key, required this.configurationService})
      : super(key: key);
  final ConfigurationService configurationService;

  //Create body
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //Create view after search config api
    return FutureBuilder(
        future: configurationService.loadConfiguration(context),
        builder: (_, AsyncSnapshot<ConfigurationModel> snapshot) {
          if (snapshot.hasData) {
            //Body
            return SizedBox(
                width: size.width * 0.90,
                child: Column(children: [
                  //Create image component for update
                  _ConfigurationScreenImage(
                      configurationService: configurationService),
                  const SizedBox(height: 30),
                  //Management provider form for save config
                  ChangeNotifierProvider(
                      create: (_) => ConfigurationFormProvider(
                          configurationService.configuration),
                      child: const _ConfigurationScreenForm(),
                      lazy: true)
                ]));
          } else if (snapshot.hasError) {
            //Error for load config
            return errorLoadContainer(snapshot.error);
          }
          //Loading component while load api
          return SizedBox(
              height: size.height * 0.50, child: const LoadingWidget());
        });
  }
}

///Widget for load image to send bill
class _ConfigurationScreenImage extends StatelessWidget {
  const _ConfigurationScreenImage(
      {Key? key, required this.configurationService})
      : super(key: key);
  final ConfigurationService configurationService;

  //Return image component load gallery or camera
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //Create header with image component
    return Column(children: [
      Stack(children: [
        //load image config
        CardImageWidget(url: configurationService.configuration.pathImage),
        //button for select gallery file
        Positioned(
            top: 5,
            left: 20,
            child: IconButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final PickedFile? pickedFile = await picker.getImage(
                      source: ImageSource.gallery, imageQuality: 100);
                  if (pickedFile == null) {
                    return;
                  }
                  configurationService.updateSelectedImage(pickedFile.path);
                },
                icon: const Icon(Icons.search_outlined,
                    size: 40, color: Colors.white))),
        //button for camera file
        Positioned(
            top: 5,
            right: 20,
            child: IconButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final PickedFile? pickedFile = await picker.getImage(
                      source: ImageSource.camera, imageQuality: 100);
                  if (pickedFile == null) {
                    return;
                  }
                  configurationService.updateSelectedImage(pickedFile.path);
                },
                icon: const Icon(Icons.camera_alt_outlined,
                    size: 40, color: Colors.white)))
      ]),
      //footer for name image
      Container(
          width: size.width * 0.90,
          height: size.height * 0.03,
          decoration: _buildBoxDecoration(),
          child: const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text("Imagen",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.redAccent,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center)))
    ]);
  }

  //Background card image
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: AppTheme.grey.withOpacity(1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]);
}

///Widgets configuration form
class _ConfigurationScreenForm extends StatelessWidget {
  const _ConfigurationScreenForm({Key? key}) : super(key: key);

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

    //Create form
    return Form(
        key: configurationForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          //Button to load file certificate
          MaterialButtonWidget(
              type: AppTheme.secondaryButton,
              icon: Icons.upload,
              textButton: 'Firma electrónica',
              minWidth: double.infinity,
              onPressed: () async {
                FilePickerResult? pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['cert', 'p12'],
                );
                if (pickedFile == null) {
                  return;
                }
                configurationForm
                    .updateCertificate(pickedFile.files.single.path!);
              }),
          const SizedBox(height: 20),
          InputFieldWidget(
              prefixIcon: Icons.lock_open_outlined,
              labelText: 'Password certificado',
              hintText: 'Password certificado (requerido)',
              obscureText: true,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              onChanged: (value) => configuration.passwordCertificate = value),
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
          //Button to save
          MaterialButtonWidget(
              textButton: 'Guardar', icon: Icons.save, onPressed: () => {}),
          const SizedBox(height: 20)
        ]));
  }
}
