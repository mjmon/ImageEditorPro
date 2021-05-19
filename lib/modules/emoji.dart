// import 'package:firexcode/firexcode.dart';

import 'package:flutter/material.dart';

class EmojiView extends StatefulWidget {
  final double left;
  final double top;
  final Function ontap;
  final Function(DragUpdateDetails) onpanupdate;
  final double fontsize;
  final String value;
  final TextAlign align;
  const EmojiView(
      {Key key,
      this.left,
      this.top,
      this.ontap,
      this.onpanupdate,
      this.fontsize,
      this.value,
      this.align})
      : super(key: key);
  @override
  _EmojiViewState createState() => _EmojiViewState();
}

class _EmojiViewState extends State<EmojiView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: widget.ontap,
        onPanUpdate: widget.onpanupdate,
        child: Text(widget.value,
            textAlign: widget.align,
            style: TextStyle(
              fontSize: widget.fontsize,
            )),
      ),
    );
    // return widget.value
    //     .text(
    //         textAlign: widget.align,
    //         style: TextStyle(
    //           fontSize: widget.fontsize,
    //         ))
    //     .xGesture(
    //       onTap: widget.ontap,
    //       onPanUpdate: widget.onpanupdate,
    //     )
    //     .xPositioned(
    //       left: widget.left,
    //       top: widget.top,
    //     );
  }
}
