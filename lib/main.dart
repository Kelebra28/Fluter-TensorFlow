import 'package:flutter/material.dart';
import 'package:objetoidentioficado/camera.dart';
import 'package:objetoidentioficado/image.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Objeto Identificado',
    initialRoute: '/',
    routes: {
      '/': (context) => Menu(),
      // Cuando naveguemos hacia la ruta "/second", crearemos el Widget Images
      '/images': (context) => Images(),
      '/camera': (context) => Camera()
    },
  ));
}

class Menu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Objeto Identificado"),
      backgroundColor: Colors.black
      ),
      body: Center(child: Text('Que hago')),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),    
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Imagenes'),
              onTap: () {
               Navigator.pushNamed(context, '/images');
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camara'),
              onTap:() {
           Navigator.pushNamed(context, '/camera');
              },
            ),
          ],
        ),
      ),
    );
  }
}
