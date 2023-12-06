
import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/widgets/checkbox.dart';
import 'package:skitracker_client/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {

  final dynamic settingField;
  const SettingView({Key? key, required this.settingField}) : super(key: key);

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
    animationController = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);

    if (widget.settingField is StringSetting) {
      StringSetting setting = widget.settingField;
      setState(() {
        settingController.text = setting.value;
      });
      setting.setController(settingController);
    } else if (widget.settingField is BoolSetting) {
      BoolSetting setting = widget.settingField;

      if (setting.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.settingField is StringSetting) {
      StringSetting setting = widget.settingField;
        return SizedBox(
          height: 75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(setting.name, style: const TextStyle(fontSize: 14)),
              SizedBox(
                height: 5,
                child: Container(),
              ),
              Expanded(
                child: TextInputField(editingController: settingController, hintText: "this should BE something", textInputType: TextInputType.text),
              ),
            ],
          ),
        );
    } else if (widget.settingField is BoolSetting) {
      BoolSetting setting = widget.settingField;

      // TODO create custom widget
      return InkWell(
        onTap: () {
          setState(() {
            setting.value = !setting.value;
            if (setting.value) {
              animationController.forward();
            } else {
              animationController.reverse();
            }
          });
        },
        child: SizedBox(
          height: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Container()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(setting.name, softWrap: true, style: const TextStyle(fontFamily: "Open Sans", fontSize: 16)),
                  Flexible(flex: 1, child: Container()),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey,
                          )
                        ),
                      ),
                      AnimatedBuilder(
                        animation: animationController.view,
                        builder: ((context, child) {
                          return Transform.scale(
                            scale: animationController.value,
                            child: child,
                          );
                        }),
                        child: CustomCheckBox(checked: setting.value),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Flexible(child: Container()),
              SizedBox(
                height: 1,
                width: MediaQuery.of(context).size.width - 80,
                child: Container(
                  color: const Color.fromARGB(176, 133, 132, 132),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.settingField is SliderSetting) {
      SliderSetting setting = widget.settingField;
      return Column(
        children: [
          Text(
            "${setting.name}: ${setting.value}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Slider(
            activeColor: FOREGROUND_COLOR,
            inactiveColor: SECONDARY_COLOR,
            value: (setting.value).toDouble(),
            onChanged: (newValue) async {
              if (setting.value is int) {
                setState(() {
                  setting.value = newValue.toInt();
                });
              } else {
                setState(() {
                  setting.value = (newValue);
                });
              }

              if (setting.onChanged != null) {
                await setting.onChanged!(setting);
              }
            },
            min: setting.minValue.toDouble(),
            max: setting.maxValue.toDouble(),
          ),
        ],
      );
      //return CustomSlider(minValue: setting.minValue, maxValue: setting.maxValue, defaultValue: setting.value, child: widget);
    }

    return Container(
      color: Colors.red,
      child: const Text("OOF lmao"),
    );
  }
}
