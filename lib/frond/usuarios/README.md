# Gestión de Usuarios - EcoAzuero

Esta carpeta contiene los componentes necesarios para la gestión de usuarios en la aplicación EcoAzuero, siguiendo las reglas de diseño establecidas en el proyecto.

## Archivos

### 1. gestionUsuario.dart
Pantalla principal que permite a los usuarios registrarse e iniciar sesión. Incluye:
- Formulario con validación de campos
- Animaciones y transiciones suaves
- Diseño responsive con tonos verdes
- Cambio dinámico entre modo registro y login

### 2. estilos.dart
Define las constantes de colores, tamaños y estilos utilizados en toda la aplicación:
- Paleta de colores con tonos verdes
- Tamaños de espaciado y texto
- Tema de Material Design personalizado
- Decoraciones y sombras consistentes

### 3. utilidades.dart
Funciones de utilidad reutilizables:
- Diálogos de alerta y confirmación
- Indicadores de carga
- Validación de correo y contraseña
- Navegación con animaciones
- Mensajes temporales (snackbar)

### 4. widgets.dart
Widgets personalizados reutilizables:
- BotonPersonalizado: Botón con estilo consistente y estado de carga
- CampoTextoPersonalizado: Campo de texto con validación y estilos
- TarjetaAnimada: Tarjeta con animación de aparición
- IndicadorCarga: Indicador de carga personalizado
- TextoAnimado: Texto con animación de aparición

## Uso

### Integración básica
```dart
import 'package:flutter/material.dart';
import 'lib/frond/usuarios/gestionUsuario.dart';
import 'lib/frond/usuarios/estilos.dart';

MaterialApp(
  title: 'EcoAzuero',
  theme: Estilos.tema,
  home: const GestionUsuario(),
)
```

### Navegación a la pantalla de gestión de usuarios
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const GestionUsuario(),
  ),
);
```

### Uso de widgets personalizados
```dart
// Botón personalizado
BotonPersonalizado(
  texto: 'Registrarse',
  onPressed: () {
    // Acción al presionar
  },
  cargando: false,
)

// Campo de texto personalizado
CampoTextoPersonalizado(
  controlador: _correoController,
  etiqueta: 'Correo electrónico',
  icono: Icons.email_outlined,
  tipoTeclado: TextInputType.emailAddress,
  validador: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo';
    }
    return null;
  },
)
```

### Uso de utilidades
```dart
// Mostrar mensaje
Utilidades.mostrarMensaje(context, 'Operación exitosa');

// Validar correo
if (Utilidades.esCorreoValido(correo)) {
  // Correo válido
}

// Navegar con animación
Utilidades.navegarConAnimacion(context, SiguientePantalla());
```
