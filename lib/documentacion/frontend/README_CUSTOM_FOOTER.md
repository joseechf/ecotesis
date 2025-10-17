# CustomFooter Widget

El widget `CustomFooter` es un componente de footer responsivo para aplicaciones Flutter, inspirado en un diseño web moderno y limpio.

## Características

- Diseño responsivo que se adapta a diferentes tamaños de pantalla
- Tres secciones: contacto, redes sociales y donación
- Paleta de colores verde armónica
- Estilo minimalista y profesional
- Fácil de personalizar y reutilizar

## Uso básico

Para usar el widget `CustomFooter` en tu aplicación, simplemente impórtalo y añádelo a tu pantalla:

```dart
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';

class MiPagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Contenido de tu página
          Expanded(
            child: Container(
              // Tu contenido aquí
            ),
          ),
          
          // Footer personalizado
          CustomFooter(),
        ],
      ),
    );
  }
}
```

## Personalización

El widget `CustomFooter` utiliza una paleta de colores verde predefinida:

- Verde oscuro: `#004d40`
- Verde medio: `#00796b`
- Verde claro: `#a5d6a7`
- Fondo: `#f5f5f5`

Si deseas personalizar estos colores, puedes modificar el código fuente del widget.

## Ejemplo

Puedes ver un ejemplo de uso del widget en la ruta `/ejemplo-footer` de la aplicación. Para acceder a ella, puedes usar:

```dart
Navigator.pushNamed(context, '/ejemplo-footer');
```

## Estructura del widget

El footer está compuesto por tres secciones principales:

### 1. Sección de contacto
- Título: "Contacto"
- Información de contacto con iconos:
  - Dirección
  - Horario
  - Teléfono
  - Correo electrónico

### 2. Sección de redes sociales
- Título: "Síguenos"
- Iconos de redes sociales:
  - Facebook
  - Instagram
  - YouTube

### 3. Sección de donación
- Título: "Apóyanos"
- Texto motivacional
- Botón de donación

## Comportamiento responsivo

- En pantallas grandes (web o tablet horizontal): las tres secciones se muestran en columnas horizontales.
- En pantallas pequeñas (móvil): las secciones se apilan verticalmente y se centran.

## Dependencias

El widget `CustomFooter` no requiere dependencias adicionales más allá de las ya incluidas en el proyecto:

- Flutter
- Material Design Icons
- Fuente Oswald (ya incluida en el proyecto)

## Contribuciones

Si deseas contribuir al desarrollo de este widget, por favor sigue las guías de estilo del proyecto y asegúrate de probar tus cambios en diferentes tamaños de pantalla.