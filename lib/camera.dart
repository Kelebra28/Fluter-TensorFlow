import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/painting.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

void main (){
  runApp(TFliteModelCamera());
}

class TFliteModelCamera extends StatefulWidget {
  @override
  _TFliteModelCameraState createState() => _TFliteModelCameraState();
}

class _TFliteModelCameraState extends State<TFliteModelCamera> {
  String _model = ssd;
  File _photo;

  double _photoWidth;
  double _photoHeight;
  bool _busy = false;

  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/tflite/yolov2_tiny.tflite",
          labels: "assets/tflite/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/tflite/ssd_mobilenet.tflite",
          labels: "assets/tflite/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  selectFromCamera() async {
    var photo = await ImagePicker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(photo);
  }

  predictImage(File photo) async {
    if (photo == null) return;

    if (_model == yolo) {
      await yolov2Tiny(photo);
    } else {
      await ssdMobileNet(photo);
    }

    FileImage(photo)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _photoWidth = info.image.width.toDouble();
            _photoHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _photo = photo;
      _busy = false;
    });
  }

  yolov2Tiny(File photo) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: photo.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobileNet(File photo) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: photo.path, numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_photoWidth == null || _photoHeight == null) return [];

    double factorX = screen.width;
    double factorY = _photoHeight / _photoHeight * screen.width;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color(
                          (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                      .withOpacity(1.0))),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = Colors.cyan,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0,
      left: 0,
      width: size.width,
      child: _photo == null
          ? Center(
            child: Text("Take a picture"),
          )
          : Image.file(_photo),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Camera Activate"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.black,
        tooltip: "Take a picture from the gallery",
        onPressed: selectFromCamera,
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
