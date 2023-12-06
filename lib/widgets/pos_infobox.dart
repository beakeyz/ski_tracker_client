import 'package:location/location.dart';
import 'package:skitracker_client/constants/colors.dart';
import 'package:flutter/material.dart';

enum InfoBoxInfoType {
  HEIGHT,
  SPEED,
  LAT,
  LON,
  HEADING,
  DISTANCE_TRACKED

}

class PositionInfoBox extends StatefulWidget {
  final String title;
  final InfoBoxInfoType type;
  final double updateRate;
  final Future<Object?>? updateFunction;
  final LocationData? data;
  final double? distance;

  const PositionInfoBox({super.key, required this.title, required this.type, this.updateFunction, this.data, this.distance, this.updateRate = 60});

  @override
  State<PositionInfoBox> createState() => _PositionInfoBoxState();

  String getPositionAttribute(InfoBoxInfoType type) 
  {

    if (data == null) {
      return "N/A";
    }

    switch (type) {
      case InfoBoxInfoType.HEIGHT:
        if (data!.altitude == null) {
          break;
        }
        return "${data!.altitude!.round().toString()} m";
      case InfoBoxInfoType.SPEED:
        if (data!.speed == null) {
          break;
        }
        return "${(data!.speed!.abs().round())} km/h";
      case InfoBoxInfoType.LAT:
        if (data == null) {
          break;
        }
        return data!.latitude.toString();
      case InfoBoxInfoType.LON:
        if (data!.longitude == null) {
          break;
        }
        return data!.longitude!.toString();
      case InfoBoxInfoType.HEADING:
        if (data!.heading == null) {
          break;
        }
        return data!.heading!.toString();
      case InfoBoxInfoType.DISTANCE_TRACKED:
        return "${distance!.round().toString()} m";
    }

    return "N/A";
  }
}

class _PositionInfoBoxState extends State<PositionInfoBox> {
  bool hasData = false;

  @override
  void initState() {

    super.initState();
  }

  void setHasData(bool hasData) {
    setState(() {
      this.hasData = hasData;      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 50,
          minWidth: MediaQuery.of(context).size.width / 2 - 100,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 55,
          decoration: const BoxDecoration(
            color: SECONDARY_COLOR,
            borderRadius: BorderRadius.all(
              Radius.circular(9)
            )
          ),
          alignment: Alignment.center,
          child: LayoutBuilder(builder: (context, contraints) {
            String attribute = widget.getPositionAttribute(widget.type);

            return Text("${widget.title}: $attribute");
          },),
        ),
      ),
    );
  }
}