import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedImage;
  File? _editedImage;

  Future<void> getimageditor() async {
    final imageResult =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        backgroundColor: Color(0xff11A0BF),
        foregroundColor: Colors.white,
        passedImage: _pickedImage!,
      );
    }));

    if (imageResult != null) {
      setState(() {
        _editedImage = imageResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker')),
      body: Container(
        child: Column(children: [
          Expanded(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.amber,
                child: _pickedImage == null
                    ? Text('No Picked Image')
                    : Image.file(_pickedImage!)),
          ),
          Expanded(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.teal,
                child: _editedImage == null
                    ? Text('No Edited Image')
                    :
                    // Image.file(_editedImage),
                    CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.file(
                            _editedImage!,
                            fit: BoxFit.cover,
                            width: 120.0,
                            height: 120.0,
                          ),
                        ))),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile =
                await picker.getImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              setState(() {
                _pickedImage = File(pickedFile.path);
              });
            }

            if (_pickedImage != null) {
              await getimageditor();
            }
          },
          child: Icon(Icons.image_search)),
    );
  }
}
