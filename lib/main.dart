// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'nosotros.dart'; // Importa el archivo nosotros.dart
import 'editar_producto.dart'; // Importa el archivo editar_producto.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductosScreen(),
    );
  }
}

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  String mensaje = ''; // Para mostrar mensajes en la pantalla

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'), // Título de la pantalla
        actions: [
          // Botón para ir a la página "Nosotros"
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NosotrosScreen()), // Navega a la página "Nosotros"
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tb_productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Muestra un indicador de carga si no hay datos disponibles
          }

          List<Widget> productosWidgets = snapshot.data!.docs.map((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre:', // Etiqueta para el nombre del producto
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['nombre']), // Muestra el nombre del producto
                  SizedBox(height: 10.0),
                  Text(
                    'Precio:', // Etiqueta para el precio del producto
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['precio'].toString()), // Muestra el precio del producto
                  SizedBox(height: 10.0),
                  Text(
                    'Stock:', // Etiqueta para el stock del producto
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['stock'].toString()), // Muestra el stock del producto
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _editarProducto(document.id); // Llama a la función para editar el producto
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.orange), // Botón de editar en naranja
                        child: Text('Editar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _confirmarEliminar(document.id); // Llama a la función para confirmar la eliminación del producto
                        },
                        style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 170, 74, 18)), // Botón de eliminar en rojo
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: productosWidgets, // Muestra la lista de productos
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarProductoScreen()), // Navega a la pantalla de registro de productos
          );

          if (resultado != null && resultado == 'guardado') {
            setState(() {
              mensaje = 'Registro guardado'; // Muestra un mensaje cuando se guarda un producto
            });
          }
        },
        child: Icon(Icons.add), // Botón flotante para agregar nuevos productos
      ),
      bottomSheet: mensaje.isNotEmpty
          ? Container(
        color: Colors.green,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mensaje, // Muestra un mensaje en la parte inferior de la pantalla
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mensaje = '';
                });
              },
              child: Text('Cerrar'), // Botón para cerrar el mensaje
            ),
          ],
        ),
      )
          : null,
    );
  }

  void _editarProducto(String documentId) {
    // Navega a la pantalla de edición pasando el ID del documento
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarProductoScreen(documentId)),
    );
  }

  void _confirmarEliminar(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar este documento?'), // Cuadro de diálogo de confirmación
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                _eliminarProducto(documentId); // Llama a la función para eliminar el producto
              },
              style: ElevatedButton.styleFrom(primary: Colors.red), // Botón de eliminar en rojo
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarProducto(String documentId) {
    // Elimina el documento de Firebase
    FirebaseFirestore.instance.collection('tb_productos').doc(documentId).delete();
  }
}

class RegistrarProductoScreen extends StatelessWidget {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Producto'), // Título de la pantalla de registro
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue], // Cambia los colores según tus preferencias
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
                  _agregarProducto(context);
                },
                child: Text('Registrar Producto'), // Botón para registrar el producto
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('Cancelar'), // Botón para cancelar el registro
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarProducto(BuildContext context) {
    String nombre = nombreController.text;
    double precio = double.parse(precioController.text);
    int cantidad = int.parse(cantidadController.text);

    FirebaseFirestore.instance.collection('tb_productos').add({
      'nombre': nombre,
      'precio': precio,
      'stock': cantidad,
    });

    nombreController.clear();
    precioController.clear();
    cantidadController.clear();

    Navigator.of(context).pop('guardado'); // Cierra la pantalla de registro y devuelve 'guardado' como resultado
  }
}
