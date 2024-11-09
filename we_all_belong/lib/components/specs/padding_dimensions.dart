import 'package:flutter/cupertino.dart';

class PaddingDimensions{
  bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.height <700;
  bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.height >700;
  bool isBig(BuildContext context) =>
      MediaQuery.of(context).size.height >=850;
}