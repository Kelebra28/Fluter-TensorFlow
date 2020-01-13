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
      appBar: AppBar(
          centerTitle: true,
          title: Text("∫Robot Eye∫"),
          backgroundColor: Colors.black),
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://scontent.fmex1-1.fna.fbcdn.net/v/t1.0-9/49864265_1024109577795711_3220780144020946944_n.jpg?_nc_cat=110&_nc_ohc=Z7_WbgF7AR0AX-JdwtB&_nc_ht=scontent.fmex1-1.fna&oh=2bb18578e66d3aad7f78edfdacb1e36c&oe=5EA108E0'),
                fit: BoxFit.cover)),
        child: Center(
          child: Text(
            "Everyone can learn artificial intelligence",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Text('Menu',
                style: TextStyle(
                  color: Colors.white
                ),),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://singularityhub.com/wp-content/uploads/2018/11/multicolored-brain-connections_shutterstock_347864354-1068x601.jpg'),
                        fit: BoxFit.cover))),
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
              onTap: () {
                Navigator.pushNamed(context, '/camera');
              },
            ),
          ],
        ),
      ),
    );
  }
}
