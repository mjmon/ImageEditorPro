import 'dart:io';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:firexcode/firexcode.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage().xMaterialApp();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _pickedImage;
  File _editedImage;

  Future<void> getimageditor() async {
    final imageResult =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Colors.blue,
        bottomBarColor: Colors.blue,
        passedImage: _pickedImage,
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
                    : Image.file(_pickedImage)),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.teal,
              child: _editedImage == null
                  ? Text('No Edited Image')
                  : Image.file(_editedImage),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile =
                await picker.getImage(source: ImageSource.gallery);
            setState(() {
              _pickedImage = File(pickedFile.path);
            });

            if (_pickedImage != null) {
              await getimageditor();
            }
          },
          child: Icon(Icons.image_search)),
    );
  }
}
