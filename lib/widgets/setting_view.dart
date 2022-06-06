import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  Setting setting;
  SettingView({Key? key, required this.setting}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late Setting _setting;

  @override
  void initState() {
    super.initState();
    setState(() {
      _setting = widget.setting;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_setting.setting.runtimeType) {
      case String:
        return Container(
          child: Center(child: Text('WHAHA sm went wrong =D')),
        );
      case bool:
        return InkWell(
          onTap: () {
            setState(() {
              _setting.setting = !_setting.setting;
            });
          },
          child: Container(
            height: 45,
            color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container()),
                Text(_setting.name),
                SizedBox(
                  width: 20,
                ),
                Text(_setting.setting == true ? "Yes" : "No"),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        );
      default:
    }
    return Container(
      child: Center(child: Text('WHAHA sm went wrong =D')),
    );
  }
}
