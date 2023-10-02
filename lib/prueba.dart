import 'package:flutter/material.dart';

class NosotrosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de Nosotros'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x3805B3E8), // Azul claro
              Color(0xB006456C), // Azul oscuro
            ],
          ),
        ),
        child: ListView(
          children: [
            _buildEquipoItem(
              'Emilio Alexander Rodriguez Rivera','',
              'images/emilio.jpeg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipoItem(String nombre, String correo, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(nombre),
      subtitle: Text(correo),
    );
  }
}
