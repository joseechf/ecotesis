import 'package:flutter/material.dart';

// Widget de footer personalizado y responsivo
class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Registro de depuración para verificar si se está construyendo el widget
    print('DEBUG: CustomFooter.build() llamado');
    
    // Definir colores según la paleta verde especificada
    const Color darkGreen = Color.fromARGB(255, 0, 77, 30);
    const Color mediumGreen = Color.fromARGB(255, 0, 121, 55);
    const Color lightGreen = Color(0xFFa5d6a7);
    const Color backgroundColor = Color(0xFFf5f5f5);

    return Container(
      width: double.infinity,
      color: backgroundColor,
      // Aseguramos que el footer tenga un tamaño mínimo
      constraints: const BoxConstraints(
        minHeight: 200.0,
      ),
      child: Column(
        children: [
          // Línea superior delgada en verde
          Container(
            height: 2,
            width: double.infinity,
            color: mediumGreen,
          ),
          
          // Contenido del footer con diseño responsivo
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Para pantallas grandes (web o tablet horizontal): tres columnas
                if (constraints.maxWidth > 768) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de contacto (izquierda)
                      Expanded(
                        child: _buildContactSection(darkGreen, mediumGreen),
                      ),
                      
                      // Sección de redes sociales (centro)
                      Expanded(
                        child: _buildSocialSection(darkGreen, mediumGreen),
                      ),
                      
                      // Sección de donación (derecha)
                      Expanded(
                        child: _buildDonationSection(darkGreen, mediumGreen),
                      ),
                    ],
                  );
                } 
                // Para pantallas pequeñas (móvil): disposición en columna
                else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sección de contacto
                      _buildContactSection(darkGreen, mediumGreen),
                      
                      const SizedBox(height: 30),
                      
                      // Sección de redes sociales
                      _buildSocialSection(darkGreen, mediumGreen),
                      
                      const SizedBox(height: 30),
                      
                      // Sección de donación
                      _buildDonationSection(darkGreen, mediumGreen),
                    ],
                  );
                }
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Copyright o texto inferior
          const Text(
            '© 2025 EcoAzuero. Todos los derechos reservados.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontFamily: 'Oswald',
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget para la sección de contacto
  Widget _buildContactSection(Color darkGreen, Color mediumGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contacto',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontFamily: 'Oswald',
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Dirección
        Row(
          children: [
            Icon(Icons.location_on, color: mediumGreen, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Dirección: Calle Principal #123, Ciudad, País',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Horario
        Row(
          children: [
            Icon(Icons.access_time, color: mediumGreen, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Horario: Lunes a Viernes, 9:00 AM - 5:00 PM',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Teléfono
        Row(
          children: [
            Icon(Icons.phone, color: mediumGreen, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Teléfono: +507 1234-5678',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Correo electrónico
        Row(
          children: [
            Icon(Icons.email, color: mediumGreen, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Email: info@ecoazuero.org',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget para la sección de redes sociales
  Widget _buildSocialSection(Color darkGreen, Color mediumGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Síguenos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontFamily: 'Oswald',
          ),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Facebook
            IconButton(
              icon: const Icon(Icons.facebook, color: Colors.blue, size: 32),
              onPressed: () {
                // Acción para abrir Facebook
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                side: BorderSide(color: mediumGreen, width: 1),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Instagram
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.purple, size: 32),
              onPressed: () {
                // Acción para abrir Instagram
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                side: BorderSide(color: mediumGreen, width: 1),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // YouTube
            IconButton(
              icon: const Icon(Icons.play_circle_filled, color: Colors.red, size: 32),
              onPressed: () {
                // Acción para abrir YouTube
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                side: BorderSide(color: mediumGreen, width: 1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget para la sección de donación
  Widget _buildDonationSection(Color darkGreen, Color mediumGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apóyanos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontFamily: 'Oswald',
          ),
        ),
        
        const SizedBox(height: 16),
        
        const Text(
          'Tu donación ayuda a conservar y proteger el medio ambiente.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Oswald',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Botón de donación
        ElevatedButton(
          onPressed: () {
            // Acción para donar
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: mediumGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Donar ahora',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oswald',
            ),
          ),
        ),
      ],
    );
  }
}