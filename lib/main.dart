// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  static const String _title = 'Density';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: HomePage(title: _title),
    );
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
          color: Colors.black45,
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

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: densitySelected.length, vsync: this);
  }

  List<VisualDensity> densitySelected = <VisualDensity>[
    VisualDensity.standard,
    VisualDensity.comfortable,
    VisualDensity.compact,
  ];
  VisualDensity _density = const VisualDensity();

  TabController _tabController;

  // Control values
  List<bool> _checkboxValues = <bool>[true, false, false, false];
  List<IconData> _iconButtonValues = <IconData>[Icons.arrow_back, Icons.play_arrow, Icons.arrow_forward];
  List<String> _chipValues = <String>['Potato', 'Computer'];
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    const Widget label = Text('Press Me');

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Visual Density'),
          backgroundColor: const Color(0xff323232),
        ),
        body: AnimatedTheme(
          // This is what sets the visual density for the controls in the body
          // of the Scaffold.
          data: Theme.of(context).copyWith(visualDensity: _density),
          child: Scrollbar(
            child: SizedBox.expand(
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400,
                        child: TabBar(
                          onTap: (int index) {
                            setState(() {
                              _density = densitySelected[index];
                            });
                          },
                          controller: _tabController,
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
                    label: 'BUTTON',
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
                                  onPressed: () {},
                                  child: label,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlineButton(
                                  onPressed: () {},
                                  child: label,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: label,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FlatButton(
                                  onPressed: () {},
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
                    label: 'CHIP',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_chipValues.length, (int index) {
                        return InputChip(
                          onPressed: () {},
                          onDeleted: () {},
                          label: Text(_chipValues[index]),
                        );
                      }),
                    ),
                  ),
                  _ControlTile(
                    label: 'CHECKBOX',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_checkboxValues.length, (int index) {
                        return Row(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (bool value) {
                                setState(() {
                                  _checkboxValues[index] = value;
                                });
                              },
                              value: _checkboxValues[index],
                            ),
                            Text('ITEM ${index + 1}'),
                          ],
                        );
                      }),
                    ),
                  ),
                  _ControlTile(
                    label: 'RADIO BUTTON',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(4, (int index) {
                        return Radio<int>(
                          onChanged: (int value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                          groupValue: _radioValue,
                          value: index,
                        );
                      }),
                    ),
                  ),
                  _ControlTile(
                    label: 'ICON BUTTON',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_iconButtonValues.length, (int index) {
                        return IconButton(
                          onPressed: () {},
                          icon: Icon(_iconButtonValues[index]),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
