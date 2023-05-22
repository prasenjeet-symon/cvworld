// a function to determine the page width given the context
import 'package:flutter/material.dart';

double pageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600
      ? MediaQuery.of(context).size.width * 0.7
      : MediaQuery.of(context).size.width;
}

int flexNumber(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 ? 1 : 0;
}
