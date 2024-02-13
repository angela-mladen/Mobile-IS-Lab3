import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationChoose extends StatefulWidget {
  final Function(LatLong) updateAncestorState;

  const LocationChoose(this.updateAncestorState, {super.key});

  @override
  State<LocationChoose> createState() => _LocationChooseState();
}

class _LocationChooseState extends State<LocationChoose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLocationPicker(
      initZoom: 11,
      trackMyPosition: true,
      searchBarBackgroundColor: Colors.white,
      onPicked: (PickedData pickedData) {
        widget.updateAncestorState(pickedData.latLong);
        Navigator.pop(context);
      },
    ));
  }
}
