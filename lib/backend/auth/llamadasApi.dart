import 'package:supabase_flutter/supabase_flutter.dart';

Future<AuthResponse> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
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
    final response = await Supabase.instance.client.auth.signUp(
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
  final response = await Supabase.instance.client.auth.updateUser(
    UserAttributes(password: nuevaPassword),
  );

  if (response.user == null) {
    throw Exception('No se pudo actualizar la contraseña');
  }
}
