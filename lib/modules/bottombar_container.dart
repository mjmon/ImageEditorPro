
import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color bgColor;
  final Color fgColor;
  final Function ontap;
  final String title;
  final IconData icons;

  const BottomBarContainer(
      {Key key, this.ontap, this.title, this.icons, this.bgColor, this.fgColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width / 5,
        child: Material(
            color: bgColor ?? Colors.black87,
            child: InkWell(
                onTap: ontap,
                child: Column(
                  children: [
                    Icon(
                      icons,
                      color: fgColor ?? Colors.white,
                    ),
                    SizedBox(height: 4),
                    Text(title,
                        style: TextStyle(color: fgColor ?? Colors.white))
                  ],
                ))));

  }
}
