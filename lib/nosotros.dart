import 'package:flutter/material.dart';

class NosotrosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de Nosotros'), // Título de la página
      ),
      body: Container(
        decoration: BoxDecoration(), // Decoración del contenedor (puede dejarse en blanco)
        child: ListView(
          children: [
            _buildEquipoItem(
              context,
              'Gerson Adonay Melara Campos', // Nombre
              'gerson.melara22@itca.edu.sv', // Correo
              'images/gerson.jpeg', // Ruta de la imagen
              'Apellido: Melara Campos', // Detalle 1
              'Edad: 19 años', // Detalle 2
            ),
            _buildEquipoItem(
              context,
              'Emilio Alexander Rodriguez Rivera', // Nombre
              'emilio.rodriguez22@itca.edu.sv', // Correo
              'images/emilio.jpeg', // Ruta de la imagen
              'Apellido: Rodriguez Rivera', // Detalle 1
              'Edad: 23 años', // Detalle 2
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipoItem(
      BuildContext context,
      String nombre,
      String correo,
      String imagePath,
      String detalles1,
      String detalles2,
      ) {
    return GestureDetector(
      onTap: () {
        _showEquipoDetails(context, nombre, correo, imagePath, detalles1, detalles2);
      },
      child: Container(
        margin: EdgeInsets.all(16.0), // Margen alrededor del contenedor
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath), // Imagen circular
            ),
            SizedBox(height: 10), // Espacio vertical
            Text(
              nombre,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Nombre en negrita
            ),
            Text(correo), // Correo
          ],
        ),
      ),
    );
  }

  void _showEquipoDetails(
      BuildContext context,
      String nombre,
      String correo,
      String imagePath,
      String detalles1,
      String detalles2,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Equipo'), // Título del cuadro de diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(imagePath), // Imagen circular
              ),
              SizedBox(height: 10), // Espacio vertical
              Text(
                nombre,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Nombre en negrita
              ),
              Text(correo), // Correo
              SizedBox(height: 10), // Espacio vertical
              Text(
                detalles1,
                style: TextStyle(fontWeight: FontWeight.bold), // Detalle 1 en negrita
              ),
              Text(
                detalles2,
                style: TextStyle(fontWeight: FontWeight.bold), // Detalle 2 en negrita
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Botón para cerrar el cuadro de diálogo
              },
              child: Text('Cerrar'), // Texto del botón
            ),
          ],
        );
      },
    );
  }
}
