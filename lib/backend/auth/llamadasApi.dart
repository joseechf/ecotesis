import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabaseClient.dart';
import 'package:flutter/foundation.dart';

Future<AuthResponse> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await SupabaseClientSingleton.client.auth
        .signInWithPassword(email: email, password: password);
    return response;
  } on AuthException catch (e) {
    throw Exception(e.message);
  } catch (_) {
    throw Exception('Error inesperado en login');
  }
}

Future<AuthResponse> signup({
  required String email,
  required String password,
  required String rolSolicitado,
}) async {
  try {
    final response = await SupabaseClientSingleton.client.auth.signUp(
      email: email,
      password: password,
      data: {'rol_solicitado': rolSolicitado},
    );

    return response;
  } on AuthException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Error inesperado en signup');
  }
}

Future<void> actualizarPassword(String nuevaPassword) async {
  final response = await SupabaseClientSingleton.client.auth.updateUser(
    UserAttributes(password: nuevaPassword),
  );

  if (response.user == null) {
    throw Exception('No se pudo actualizar la contraseña');
  }
}

Future<bool> eliminarUsuario() async {
  try {
    await Supabase.instance.client
        .from('profiles')
        .update({'activo': false})
        .eq('id', Supabase.instance.client.auth.currentUser!.id);

    await Supabase.instance.client.auth.signOut();

    return true;
  } catch (e, stack) {
    debugPrint('eliminarUsuario Error: $e');
    debugPrintStack(stackTrace: stack);
    return false;
  }
}
