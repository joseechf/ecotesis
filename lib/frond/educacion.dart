import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Educacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Responsive Example')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Pantalla grande → diseño en fila
              return Row(
                children: [
                  Expanded(child: _buildBox('texto1'.tr(), Colors.red)),
                  Expanded(child: _buildBox('esun'.tr(), Colors.green)),
                  Expanded(
                    child: _buildBoxImg('assets/images/mono1.jpg', Colors.blue),
                  ),
                ],
              );
            } else {
              // Pantalla pequeña → diseño en columna
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBox('texto1'.tr(), Colors.red),
                    _buildBox('esun'.tr(), Colors.green),
                    _buildBoxImg('assets/images/mono1.jpg', Colors.blue),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBox(String text, Color color) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromARGB(255, 34, 77, 34),
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildBoxImg(String text, Color color) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: color,
      child: Image.asset(
        text,
        fit: BoxFit.cover,
        width: double.infinity,
        height:
            500, // Fija una altura para evitar que se expanda ilimitadamente
      ),
    );
  }
}
