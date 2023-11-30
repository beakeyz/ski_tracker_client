import 'package:skitracker_client/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum InfoBoxInfoType {
  HEIGHT,
  SPEED,
  LAT,
  LON,
  HEADING,
  DISTANCE_TRACKED

}


String getPositionAttribute(InfoBoxInfoType type, Position p) 
{  
  switch (type) {
    case InfoBoxInfoType.HEIGHT:
      return "${p.altitude.round().toString()} m";
    case InfoBoxInfoType.SPEED:
      return "${(p.speed.abs().round())} km/h";
    case InfoBoxInfoType.LAT:
      return p.latitude.toString();
    case InfoBoxInfoType.LON:
      return p.longitude.toString();
    case InfoBoxInfoType.HEADING:
      return p.heading.toString();
    case InfoBoxInfoType.DISTANCE_TRACKED:
      //TODO: compute distance
  }

  return "N/A";
}

class PositionInfoBox extends StatefulWidget {
  final String title;
  final InfoBoxInfoType type;
  final double updateRate;
  final Future<Object?>? updateFunction;
  final Position? data;

  const PositionInfoBox({super.key, required this.title, required this.type, this.updateFunction, this.data, this.updateRate = 60});

  @override
  State<PositionInfoBox> createState() => _PositionInfoBoxState();
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
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 55,
          decoration: const BoxDecoration(
            color: SECONDARY_COLOR,
            borderRadius: BorderRadius.all(
              Radius.circular(16)
            )
          ),
          alignment: Alignment.center,
          child: (widget.updateFunction != null) ? FutureBuilder(
            future: widget.updateFunction,
            builder: ((context, snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.none:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.waiting:
                  return const Text("Loading..."); 
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.done:
                  Position? pos = snapshot.data as Position?;
    
                  if (pos != null) {
                    String data = getPositionAttribute(widget.type, pos);
    
                    return Container(
                      child: Text("${widget.title}: $data"),
                    );
                  }
    
              }
              return const Text("..."); 
            })
          ) : LayoutBuilder(builder: (context, contraints) {
            if (widget.data != null) {
              String attribute = getPositionAttribute(widget.type, widget.data!);

              return Text("${widget.title}: $attribute");
            }
            return const Text("No data!");
            
          },),
        ),
      ),
    );
  }
}