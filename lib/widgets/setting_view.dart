import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  Setting setting;
  SettingView({Key? key, required this.setting}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.setting.setting.runtimeType) {
      case String:
        return Container(
          child: Center(child: Text('WH sm went wrong =D')),
        );
      case bool:
        return InkWell(
          onTap: () {
            setState(() {
              widget.setting.setting = !widget.setting.setting;
            });
          },
          child: Container(
            height: 45,
            color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container()),
                Text(widget.setting.name),
                SizedBox(
                  width: 20,
                ),
                Text(widget.setting.setting == true ? "Yes" : "No"),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        );
      default:
    }
    var thing = widget.setting.setting.runtimeType;

    return Container(
      child: Center(child: Text('WHAHA sm went wrong =D $thing')),
    );
  }
}
