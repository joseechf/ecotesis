import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';
import 'package:flutter/foundation.dart';

Future<AuthResponse> login({
  required String email,
  required String password,
}) async {
  debugPrint('========== LOGIN ==========');
  debugPrint('Intentando login con email: $email');

  try {
    final response = await SupabaseClientSingleton.client.auth
        .signInWithPassword(email: email, password: password);
    if (response.user != null) {
      final profile =
          await SupabaseClientSingleton.client
              .from('users_view')
              .select('activo')
              .eq('id', response.user!.id)
              .maybeSingle();

      if (profile != null && profile['activo'] == false) {
        await SupabaseClientSingleton.client.auth.signOut();
        throw Exception(
          "Tu cuenta está desactivada. Contacta al administrador.",
        );
      }
    }
    debugPrint('Login exitoso');
    debugPrint('User ID: ${response.user?.id}');
    debugPrint('Session activa: ${response.session != null}');
    debugPrint('========== FIN LOGIN OK ==========');

    return response;
  } on AuthException catch (e, stack) {
    debugPrint('ERROR AuthException en login: ${e.message}');
    debugPrintStack(stackTrace: stack);
    throw Exception(e.message);
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<AuthResponse> signup({
  required String email,
  required String password,
  required String rolSolicitado,
}) async {
  debugPrint('========== SIGNUP ==========');
  debugPrint('Email: $email');
  debugPrint('Rol solicitado: $rolSolicitado');

  try {
    final response = await SupabaseClientSingleton.client.auth.signUp(
      email: email,
      password: password,
      data: {'rol_solicitado': rolSolicitado},
    );

    debugPrint('Signup ejecutado');
    debugPrint('User ID: ${response.user?.id}');
    debugPrint('Email confirmado: ${response.user?.emailConfirmedAt}');
    debugPrint('Session creada: ${response.session != null}');
    debugPrint('========== FIN SIGNUP OK ==========');

    return response;
  } on AuthException catch (e, stack) {
    debugPrint('ERROR AuthException en signup: ${e.message}');
    debugPrintStack(stackTrace: stack);
    throw Exception(e.message);
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> actualizarPassword(String nuevaPassword) async {
  debugPrint('========== ACTUALIZAR PASSWORD ==========');

  try {
    final response = await SupabaseClientSingleton.client.auth.updateUser(
      UserAttributes(password: nuevaPassword),
    );

    if (response.user == null) {
      debugPrint('Error: response.user es null');
      throw Exception('No se pudo actualizar la contraseña');
    }

    debugPrint('Password actualizada correctamente');
    debugPrint('User ID: ${response.user!.id}');
    debugPrint('========== FIN PASSWORD OK ==========');
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> solicitarNuevoRol(String rol) async {
  debugPrint('========== SOLICITAR NUEVO ROL ==========');

  try {
    debugPrint('rol: $rol');
    final userId = SupabaseClientSingleton.client.auth.currentUser!.id;

    final response =
        await SupabaseClientSingleton.client
            .from('profiles')
            .update({'rol_solicitado': rol, 'estado_rol': 'pendiente'})
            .eq('id', userId)
            .select();

    if (response.isEmpty) {
      throw Exception('No se encontró el perfil del usuario');
    }

    debugPrint('Solicitud de rol enviada correctamente');
    debugPrint('========== FIN SOLICITUD OK ==========');
  } catch (e, stack) {
    debugPrint('ERROR EN SOLICITAR ROL: $e');
    debugPrintStack(stackTrace: stack);
    rethrow;
  }
}

Future<bool> eliminarUsuario() async {
  debugPrint('========== ELIMINAR USUARIO (SEGURO) ==========');

  try {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      debugPrint('No hay usuario autenticado');
      return false;
    }

    debugPrint('User ID a desactivar: ${user.id}');

    await Supabase.instance.client.rpc('desactivar_mi_usuario');

    debugPrint('Perfil marcado como inactivo');

    await Supabase.instance.client.auth.signOut();
    debugPrint('Usuario deslogueado');

    debugPrint('========== FIN ELIMINAR USUARIO OK ==========');

    return true;
  } catch (e) {
    debugPrint('ERROR AL ELIMINAR: $e');
    rethrow;
  }
}
