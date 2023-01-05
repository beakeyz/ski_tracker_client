import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class InfoBox extends StatefulWidget {
  final String title;
  final double updateRate;
  final Future<Object?> updateFunction;

  InfoBox({super.key, required this.title, required this.updateFunction, this.updateRate = 1});

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

    return FutureBuilder(
      future: widget.updateFunction,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            Position? pos = snapshot.data as Position?;

            if (pos != null) {
              return Container(
                child: Text("Yay data =D ${pos.latitude}"),
              );
            }

        }
        return Container(
          child: Text("No data =("),
        ); 
      })
    );
  }
}