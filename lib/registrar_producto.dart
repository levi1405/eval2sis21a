import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String mensaje = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tb_productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
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
                    'Nombre:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['nombre']),
                  SizedBox(height: 10.0),
                  Text(
                    'Precio:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['precio'].toString()),
                  SizedBox(height: 10.0),
                  Text(
                    'Stock:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['stock'].toString()),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: productosWidgets,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarProductoScreen()),
          );

          if (resultado != null && resultado == 'guardado') {
            setState(() {
              mensaje = 'Registro guardado';
            });
          }
        },
        child: Icon(Icons.add),
      ),
      bottomSheet: mensaje.isNotEmpty
          ? Container(
        color: Colors.green,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mensaje,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mensaje = '';
                });
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      )
          : null,
    );
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
        title: Text('Registrar Producto'),
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
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cantidadController,
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _agregarProducto(context);
                  },
                  child: Text('Registrar Producto'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Cancelar'),
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

    FirebaseFirestore.instance.collection('tb_productos').add({
      'nombre': nombre,
      'precio': precio,
      'stock': cantidad,
    });

    nombreController.clear();
    precioController.clear();
    cantidadController.clear();

    Navigator.of(context).pop('guardado');
  }
}
