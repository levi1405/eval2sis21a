// Importación de paquetes y archivos necesarios
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Función principal que inicia la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductosScreen(), // Define la pantalla principal como ProductosScreen
    );
  }
}

// Clase para la pantalla principal de productos
class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

// Estado de la pantalla principal de productos
class _ProductosScreenState extends State<ProductosScreen> {
  // Controladores de texto para los campos de entrada
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  // Variable para mostrar mensajes en la pantalla
  String mensaje = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'), // Título de la pantalla
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tb_productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Muestra un indicador de carga si no hay datos disponibles
          }

          // Crea una lista de widgets para mostrar la información de los productos
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
}

// Clase para la pantalla de registro de productos
class RegistrarProductoScreen extends StatelessWidget {
  // Controladores de texto para los campos de entrada
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Producto'), // Título de la pantalla de registro
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/gerson.jpeg', // Reemplaza con la ruta de tu imagen
              fit: BoxFit.cover,
            ),
          ),
          Padding(
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
        ],
      ),
    );
  }

  void _agregarProducto(BuildContext context) {
    String nombre = nombreController.text;
    double precio = double.parse(precioController.text);
    int cantidad = int.parse(cantidadController.text);

    // Agrega un nuevo producto a Firestore
    FirebaseFirestore.instance.collection('tb_productos').add({
      'nombre': nombre,
      'precio': precio,
      'stock': cantidad,
    });

    // Limpia los controladores de texto
    nombreController.clear();
    precioController.clear();
    cantidadController.clear();

    Navigator.of(context).pop('guardado'); // Cierra la pantalla de registro y devuelve 'guardado' como resultado
  }
}
