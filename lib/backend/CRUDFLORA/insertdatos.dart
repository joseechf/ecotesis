
import '../utilidades/item.dart';
import 'package:flutter/material.dart';
import '../detectaplataforma.dart';
import 'package:uuid/uuid.dart';
import '../utilidades/variableglobal.dart';

class insertBD extends StatefulWidget {
  const insertBD({Key? key}) : super(key: key);

  @override
  _IuInsertBD createState() => _IuInsertBD();
}

class _IuInsertBD extends State<insertBD> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _tipoController,
              decoration: const InputDecoration(labelText: 'tipo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime fecha = DateTime.now();
                Variableglobal().ultAct = fecha;
                Variableglobal().setUltActSQLite(fecha);
                  final item = Item(
                    id: Uuid().v4(),
                    name: _nameController.text,
                    tipo: _tipoController.text,
                    ultAct: Variableglobal().getUltActSQLite(),
                  );
                    final crud sincronizar = crud();
                    final respuesta = await sincronizar.insertarSincronizado(item);
                    _nameController.clear();
                    _tipoController.clear();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(respuesta)));
              },
              child: Text('insertar datos'),
            ),
          ],
        ),
      ),
    );
  }

}

