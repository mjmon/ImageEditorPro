import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_pro/modules/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';

final uuid = Uuid();
TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 400;
var height = 400;

List fontsize = [];
var howmuchwidgetis = 0;
List multiwidget = [];
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final File passedImage;
  ImageEditorPro(
      {@required this.backgroundColor,
      @required this.foregroundColor,
      @required this.passedImage});

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey repaintKey = GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;

  int _activeTab = 0;

  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();

    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    fontsize.clear();
    offsets.clear();
    multiwidget.clear();
    howmuchwidgetis = 0;
    _image = widget.passedImage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaf,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: widget.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.crop, color: widget.foregroundColor),
            onPressed: () {
              _cropImage();
            },
          ),
          IconButton(
            icon: Icon(Icons.clear, color: widget.foregroundColor),
            onPressed: () {
              _controller.points.clear();
              setState(() {});
            },
          ),
          TextButton(
              onPressed: () async {
                RenderRepaintBoundary boundary =
                    repaintKey.currentContext.findRenderObject();

                final image = await boundary.toImage();
                final byteData =
                    await image.toByteData(format: ui.ImageByteFormat.png);
                final tempPath = (await getTemporaryDirectory()).path;
                final name = 'profile_${uuid.v1()}';
                final file = File('$tempPath/$name.png');
                await file.writeAsBytes(byteData.buffer.asUint8List(
                    byteData.offsetInBytes, byteData.lengthInBytes));
              },
              child:
                  Text('Done', style: TextStyle(color: widget.foregroundColor)))
        ],
      ),
      body: Center(
        child: Screenshot(
            controller: screenshotController,
            child: RepaintBoundary(
              key: repaintKey,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                if (_image != null)
                  Image.file(
                    _image,
                    height: height.toDouble(),
                    width: width.toDouble(),
                    fit: BoxFit.cover,
                  ),
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          RenderBox object = context.findRenderObject();
                          var _localPosition =
                              object.globalToLocal(details.globalPosition);
                          _points = List.from(_points)..add(_localPosition);
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        _points.add(null);
                      },
                      child: Signat()),
                ),
                Stack(children: [
                  ...multiwidget.asMap().entries.map((f) {
                    return type[f.key] == 1
                        ? EmojiView(
                            left: offsets[f.key].dx,
                            top: offsets[f.key].dy,
                            ontap: () {
                              scaf.currentState.showBottomSheet((context) {
                                return Sliders(
                                  size: f.key,
                                  sizevalue: fontsize[f.key].toDouble(),
                                );
                              });
                            },
                            onpanupdate: (details) {
                              setState(() {
                                offsets[f.key] = Offset(
                                    offsets[f.key].dx + details.delta.dx,
                                    offsets[f.key].dy + details.delta.dy);
                              });
                            },
                            value: f.value.toString(),
                            fontsize: fontsize[f.key].toDouble(),
                            align: TextAlign.center,
                          )
                        : type[f.key] == 2
                            ? TextView(
                                left: offsets[f.key].dx,
                                top: offsets[f.key].dy,
                                ontap: () {
                                  scaf.currentState.showBottomSheet((context) {
                                    return Sliders(
                                      size: f.key,
                                      sizevalue: fontsize[f.key].toDouble(),
                                    );
                                  });
                                },
                                onpanupdate: (details) {
                                  setState(() {
                                    offsets[f.key] = Offset(
                                        offsets[f.key].dx + details.delta.dx,
                                        offsets[f.key].dy + details.delta.dy);
                                  });
                                },
                                value: f.value.toString(),
                                fontsize: fontsize[f.key].toDouble(),
                                align: TextAlign.center,
                              )
                            : Container();
                  })
                ])
              ]),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _activeTab,
          backgroundColor: widget.backgroundColor,
          onTap: (index) async {
            print('index: $index');
            setState(() {
              _activeTab = index;
            });
            //BRUSH
            if (_activeTab == 0) {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          Navigator.of(context).pop();
                        },
                        child: Text('Got it'),
                      )
                    ],
                  );
                },
              );
            }
            //TEXT
            else if (_activeTab == 1) {
              // final value = await Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TextEditorImage()));

              final value = await showTextInputDialog(
                  title: 'Add Text',
                  context: context,
                  textFields: [DialogTextField()]);

              if (value == null || value.first.trim().isEmpty) {
                print('nothing inputed');
              } else {
                print('value string is not empty: $value');
                type.add(2);
                fontsize.add(20);
                offsets.add(Offset.zero);
                multiwidget.add(value.first);
                howmuchwidgetis++;
              }
            }
            //ERASE
            else if (_activeTab == 2) {
              _controller.clear();
              type.clear();
              fontsize.clear();
              offsets.clear();
              multiwidget.clear();
              howmuchwidgetis = 0;
            }
            // // FILTER
            // else if (_activeTab == 3) {
            //   await showModalBottomSheet(
            //       context: context,
            //       builder: (context) {
            //         return ColorPiskersSlider();
            //       });
            // }
            // EMOJI
            else if (_activeTab == 3) {
              var getemojis = showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Emojies();
                  });
              await getemojis.then((value) {
                if (value != null) {
                  type.add(1);
                  fontsize.add(20);
                  offsets.add(Offset.zero);
                  multiwidget.add(value);
                  howmuchwidgetis++;
                }
              });
            }
          },
          items: [
            BottomNavigationBarItem(
                backgroundColor: widget.backgroundColor,
                icon:
                    Icon(FontAwesomeIcons.brush, color: widget.foregroundColor),
                label: 'Brush'),
            BottomNavigationBarItem(
                backgroundColor: widget.backgroundColor,
                icon: Icon(Icons.text_fields, color: widget.foregroundColor),
                label: 'Text'),
            BottomNavigationBarItem(
                backgroundColor: widget.backgroundColor,
                icon: Icon(FontAwesomeIcons.eraser,
                    color: widget.foregroundColor),
                label: 'Eraser'),
            // BottomNavigationBarItem(
            //     backgroundColor: widget.backgroundColor,
            //     icon: Icon(Icons.photo, color: widget.foregroundColor),
            //     label: 'Filter'),
            BottomNavigationBarItem(
                backgroundColor: widget.backgroundColor,
                icon:
                    Icon(FontAwesomeIcons.smile, color: widget.foregroundColor),
                label: 'Emoji')
          ]),
    );
  }

  Future<Null> _cropImage() async {
    var croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: widget.backgroundColor,
            toolbarWidgetColor: widget.foregroundColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  final picker = ImagePicker();
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}
