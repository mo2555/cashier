import 'package:flutter/cupertino.dart';

extension SizeHelper on num{

  double appWidth(BuildContext context){
    return (this/100)*MediaQuery.of(context).size.width;
  }

  double appHeight(BuildContext context) {
    return (this / 100) * MediaQuery.of(context).size.height;
  }
}