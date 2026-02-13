import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/auth/auth_admin_provider.dart';

class SolicitudesRolScreen extends StatefulWidget {
  const SolicitudesRolScreen({super.key});

  @override
  State<SolicitudesRolScreen> createState() => _SolicitudesRolScreenState();
}

class _SolicitudesRolScreenState extends State<SolicitudesRolScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthAdminProvider>().cargarSolicitudes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthAdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de Rol')),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.solicitudes.isEmpty) {
            return const Center(child: Text('No hay solicitudes pendientes'));
          }

          return ListView.builder(
            itemCount: provider.solicitudes.length,
            itemBuilder: (context, index) {
              final solicitud = provider.solicitudes[index];

              final isProcessing = provider.processingIds.contains(
                solicitud.id,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(solicitud.email),
                  subtitle: Text('Solicita: ${solicitud.rolSolicitado}'),
                  trailing:
                      isProcessing
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  provider.aprobarUsuario(solicitud.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  provider.rechazarUsuario(solicitud.id);
                                },
                              ),
                            ],
                          ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
