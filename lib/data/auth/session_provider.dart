/*
Escucha cambios de sesión de Supabase
Decide si hay usuario autenticado
Carga profiles
Fuerza logout si el profile:
no existe
está incompleto
Mantiene el estado global de sesión
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabaseClient.dart';
import 'usuario_modelo.dart';
import 'dart:async';

class SessionProvider extends ChangeNotifier {
  UsuarioModel? _usuario;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  StreamSubscription<AuthState>? _authSub;

  UsuarioModel? get usuario => _usuario;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  SessionProvider();

  void init() {
    final supabase = SupabaseClientSingleton.client;
    _authSub?.cancel();
    _authSub = supabase.auth.onAuthStateChange.listen((data) {
      _handleSession(data.session);
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _handleSession(Session? session) async {
    if (session == null) {
      _usuario = null;
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final user = session.user;

      final response =
          await SupabaseClientSingleton.client
              .from('users_view')
              .select('id, email, rol_actual, estado_rol, activo')
              .eq('id', user.id)
              .maybeSingle();

      if (response != null && response['activo'] == false) {
        await logout();
        _usuario = null;
        _isAuthenticated = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (response == null) {
        _usuario = UsuarioModel(
          id: user.id,
          email: user.email ?? '',
          rolActual: 'sin_rol',
          estadoRol: 'pendiente',
        );
      } else {
        _usuario = UsuarioModel.fromProfile(response);
      }

      _isAuthenticated = true;
    } catch (_) {
      await logout();
      _usuario = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SupabaseClientSingleton.client.auth.signOut();
  }
}
