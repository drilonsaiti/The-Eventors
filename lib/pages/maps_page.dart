import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:the_eventors_app/models/event.dart';

class MapScreen extends StatefulWidget {
  final Event event;
  const MapScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.997345, 21.427996),
    zoom: 7.5,
  );

  late GoogleMapController? _googleMapController;
  late Marker? _origin;

  @override
  void initState() {
    super.initState();
    this._googleMapController = null;
    this._origin = null;
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  convertDateTime(DateTime time) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');

    return f.format(time).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Find event'),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
            },
            onCameraMove: (came) => _addMarker(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker() async {
    var data =
        await Geocoder.local.findAddressesFromQuery(widget.event.location);
    double latitude = data.first.coordinates.latitude;
    double longitude = data.first.coordinates.longitude;

    LatLng pos = LatLng(latitude, longitude);
    if (_origin == null) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: InfoWindow(
              title: "Event: " + widget.event.title,
              snippet: "Start at: " + convertDateTime(widget.event.startTime)),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
      });
    }
  }
}
