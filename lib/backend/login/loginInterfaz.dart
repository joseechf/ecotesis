import 'package:ecoazuero/frond/home.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginInterfaz extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();
    TextEditingController gmail = TextEditingController();
    double anchoPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(context: context),
      body: SafeArea(
        child: Container(
          // height: 400,
          margin: EdgeInsets.all(anchoPantalla * 0.050),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 197, 238, 199),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 3, 41, 8),
                blurRadius: 20,
                offset: Offset(0, 4), // sombra hacia abajo
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
                      MainAxisAlignment
                          .center, // centra el contenido interno verticalmente
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center, // centra el contenido interno verticalmente
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: gmail,
                      decoration: InputDecoration(
                        labelText: context.tr('Login.correo'),
                      ),
                      validator: (gmail) {
                        if ((gmail == null) || (gmail.isEmpty)) {
                          return context.tr('Login.errores.vacio');
                        }
                        if ((!gmail.contains('@')) ||
                            (!gmail.endsWith('.com'))) {
                          return context.tr('Login.errores.mail');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: password,
                      decoration: InputDecoration(
                        labelText: context.tr('Login.password'),
                      ),
                      validator: (password) {
                        if ((password == null) || (password.isEmpty)) {
                          return context.tr('Login.errores.vacio');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registrado ${gmail.text}')),
                          );
                          Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => MyHomePage()),(route) => false,
                                );
                        }
                      },
                      child: Text(context.tr('Login.registro')),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(onPressed: () {}, child: Text(context.tr('Login.sesion'))),
            ],
          ),
        ),
      ),
    );
  }
}
