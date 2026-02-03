import 'package:flutter/material.dart';

///Create general widget loading
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  //Build and render circular progress indicator
  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Center(
        child: CircularProgressIndicator(),
      )
    ]);
  }
}
