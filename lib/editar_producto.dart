import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clase para la pantalla de edición de productos
class EditarProductoScreen extends StatefulWidget {
  final String documentId; // ID del producto a editar

  EditarProductoScreen(this.documentId);

  @override
  _EditarProductoScreenState createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Recuperar los datos del producto a editar y mostrarlos en los campos
    _cargarDatosProducto();
  }

  // Método para cargar los datos del producto a editar desde Firestore
  void _cargarDatosProducto() async {
    final producto = await FirebaseFirestore.instance
        .collection('tb_productos')
        .doc(widget.documentId)
        .get();

    if (producto.exists) {
      final data = producto.data() as Map<String, dynamic>;
      setState(() {
        nombreController.text = data['nombre'];
        precioController.text = data['precio'].toString();
        cantidadController.text = data['stock'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'), // Título de la pantalla de edición
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue], // Personaliza los colores según tus preferencias
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'), // Campo de entrada para el nombre del producto
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'), // Campo de entrada para el precio del producto
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'), // Campo de entrada para la cantidad del producto
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _editarProducto(context);
                },
                child: Text('Guardar Cambios'), // Botón para guardar los cambios
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('Cancelar'), // Botón para cancelar la edición
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para guardar los cambios realizados en el producto
  void _editarProducto(BuildContext context) {
    String nombre = nombreController.text;
    double precio = double.parse(precioController.text);
    int cantidad = int.parse(cantidadController.text);

    // Actualiza los datos del producto en Firestore
    FirebaseFirestore.instance.collection('tb_productos').doc(widget.documentId).update({
      'nombre': nombre,
      'precio': precio,
      'stock': cantidad,
    });

    Navigator.of(context).pop('editado'); // Cierra la pantalla de edición y devuelve 'editado' como resultado
  }
}
