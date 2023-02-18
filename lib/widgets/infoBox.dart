import 'package:dadjoke_client/constants/colors.dart';
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


num getPositionAttribute(InfoBoxInfoType type, Position p) {
  
  switch (type) {
    case InfoBoxInfoType.HEIGHT:
      return p.altitude;
    case InfoBoxInfoType.SPEED:
      return p.speed;
    case InfoBoxInfoType.LAT:
      return p.latitude;
    case InfoBoxInfoType.LON:
      return p.longitude;
    case InfoBoxInfoType.HEADING:
      return p.heading;
    case InfoBoxInfoType.DISTANCE_TRACKED:
      //TODO: compute distance
  }

  return 0;
}

class InfoBox extends StatefulWidget {
  final String title;
  final InfoBoxInfoType type;
  final double updateRate;
  final Future<Object?> updateFunction;

  InfoBox({super.key, required this.title, required this.type, required this.updateFunction, this.updateRate = 60});

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  bool has_data = false;

  @override
  void initState() {

    super.initState();
  }

  void setHasData(bool has_data) {
    setState(() {
      this.has_data = has_data;      
    });
  }

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2 - 50,
        minWidth: MediaQuery.of(context).size.width / 2 - 100,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 55,
        decoration: const BoxDecoration(
          color: SECONDARY_COLOR,
        ),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: widget.updateFunction,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.none:
                // TODO: Handle this case.
                break;
              case ConnectionState.waiting:
                // TODO: Handle this case.
                return Container(
                  child: Text("Loading..."),
                ); 
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:
                Position? pos = snapshot.data as Position?;

                if (pos != null) {
                  num data = getPositionAttribute(widget.type, pos);

                  return Container(
                    child: Text("${widget.title}: $data"),
                  );
                }

            }
            return Container(
              child: Text("..."),
            ); 
          })
        ),
      ),
    );
  }
}