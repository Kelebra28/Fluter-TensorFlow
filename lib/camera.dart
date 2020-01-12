import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(Camera());
}

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
File cameraFile;

  @override
  Widget build(BuildContext context) {
   
    _openCamera() async {
      var photo = await ImagePicker.pickImage(source: ImageSource.camera);
      this.setState((){
        cameraFile = photo;
      });
    }

    return Container(
       child: Text("Camara"),
    );
  }
}