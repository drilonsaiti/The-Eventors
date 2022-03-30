import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:the_eventors_app/db/events_database.dart';
import 'package:the_eventors_app/models/event.dart';

class MapAllEventPage extends StatefulWidget {
  const MapAllEventPage({
    Key? key,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapAllEventPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.997345, 21.427996),
    zoom: 6.5,
  );

  late GoogleMapController? _googleMapController;
  late Marker? _origin;
  late List<Event> events;
  bool isLoading = false;
  late Map<MarkerId, Marker> markers;

  @override
  void initState() {
    super.initState();
    this._googleMapController = null;
    this._origin = null;
    this.events = [];
    refreshEvents();
    markers = <MarkerId, Marker>{};
    createMarkers();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Future refreshEvents() async {
    setState(() => isLoading = true);

    this.events = await EventDatabase.instance.readAllEvents();

    setState(() => isLoading = false);
  }

  createMarkers() async {
    for (int i = 0; i < this.events.length; i++) {
      var data =
          await Geocoder.local.findAddressesFromQuery(events[i].location);
      double latitude = data.first.coordinates.latitude;
      double longitude = data.first.coordinates.longitude;

      LatLng pos = LatLng(latitude, longitude);
      MarkerId markerId = MarkerId(i.toString());
      Marker marker = Marker(
        markerId: markerId,
        position: pos,
        infoWindow: InfoWindow(
            title: "Event: " + events[i].title,
            snippet: "Start at: " + convertDateTime(events[i].startTime)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      setState(() {
        markers[markerId] = marker;
      });
    }
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
          if (markers != null)
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
            markers: Set<Marker>.of(markers.values),
            onCameraMove: (came) => createMarkers(),
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
}
