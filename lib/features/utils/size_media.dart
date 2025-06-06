import 'package:flutter/cupertino.dart';

double getScreenWith(context, {double resize = 1}){
  return MediaQuery.of(context).size.width*resize;
}
double getScreenHeight(context, {double resize=1}){
  return MediaQuery.of(context).size.height*resize;
}