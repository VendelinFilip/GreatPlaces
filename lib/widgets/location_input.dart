import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectPlace(locationData.latitude, locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
