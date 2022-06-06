import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/widgets/checkbox.dart';
import 'package:dadjoke_client/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  Setting settingField;
  SettingView({Key? key, required this.settingField}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> with SingleTickerProviderStateMixin {
  TextEditingController settingController = TextEditingController();
  late AnimationController animationController;
  double animPercentile = 1;

  void setAnimPercentile(double val) {
    setState(() {
      animPercentile = val;
    });
  }

  @override
  void initState() {
    super.initState();
    print("create");
    animationController = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);

    switch (widget.settingField.setting.runtimeType) {
      case String:
        setState(() {
          settingController.text = widget.settingField.setting;
        });
        widget.settingField.setController(settingController);

        break;
      case bool:
        if (widget.settingField.setting) {
          print("Turned it on");
          animationController.forward();
        } else {
          print("Turned it off");
          animationController.reverse();
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.settingField.setting.runtimeType) {
      case String:
        return Container(
          height: 55,
          child: TextInputField(editingController: settingController, hintText: "this should BE something", textInputType: TextInputType.text),
        );
      case bool:
        // TODO create custom widget
        return InkWell(
          onTap: () {
            setState(() {
              widget.settingField.setting = !widget.settingField.setting;
              if (widget.settingField.setting) {
                print("Turned it on");
                animationController.forward();
              } else {
                print("Turned it off");
                animationController.reverse();
              }
            });
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PRIMARY_COLOR, width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(widget.settingField.name, softWrap: true, style: TextStyle(fontFamily: "Open Sans", fontSize: 16)),
                Flexible(flex: 1, child: Container()),
                AnimatedBuilder(
                  animation: animationController.view,
                  builder: ((context, child) {
                    return Transform.scale(
                      scale: animationController.value,
                      child: child,
                    );
                  }),
                  child: CustomCheckBox(checked: widget.settingField.setting),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      default:
    }
    var thing = widget.settingField.setting.runtimeType;

    return Container(
      child: Center(child: Text('WHAHA sm went wrong =D $thing')),
    );
  }
}
