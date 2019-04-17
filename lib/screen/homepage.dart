import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tipcalculator/bloc/tip_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController myController;
  AnimationController myController2;
  AnimationController myController3;

  IconButton myIcon;
  bool isOffstaged;
  String cardText;
  double value, splitValue;
  TextEditingController _textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.initState();
    myController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    myController.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed) {
        myController2.forward();
      }
    });
    myController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    myController3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    myController2.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed) {
        myController3.forward();
      }
    });

    myIcon = null;
    cardText = "Don't think I'm gonna be nice :3";
    value = 0;
    splitValue = 1;
    isOffstaged = true;
    _textEditingController = TextEditingController();
    _textEditingController.addListener(listener);
    if (mounted) {
      myController.forward();
    }
  }

  String curseGenerator(int tips, int splits) {
    String result = "";
    Random rnd = Random();

    List<String> noTips = [
      "Add more tips already, wtf!",
      "You think waitressing is fun???",
      "Don't be a cheapass! wtf is wrong with you?!"
    ];
    List<String> oneSplit = [
      "Feeling rich? Donate some to me ;)",
      "Are you trying to prove that you've got the moneh??",
      "Why pay alone, when you can split :3",
      "Remind your friends, Sharing is caring :3"
    ];
    List<String> party = [
      "Having a party without me? >_<",
      "I'm scared of these many people!",
      "Why not invite the whole city??",
      "Tips calculators feel hungry too :("
    ];

    List<String> nothing = [
      "What a fatass!!",
      "Ez fats!!",
      "Your old clothes will miss you soon!",
      "Don't forget to drink enough water!",
    ];

    if (tips < 15) {
      int tempIndex = rnd.nextInt(noTips.length - 1);
      result = noTips[tempIndex];
    } else if (splits <= 5 && splits > 1 && tips > 15) {
      int tempIndex = rnd.nextInt(nothing.length - 1);
      result = nothing[tempIndex];
    } else if (splits < 2) {
      int tempIndex = rnd.nextInt(oneSplit.length - 1);
      result = oneSplit[tempIndex];
    } else if (splits > 5) {
      int tempIndex = rnd.nextInt(party.length - 1);
      result = party[tempIndex];
    }
    return result;
  }

  @override
  void dispose() {
    tipBloc.dispose();
    super.dispose();
  }

  void listener() {
    tipBloc.calculateTip(
        value,
        _textEditingController.value.text.length < 1
            ? 0
            : double.parse(_textEditingController.value.text));
    if (_textEditingController.value.text.length > 0) {
      setState(() {
        isOffstaged = false;
      });
    } else if (_textEditingController.value.text.length == 0) {
      setState(() {
        isOffstaged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<double>(
          stream: tipBloc.currentTip,
          initialData: 0,
          builder: (context, snapshot) {
            return StreamBuilder<double>(
                stream: tipBloc.getTotal,
                initialData: 0,
                builder: (context, snapshotTotal) {
                  return Stack(children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE0C3FC),
                          Color(0xFF8DA2F8),
                        ],
                      )),
                    ),
                    Column(
                      children: <Widget>[
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Tip n Split",
                                style: TextStyle(
                                    fontFamily: "Cute Font",
                                    color: Colors.white,
                                    fontSize: 36),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              end: Offset(0.0, 0),
                              begin: Offset(1.0, 0),
                            ).animate(CurvedAnimation(
                                parent: myController.view,
                                curve: Curves.easeInOut,
                                reverseCurve: Curves.easeOut)),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              elevation: 4,
                              margin: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Bill",
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFFB0C5D6),
                                                  fontWeight: FontWeight.w900),
                                            )),
                                        Spacer(
                                          flex: 7,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Stack(
                                              children: <Widget>[
                                                TextField(
                                                  // autofocus: true,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        8),
                                                  ],
                                                  cursorColor:
                                                      Color(0xFFB0C5D6),
                                                  controller:
                                                      _textEditingController,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: .6),
                                                  maxLines: 1,
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(),
                                                  decoration: InputDecoration(
                                                      hintText: " Input..",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.white54),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 6,
                                                              bottom: 6,
                                                              left: 20,
                                                              right: 26),
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF6E8FFF)),
                                                ),
                                                Positioned(
                                                  right: -8,
                                                  top: -9,
                                                  child: Offstage(
                                                    offstage: isOffstaged,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      color: Colors.white,
                                                      iconSize: 17,
                                                      onPressed: () {
                                                        _textEditingController
                                                            .clear();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 6,
                                                  top: 7,
                                                  child: Icon(
                                                    Icons.attach_money,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Tip",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFB0C5D6),
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "\$${snapshot.data.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Color(0xFF6E8FFF),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: .6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 4,
                                    color: Color(0xFF6D8DFC),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Total",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFB0C5D6),
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "\$${snapshotTotal.data.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Color(0xFF6E8FFF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: .6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              end: Offset(0.0, 0),
                              begin: Offset(1.0, 0),
                            ).animate(CurvedAnimation(
                                parent: myController2.view,
                                curve: Curves.easeInOut,
                                reverseCurve: Curves.easeOut)),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Tip",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFB0C5D6),
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "${value.floor()}%",
                                            style: TextStyle(
                                                color: Color(0xFF6E8FFF),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: .6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 8,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFFE0C3FC),
                                                  Color(0xFF8DA2F8),
                                                ],
                                              )),
                                        ),
                                        Slider(
                                          onChangeEnd: (v) {
                                            setState(() {
                                              cardText = curseGenerator(
                                                  value.floor(),
                                                  splitValue.floor());
                                            });
                                          },
                                          onChanged: (v) {
                                            setState(() {
                                              value = v;

                                              tipBloc.calculateTip(
                                                  value,
                                                  _textEditingController.value
                                                              .text.length <
                                                          1
                                                      ? 0
                                                      : double.parse(
                                                          _textEditingController
                                                              .value.text));
                                            });
                                          },
                                          value: value,
                                          max: 100,
                                          min: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Split",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFB0C5D6),
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "${splitValue.floor()}",
                                            style: TextStyle(
                                                color: Color(0xFF6E8FFF),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: .6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 8,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFFE0C3FC),
                                                  Color(0xFF8DA2F8),
                                                ],
                                              )),
                                        ),
                                        Slider(
                                          onChangeEnd: (v) {
                                            setState(() {
                                              cardText = curseGenerator(
                                                  value.floor(),
                                                  splitValue.floor());
                                            });
                                          },
                                          onChanged: (v) {
                                            setState(() {
                                              splitValue = v;
                                              cardText = curseGenerator(
                                                  value.floor(),
                                                  splitValue.floor());
                                            });
                                          },
                                          value: splitValue,
                                          max: 20,
                                          min: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 4,
                                    color: Color(0xFF6D8DFC),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Splits",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFB0C5D6),
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "\$${(snapshotTotal.data / splitValue.floor()).toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Color(0xFF6E8FFF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: .6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              end: Offset(0.0, 0),
                              begin: Offset(1.0, 0),
                            ).animate(CurvedAnimation(
                                parent: myController3.view,
                                curve: Curves.easeInOut,
                                reverseCurve: Curves.easeOut)),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              elevation: 4,
                              margin: EdgeInsets.all(16),
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(cardText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF8DA2F8)
                                                  .withOpacity(.8),
                                              fontStyle: FontStyle.italic,
                                              letterSpacing: 1.2)),
                                    ],
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ]);
                });
          }),
    );
  }
}
