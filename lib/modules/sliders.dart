import 'package:flutter/material.dart';

import '../image_editor_pro.dart';

class Sliders extends StatefulWidget {
  final int? size;
  final sizevalue;
  const Sliders({Key? key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(20), child: Text('Slider Size')),
          Divider(
            height: 1,
          ),
          Slider(
              value: slider,
              min: 0.0,
              max: 100.0,
              onChangeEnd: (v) {
                setState(() {
                  fontsize[widget.size!] = v.toInt();
                });
              },
              onChanged: (v) {
                setState(() {
                  slider = v;
                  print(v.toInt());
                  fontsize[widget.size!] = v.toInt();
                });
              }),
        ],
      ),
    );
  }
}
