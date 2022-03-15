import 'package:flutter/material.dart';

class FadeRouteBuilder<T> extends PageRouteBuilder<T>{
  final Widget page;

  FadeRouteBuilder({@required this.page})
    : super(
        pageBuilder: (context, anim1, anim2) => page,
        transitionsBuilder: (context, anim1, anim2, child){
          return FadeTransition(opacity: anim1, child: child);
        }
      );
}