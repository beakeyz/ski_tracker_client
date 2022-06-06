class Setting {
  String name;
  dynamic setting;

  Setting({required this.name, required this.setting});

  // Does this work?
  void set(dynamic newVal) {
    setting = newVal;
  }
}

class SettingVars {
  static bool test1 = false;
  static String test2 = "";

  static var Settings = [
    Setting(name: "Test", setting: SettingVars.test1),
    Setting(name: "Test2", setting: SettingVars.test2),
  ];
}
