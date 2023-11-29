import 'dart:io';

import 'package:skitracker_client/core/screen_switcher.dart';
import 'package:flutter/material.dart';

const int E_OK = 0;
const int E_FAIL = 1;
const int E_NOCONN = 2;
const int E_NOFILE = 3;
const int E_NULL = 4;
const int E_IOERR = 5;

class ErrorScreen extends StatefulWidget {
  final int error;

  const ErrorScreen(this.error, {super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Something went wrong: ${widget.error}"),
    );
  }
}

void ShowErrorScreen(BuildContext context, int error)
{
  ScreenSwitcher.gotoScreen(context, ErrorScreen(error), false);
  exit(error);
}