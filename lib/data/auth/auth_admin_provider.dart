/*
Cargar solicitudes pendientes
Aprobar usuario
Rechazar usuario
Estados de loading y error
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'usuario_solicitud_modelo.dart';

class AuthAdminProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<UsuarioSolicitudModel> solicitudes = [];
  bool isLoading = false;
  String? error;

  // usuarios que están siendo procesados
  final Set<String> processingIds = {};

  Future<void> cargarSolicitudes() async {
    debugPrint('[Admin] Iniciando carga de solicitudes...');

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _supabase.rpc('get_solicitudes_pendientes');

      debugPrint('[Admin] Respuesta RPC recibida');
      debugPrint('[Admin] Cantidad recibida: ${(response as List).length}');
      debugPrint('[Admin] Data cruda: $response');

      solicitudes =
          response.map((e) => UsuarioSolicitudModel.fromMap(e)).toList();

      debugPrint('[Admin] Solicitudes mapeadas correctamente');
    } catch (e, stack) {
      error = e.toString();
      debugPrint('[Admin][ERROR] cargarSolicitudes → $error');
      debugPrint('$stack');
    } finally {
      isLoading = false;
      debugPrint('[Admin] Finalizó carga de solicitudes');
      notifyListeners();
    }
  }

  Future<void> aprobarUsuario(String userId) async {
    debugPrint('[Admin] Aprobando usuario: $userId');

    try {
      processingIds.add(userId);
      error = null;
      notifyListeners();

      await _supabase.rpc(
        'approve_role_request',
        params: {'target_user': userId},
      );

      debugPrint('[Admin] Usuario aprobado correctamente: $userId');

      // eliminar de la lista local
      solicitudes.removeWhere((s) => s.id == userId);

      debugPrint('[Admin] Usuario removido de lista local');
    } catch (e, stack) {
      error = e.toString();
      debugPrint('[Admin][ERROR] aprobarUsuario → $error');
      debugPrint('$stack');
    } finally {
      processingIds.remove(userId);
      debugPrint('[Admin] Finalizó proceso de aprobación: $userId');
      notifyListeners();
    }
  }

  Future<void> rechazarUsuario(String userId) async {
    debugPrint('[Admin] Rechazando usuario: $userId');

    try {
      processingIds.add(userId);
      error = null;
      notifyListeners();

      await _supabase.rpc(
        'reject_role_request',
        params: {'target_user': userId},
      );

      debugPrint('[Admin] Usuario rechazado correctamente: $userId');

      solicitudes.removeWhere((s) => s.id == userId);

      debugPrint('[Admin] Usuario removido de lista local');
    } catch (e, stack) {
      error = e.toString();
      debugPrint('[Admin][ERROR] rechazarUsuario → $error');
      debugPrint('$stack');
    } finally {
      processingIds.remove(userId);
      debugPrint('[Admin] Finalizó proceso de rechazo: $userId');
      notifyListeners();
    }
  }
}
