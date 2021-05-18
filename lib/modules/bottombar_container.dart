import 'package:firexcode/firexcode.dart';

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
    return xColumnCC
        .list([
          icons.xIcons(color: fgColor ?? Colors.white),
          4.0.sizedHeight(),
          title.xText(color: fgColor ?? Colors.white)
        ])
        .xInkWell(onTap: ontap)
        .xMaterial(
          color: bgColor ?? Colors.black87,
        )
        .xContainer(padding: EdgeInsets.all(0.0), width: xwidth(context) / 5);
  }
}
