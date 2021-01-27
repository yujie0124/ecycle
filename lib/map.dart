import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Location _location=Location();
  Map<MarkerId,Marker> markers = {};
  //Set<Marker> _markers ={};
  List listMarkerIds=List();
  //final MarkerId markerId = MarkerId("current");

  void _onMapCreated(GoogleMapController controller){


    MarkerId markerId1 = MarkerId("1");
    MarkerId markerId2 = MarkerId("2");
    MarkerId markerId3 = MarkerId("3");
    MarkerId markerId4 = MarkerId("4");
    MarkerId markerId5 = MarkerId("5");
    MarkerId markerId6 = MarkerId("6");
    MarkerId markerId7 = MarkerId("7");
    MarkerId markerId8 = MarkerId("8");
    MarkerId markerId9 = MarkerId("9");


    listMarkerIds.add(markerId1);
    listMarkerIds.add(markerId2);
    listMarkerIds.add(markerId3);
    listMarkerIds.add(markerId4);
    listMarkerIds.add(markerId5);
    listMarkerIds.add(markerId6);
    listMarkerIds.add(markerId7);
    listMarkerIds.add(markerId8);
    listMarkerIds.add(markerId9);

    Marker marker1=Marker(markerId: markerId1,position: LatLng(1.4822551337526393, 103.86683347564386),infoWindow: InfoWindow(title:"Yellow Bin 1" ));
    Marker marker2=Marker(markerId: markerId2,position: LatLng(1.473921211342285, 103.94218016640444),infoWindow: InfoWindow(title:"Yellow Bin 2" ));
    Marker marker3=Marker(markerId: markerId3,position: LatLng(1.483916241192329, 103.95775109960367),infoWindow: InfoWindow(title:"Yellow Bin 3" ));
    Marker marker4=Marker(markerId: markerId4,position: LatLng(2.021218539292489, 103.30157069368934),infoWindow: InfoWindow(title:"Yellow Bin 4" ));
    Marker marker5=Marker(markerId: markerId5,position: LatLng(3.277219056042121, 101.68021190718966),infoWindow: InfoWindow(title:"Yellow Bin 5" ));
    Marker marker6=Marker(markerId: markerId6,position: LatLng(2.3954274909349187, 102.21131014397653),infoWindow: InfoWindow(title:"Ong Peck Seng (Melaka) Sdn Bhd" ));
    Marker marker7=Marker(markerId: markerId7,position: LatLng(2.3498463657333124, 102.23558573416268),infoWindow: InfoWindow(title:"Okh Trading & Recycle Sdn. Bhd" ));
    Marker marker8=Marker(markerId: markerId8,position: LatLng(2.351505915901044, 102.22228107776245),infoWindow: InfoWindow(title:"Tzuchi Bukit Cheng Recycle Center" ));
    Marker marker9=Marker(markerId: markerId9,position: LatLng(2.361172486892282, 102.24976538883371),infoWindow: InfoWindow(title:"Meriahtek (M) Sdn. Bhd." ));

    setState(() {
      markers[markerId1]=marker1;
      markers[markerId2]=marker2;
      markers[markerId3]=marker3;
      markers[markerId4]=marker4;
      markers[markerId5]=marker5;
      markers[markerId6]=marker6;
      markers[markerId7]=marker7;
      markers[markerId8]=marker8;
      markers[markerId9]=marker9;
    });
  }
  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(1.511465, 103.506234),
    bearing: 15.0,
    tilt: 75.0,
    zoom: 8.0,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set.of(markers.values),
        initialCameraPosition: _myLocation,
        onMapCreated: _onMapCreated,
        onCameraMove: null,
      ),
    );
  }
}

