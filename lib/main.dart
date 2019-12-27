import 'dart:io';
import 'dart:ui';
import 'dart:wasm';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TfliteHome(),
    );
  }
}

class TfliteHome extends StatefulWidget {
  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
  String _model = ssd;
  File _image;

  double _imageWidth;
  double _imageHeigth;
  bool _busy = false;
  List _recogitions;

  @override
  void initState() { 
    super.initState();
    _busy = true;
    
  }

  loadModel() async{
    Tflite.close();
    try{
      String res;
    }
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(File image) async {
    if (image == null) return;
    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener(((ImageInfo info, bool _) {
      setState(() {
        _imageHeigth = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitios = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recogitions = recognitios;
    });
  }

  ssdMobileNet(File image) async {
    var recognitios = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);

    setState(() {
      _recogitions = recognitios;
    });
  }

List <Widget> renderBoxes(Size screen){
  if (_recogitions == null) return [];
  if (_imageHeigth == null || _imageWidth == null)return [];

  double factorX = screen.width;
  double factorY = _imageHeigth / _imageHeigth *  screen.width;

  Color blue = Colors.blue;

  return _recogitions.map((re){
    return Positioned(
      left: re["react"]["x"] + factorX,
      top: re["react"]["y"] + factorY,
      width: re["react"]["w"] + factorX,
      height: re["react"]["h"] + factorY,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: blue,
            width: 3
          )
        ),
        child: Text("${re["detectedClass"]} ${(re["confidenceClass"]*100).toStringAsFixed(0)}",
        style: TextStyle(
          background: Paint()..color =  blue,
          color: Colors.white,
          fontSize: 15
        )
        ),
        
      ),
    );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List <Widget> stackChildren = [];

  stackChildren.add(Positioned(
    top: 0.0,
    left: 0.0,
    width: size.width,
    child: _image == null ? Text("No hay imagen") : Image.file(_image),
  ));
  stackChildren.addAll(renderBoxes(size));
  
  if (_busy) {
    stackChildren.add(Center(
      child: CircularProgressIndicator(),
    ));
  } else {
  }

    return Scaffold(
      appBar: AppBar(
        title: Text("Terminator 2.o"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.flip),
        tooltip: "Selecciona una imagen",
        onPressed: selectFromImagePicker,
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
