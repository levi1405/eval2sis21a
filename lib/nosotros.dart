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

        ),
        child: ListView(
          children: [
            _buildEquipoItem(
              'Gerson Adonay Melara Campos',
              'gerson.melara22@itca.edu.sv',
              'images/gerson.jpeg',
            ),
            _buildEquipoItem(
              'Emilio Alexander Rodriguez Rivera',
              'emilio.rodriguez22@itca.edu.sv',
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
