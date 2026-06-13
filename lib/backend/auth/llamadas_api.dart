import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';

Future<AuthResponse> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await SupabaseClientSingleton.client.auth.signInWithPassword(
      email: email,password: password
    );
    if(response.user != null){
      final profile = await SupabaseClientSingleton.client.rpc('leer_usuario').maybeSingle();
      if(profile != null && profile['activo'] == false) {
        await SupabaseClientSingleton.client.auth.signOut();
        throw Exception(
          "Cuenta desactivada"
        );
      }
    }
    return response;
  } on AuthException catch(e){
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
  try {
    final response = await SupabaseClientSingleton.client.auth.signUp(
      email: email,password: password, data: {'rol_solicitado': rolSolicitado},
    );
    return response;
  } on AuthApiException catch(e){
    throw Exception(e.message);
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> actualizarPassword(String nuevaPassword) async {
  try {
    await SupabaseClientSingleton.client.auth.updateUser(
      UserAttributes(password: nuevaPassword),
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> solicitarNuevoRol(String rol) async {
  try {
    await SupabaseClientSingleton.client.rpc(
      'solicitar_rol',params: {'nuevo_rol': rol},
    );
  } catch (e) {
    rethrow;
  }
}

Future<bool> eliminarUsuario() async {
  try {
    // encontrar la sesion actual
    final user = Supabase.instance.client.auth.currentUser;
    if(user == null){
      return false;
    }
    // desactivar al usuario
    await Supabase.instance.client.rpc('desactivar_mi_usuario');
    // cerrar sesion
    await Supabase.instance.client.auth.signOut();
    return true;
  } catch (e) {
    rethrow;
  }
}