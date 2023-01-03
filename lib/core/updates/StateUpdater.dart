
import 'package:flutter/material.dart';

List<StateUpdater> g_stateUpdaters = [];

class StateUpdater {
  Key? stateKey;
  List<Function> callbacks = [];

  StateUpdater({required this.stateKey});

  void addCallback(Function f) {
    callbacks.add(f);
  }

  void fireCallbacks() {
    if (callbacks.isEmpty) return;
    for (Function f in callbacks) {
      f();
    }
  }

}

void addWidgetlessStateUpdator(Function updator) {
  StateUpdater stateUpdater = StateUpdater(stateKey: null);
  stateUpdater.addCallback(updator);
  g_stateUpdaters.add(stateUpdater);
}

void activateStateUpdateWidgets (Key? key) {
  for (var stateUpdater in g_stateUpdaters) {
    if (key == stateUpdater.stateKey) {
      stateUpdater.fireCallbacks();
    }
  }
}