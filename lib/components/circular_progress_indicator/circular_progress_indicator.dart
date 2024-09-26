import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget circularProgressIndicatorWidget(
    {Color? color, double strokeWidth = 4.0, Color? background}) {
  return Material(
    color: background,
    child: Center(
      child: kIsWeb
          ? CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            )
          : (Platform.isIOS || Platform.isMacOS
              ? CupertinoActivityIndicator(
                  color: color,
                  // strokeWidth: strokeWidth,
                )
              : CircularProgressIndicator(
                  color: color,
                  strokeWidth: strokeWidth,
                )),
    ),
  );
}
