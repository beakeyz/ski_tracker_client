import 'package:skitracker_client/core/updates/StateUpdater.dart';
import 'package:flutter/material.dart';

class StateUpdateWidget extends StatelessWidget {
  StateUpdater updater;
  final Widget child;

  StateUpdateWidget({super.key, required this.updater, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}