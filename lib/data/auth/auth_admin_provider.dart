/*
cargar solicitudes pendientes para que el administrador lo evalue
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';
import 'usuario_solicitud_modelo.dart';

class AuthAdminProvider extends ChangeNotifier{
  final SupabaseClient _supabase = SupabaseClientSingleton.client;
  List<UsuarioSolicitudModel> solicitudes = [];
  bool isLoading = false;
  String? error;

  //usuarios que están siendo procesados
  final Set<String> usuarioEvaluado = {};

  Future<void> cargarSolicitudes() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await _supabase.rpc('get_solicitudes_pendientes');
      solicitudes = (response as List).map<UsuarioSolicitudModel>((e) => UsuarioSolicitudModel.fromMap(e)).toList();
    } catch (e) {
      error = e.toString();
      debugPrint('\n $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> aprobarUsuario(String userId) async {
    try {
      usuarioEvaluado.add(userId);
      error = null;
      notifyListeners();
      await _supabase.rpc('approve_role_request', params: {'target_user': userId},);
      solicitudes.removeWhere((s) => s.id == userId);
    } catch (e) {
      error = e.toString();
      debugPrint('\n $error');
    } finally {
      usuarioEvaluado.remove(userId);
      notifyListeners();
    }
  }
  
  Future<void> rechazarUsuario(String userId) async {
  try {
      usuarioEvaluado.add(userId);
      error = null;
      notifyListeners();
      await _supabase.rpc('reject_role_request', params: {'target_user': userId},);
      solicitudes.removeWhere((s) => s.id == userId);
    } catch (e) {
      error = e.toString();
      debugPrint('\n $error');
    } finally {
      usuarioEvaluado.remove(userId);
      notifyListeners();
    }
  }
}

