// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/widgets.dart';

final Map<int, Color> m2SwatchColors = <int, Color>{
  50: const Color(0xfff2e7fe),
  100: const Color(0xffd7b7fd),
  200: const Color(0xffbb86fc),
  300: const Color(0xff9e55fc),
  400: const Color(0xff7f22fd),
  500: const Color(0xff6200ee),
  600: const Color(0xff4b00d1),
  700: const Color(0xff3700b3),
  800: const Color(0xff270096),
  900: const Color(0xff270096),
};
final MaterialColor m2Swatch = MaterialColor(m2SwatchColors[500].value, m2SwatchColors);

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
// TODO(gspencergoog): Remove once TargetPlatform includes all desktop platforms.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Density';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class OptionModel extends ChangeNotifier {
  double get size => _size;
  double _size = 1.0;
  set size(double size) {
    if (size != _size) {
      _size = size;
      notifyListeners();
    }
  }

  VisualDensity get density => _density;
  VisualDensity _density = const VisualDensity();
  set density(VisualDensity density) {
    if (density != _density) {
      _density = density;
      notifyListeners();
    }
  }

  bool get enable => _enable;
  bool _enable = true;
  set enable(bool enable) {
    if (enable != _enable) {
      _enable = enable;
      notifyListeners();
    }
  }

  bool get slowAnimations => _slowAnimations;
  bool _slowAnimations = false;
  set slowAnimations(bool slowAnimations) {
    if (slowAnimations != _slowAnimations) {
      _slowAnimations = slowAnimations;
      notifyListeners();
    }
  }

  bool get rtl => _rtl;
  bool _rtl = false;
  set rtl(bool rtl) {
    if (rtl != _rtl) {
      _rtl = rtl;
      notifyListeners();
    }
  }

  bool get longText => _longText;
  bool _longText = false;
  set longText(bool longText) {
    if (longText != _longText) {
      _longText = longText;
      notifyListeners();
    }
  }

  void reset() {
    final OptionModel defaultModel = OptionModel();
    _size = defaultModel._size;
    _enable = defaultModel._enable;
    _slowAnimations = defaultModel._slowAnimations;
    _longText = defaultModel._longText;
    _density = defaultModel._density;
    _rtl = defaultModel._rtl;
    notifyListeners();
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({Key key, @required this.label, @required this.child})
      : assert(label != null),
        assert(child != null),
        super(key: key);

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Align(alignment: AlignmentDirectional.topStart, child: Text(label, textAlign: TextAlign.start)),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final OptionModel _model = OptionModel();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: densitySelected.length, vsync: this);
    _model.addListener(_modelChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _model.removeListener(_modelChanged);
  }

  void _modelChanged() {
    setState(() {});
  }

  double sliderValue = 0.0;
  List<VisualDensity> densitySelected = <VisualDensity>[
    VisualDensity.standard,
    const VisualDensity(horizontal: -1.5, vertical: -1.5),
    const VisualDensity(horizontal: -3.0, vertical: -3.0),
  ];
  TabController controller;
  List<bool> checkboxValues = <bool>[false, false, false, false];
  List<IconData> iconValues = <IconData>[Icons.arrow_back, Icons.play_arrow, Icons.arrow_forward];
  List<String> chipValues = <String>['Potato', 'Computer'];
  int radioValue = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: m2Swatch,
    );
    final Widget label = Text(_model.rtl ? 'اضغط علي' : 'Press Me');

    final List<Widget> tiles = <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 400,
            child: TabBar(
              onTap: (int index) {
                _model.density = densitySelected[index];
              },
              controller: controller,
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  child: const Text('STANDARD'),
                ),
                Tab(
                  child: const Text('COMFORTABLE'),
                ),
                Tab(
                  child: const Text('COMPACT'),
                ),
              ],
            ),
          ),
        ),
      ),
      _ControlTile(
        label: _model.rtl ? 'زر المواد' : 'BUTTON',
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: m2Swatch[200],
                      onPressed: _model.enable ? () {} : null,
                      child: label,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      color: m2Swatch[500],
                      onPressed: _model.enable ? () {} : null,
                      child: label,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MaterialButton(
                      color: m2Swatch[200],
                      onPressed: _model.enable ? () {} : null,
                      child: label,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      color: m2Swatch[200],
                      onPressed: _model.enable ? () {} : null,
                      child: label,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      _ControlTile(
        label: _model.rtl ? 'رقائق' : 'CHIP',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(chipValues.length, (int index) {
            return InputChip(
              onPressed: _model.enable ? () {} : null,
              onDeleted: _model.enable ? () {} : null,
              label: Text(chipValues[index]),
            );
          }),
        ),
      ),
      _ControlTile(
        label: _model.rtl ? 'خانات الاختيار' : 'CHECKBOX',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(checkboxValues.length, (int index) {
            return Row(
              children: <Widget>[
                Checkbox(
                  onChanged: _model.enable
                      ? (bool value) {
                          setState(() {
                            checkboxValues[index] = value;
                          });
                        }
                      : null,
                  value: checkboxValues[index],
                ),
                Text('ITEM ${index + 1}'),
              ],
            );
          }),
        ),
      ),
      _ControlTile(
        label: _model.rtl ? 'زر الراديو' : 'RADIO BUTTON',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(4, (int index) {
            return Radio<int>(
              onChanged: _model.enable
                  ? (int value) {
                      setState(() {
                        radioValue = value;
                      });
                    }
                  : null,
              groupValue: radioValue,
              value: index,
            );
          }),
        ),
      ),
      _ControlTile(
        label: _model.rtl ? 'زر الأيقونة' : 'ICON BUTTON',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(iconValues.length, (int index) {
            return IconButton(
              onPressed: _model.enable ? () {} : null,
              icon: Icon(iconValues[index]),
            );
          }),
        ),
      ),
    ];

    return SafeArea(
      child: Theme(
        data: theme,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('Visual Density'),
            backgroundColor: const Color(0xff323232),
          ),
          body: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
            child: AnimatedTheme(
              data: Theme.of(context).copyWith(visualDensity: _model.density),
              child: Directionality(
                textDirection: _model.rtl ? TextDirection.rtl : TextDirection.ltr,
                child: Scrollbar(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: _model.size),
                    child: SizedBox.expand(
                      child: ListView(
                        children: tiles,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
