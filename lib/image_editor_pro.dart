import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_pro/modules/color_piskers_slider.dart';
import 'package:image_editor_pro/modules/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:firexcode/firexcode.dart';
import 'package:image_cropper/image_cropper.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;

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
  final GlobalKey globalKey = GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
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
      appBar: AppBar(
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
              onPressed: () {
                screenshotController
                    .capture(
                        delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                    .then((binaryIntList) async {
                  //print("Capture Done");

                  // final paths = await getDownloadsDirectory();
                  final paths = await getTemporaryDirectory();

                  final file = await File(
                          '${paths.path}/' + DateTime.now().toString() + '.jpg')
                      .create();
                  file.writeAsBytesSync(binaryIntList);
                  Navigator.pop(context, file);
                }).catchError((onError) {
                  print('Done catchError: $onError');
                });
              },
              child:
                  Text('Done', style: TextStyle(color: widget.foregroundColor)))
        ],
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            print('index: index');
          },
          items: [
            BottomNavigationBarItem(
                icon:
                    Icon(FontAwesomeIcons.brush, color: widget.foregroundColor),
                label: 'Brush'),
            BottomNavigationBarItem(
                icon: Icon(Icons.text_fields), label: 'Text'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.eraser), label: 'Eraser'),
            BottomNavigationBarItem(icon: null, label: ''),
            BottomNavigationBarItem(icon: null, label: '')
          ]),
    );

    return Screenshot(
      controller: screenshotController,
      child: RepaintBoundary(
          key: globalKey,
          child: xStack.list(
            [
              _image != null
                  ? Image.file(
                      _image,
                      height: height.toDouble(),
                      width: width.toDouble(),
                      fit: BoxFit.cover,
                    )
                  : Container(),
              Signat().xGesture(
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
              ).xContainer(padding: EdgeInsets.all(0.0)),
              xStack.list(
                multiwidget.asMap().entries.map((f) {
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
                }).toList(),
              )
            ],
          )).xContainer(
        // margin: EdgeInsets.all(5),
        // color: widget.foregroundColor,
        width: width.toDouble(),
        height: height.toDouble(),
      ),
    ).xCenter().xScaffold(
        backgroundColor: Colors.grey,
        key: scaf,
        appBar: AppBar(
          backgroundColor: widget.backgroundColor,
          actions: <Widget>[
            Icon(Icons.crop, color: widget.foregroundColor).xIconButton(
                onPressed: () {
              _cropImage();
            }),
            Icon(FontAwesomeIcons.boxes, color: widget.foregroundColor)
                .xIconButton(onPressed: () {
              showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: 'Select Height Width'.text(),
                      actions: <Widget>[
                        () {
                          setState(() {
                            height = int.parse(heightcontroler.text);
                            width = int.parse(widthcontroler.text);
                          });
                          heightcontroler.clear();
                          widthcontroler.clear();
                          Navigator.pop(context);
                        }.xFlatButton(child: 'Done'.text()),
                      ],
                      content: SingleChildScrollView(
                        child: xColumnSS.list(
                          [
                            'Define Height'.text(),
                            10.0.sizedHeight(),
                            TextField(
                                controller: heightcontroler,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: 'Height',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder())),
                            10.0.sizedHeight(),
                            'Define Width'.text(),
                            10.0.sizedHeight(),
                            TextField(
                                controller: widthcontroler,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: 'Width',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder())),
                          ],
                        ),
                      ),
                    );
                  });
            }),
            Icon(Icons.clear, color: widget.foregroundColor).xIconButton(
                onPressed: () {
              _controller.points.clear();
              setState(() {});
            }),
            'Done'.text().xFlatButton(
                primary: widget.foregroundColor,
                onPressed: () {
                  screenshotController
                      .capture(
                          delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                      .then((binaryIntList) async {
                    //print("Capture Done");

                    // final paths = await getDownloadsDirectory();
                    final paths = await getTemporaryDirectory();

                    final file = await File('${paths.path}/' +
                            DateTime.now().toString() +
                            '.jpg')
                        .create();
                    file.writeAsBytesSync(binaryIntList);
                    Navigator.pop(context, file);
                  }).catchError((onError) {
                    print('Done catchError: $onError');
                  });
                })
          ],
        ),
        bottomNavigationBar: XListView(
          scrollDirection: Axis.horizontal,
        ).list(
          <Widget>[
            BottomBarContainer(
              icons: FontAwesomeIcons.brush,
              bgColor: widget.backgroundColor,
              fgColor: widget.foregroundColor,
              ontap: () {
                // raise the [showDialog] widget
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: 'Pick a color!'.text(),
                      content: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ).xSingleChildScroolView(),
                      actions: <Widget>[
                        'Got it'.text().xFlatButton(
                          onPressed: () {
                            setState(() => currentColor = pickerColor);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
              title: 'Brush',
            ),
            BottomBarContainer(
              bgColor: widget.backgroundColor,
              fgColor: widget.foregroundColor,
              icons: Icons.text_fields,
              ontap: () async {
                final value = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TextEditorImage()));
                if (value.toString().isEmpty) {
                  print('true');
                } else {
                  type.add(2);
                  fontsize.add(20);
                  offsets.add(Offset.zero);
                  multiwidget.add(value);
                  howmuchwidgetis++;
                }
              },
              title: 'Text',
            ),
            BottomBarContainer(
              bgColor: widget.backgroundColor,
              fgColor: widget.foregroundColor,
              icons: FontAwesomeIcons.eraser,
              ontap: () {
                _controller.clear();
                type.clear();
                fontsize.clear();
                offsets.clear();
                multiwidget.clear();
                howmuchwidgetis = 0;
              },
              title: 'Eraser',
            ),
            BottomBarContainer(
              bgColor: widget.backgroundColor,
              fgColor: widget.foregroundColor,
              icons: Icons.photo,
              ontap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ColorPiskersSlider();
                    });
              },
              title: 'Filter',
            ),
            BottomBarContainer(
              bgColor: widget.backgroundColor,
              fgColor: widget.foregroundColor,
              icons: FontAwesomeIcons.smile,
              ontap: () {
                var getemojis = showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Emojies();
                    });
                getemojis.then((value) {
                  if (value != null) {
                    type.add(1);
                    fontsize.add(20);
                    offsets.add(Offset.zero);
                    multiwidget.add(value);
                    howmuchwidgetis++;
                  }
                });
              },
              title: 'Emoji',
            ),
          ],
        ).xContainer(
          padding: EdgeInsets.all(0.0),
          blurRadius: 10.9,
          shadowColor: widget.backgroundColor,
          height: 70,
        ));
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
