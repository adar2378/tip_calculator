import 'package:flutter/material.dart';
import 'package:tipcalculator/screen/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var sliderTheme = SliderTheme.of(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xFFB0C5D6),
          primarySwatch: Colors.blue,
          sliderTheme: sliderTheme.copyWith(
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Color(0xFF8DA2F5),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10,
            ),
            valueIndicatorColor: Colors.transparent,
            overlayColor: Colors.black.withOpacity(.1),
          )),
      home: MyHomePage(),
    );
  }
}
