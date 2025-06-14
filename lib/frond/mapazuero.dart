import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class mappAzuero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(50),
              padding: EdgeInsets.all(50),
              height: 400,
              width: 600,
              color: const Color.fromARGB(255, 98, 180, 116),
              child: WidgetPersonalizados.constructorContainerimg('assets/images/corredor.jpg', 0, 0, 600,0),
            ),
          ],
        ),
      ),
    );
  }
}
