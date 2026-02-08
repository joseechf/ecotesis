import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../data/auth/session_provider.dart';

bool tieneAlgunoDeLosRoles(BuildContext context, List<String> rolesPermitidos) {
  final session = context.read<SessionProvider>();

  if (session.isLoading) return false;

  return rolesPermitidos.contains(session.usuario?.rolActual);
}
