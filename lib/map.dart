import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

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
    MarkerId markerId10 = MarkerId("10");
    MarkerId markerId11 = MarkerId("11");
    MarkerId markerId12 = MarkerId("12");
    MarkerId markerId13 = MarkerId("13");
    MarkerId markerId14 = MarkerId("14");
    MarkerId markerId15 = MarkerId("15");
    MarkerId markerId16 = MarkerId("16");
    MarkerId markerId17 = MarkerId("17");
    MarkerId markerId18 = MarkerId("18");
    MarkerId markerId19 = MarkerId("19");
    MarkerId markerId20 = MarkerId("20");
    MarkerId markerId21 = MarkerId("21");
    MarkerId markerId22 = MarkerId("22");
    MarkerId markerId23 = MarkerId("23");
    MarkerId markerId24 = MarkerId("24");
    MarkerId markerId25 = MarkerId("25");


    listMarkerIds.add(markerId1);
    listMarkerIds.add(markerId2);
    listMarkerIds.add(markerId3);
    listMarkerIds.add(markerId4);
    listMarkerIds.add(markerId5);
    listMarkerIds.add(markerId6);
    listMarkerIds.add(markerId7);
    listMarkerIds.add(markerId8);
    listMarkerIds.add(markerId9);
    listMarkerIds.add(markerId10);
    listMarkerIds.add(markerId11);
    listMarkerIds.add(markerId12);
    listMarkerIds.add(markerId13);
    listMarkerIds.add(markerId14);
    listMarkerIds.add(markerId15);
    listMarkerIds.add(markerId16);
    listMarkerIds.add(markerId17);
    listMarkerIds.add(markerId18);
    listMarkerIds.add(markerId19);
    listMarkerIds.add(markerId20);
    listMarkerIds.add(markerId21);
    listMarkerIds.add(markerId22);
    listMarkerIds.add(markerId23);
    listMarkerIds.add(markerId24);
    listMarkerIds.add(markerId25);

    Marker marker1=Marker(markerId: markerId1,position: LatLng(1.4822551337526393, 103.86683347564386),infoWindow: InfoWindow(title:"Yellow Bin 1" ));
    Marker marker2=Marker(markerId: markerId2,position: LatLng(1.473921211342285, 103.94218016640444),infoWindow: InfoWindow(title:"Yellow Bin 2" ));
    Marker marker3=Marker(markerId: markerId3,position: LatLng(1.483916241192329, 103.95775109960367),infoWindow: InfoWindow(title:"Yellow Bin 3" ));
    Marker marker4=Marker(markerId: markerId4,position: LatLng(2.021218539292489, 103.30157069368934),infoWindow: InfoWindow(title:"Yellow Bin 4" ));
    Marker marker5=Marker(markerId: markerId5,position: LatLng(3.277219056042121, 101.68021190718966),infoWindow: InfoWindow(title:"Yellow Bin 5" ));
    Marker marker6=Marker(markerId: markerId6,position: LatLng(2.3954274909349187, 102.21131014397653),infoWindow: InfoWindow(title:"Ong Peck Seng (Melaka) Sdn Bhd" ));
    Marker marker7=Marker(markerId: markerId7,position: LatLng(2.3498463657333124, 102.23558573416268),infoWindow: InfoWindow(title:"Okh Trading & Recycle Sdn. Bhd" ));
    Marker marker8=Marker(markerId: markerId8,position: LatLng(2.351505915901044, 102.22228107776245),infoWindow: InfoWindow(title:"Tzuchi Bukit Cheng Recycle Center" ));
    Marker marker9=Marker(markerId: markerId9,position: LatLng(2.361172486892282, 102.24976538883371),infoWindow: InfoWindow(title:"Meriahtek (M) Sdn. Bhd." ));
    Marker marker10=Marker(markerId: markerId10,position: LatLng(1.875259591609726, 102.99478529813825),infoWindow: InfoWindow(title:"Yellow Bin in Batu Pahat" ));
    Marker marker11=Marker(markerId: markerId11,position: LatLng(1.792245721020576, 102.96472711254606),infoWindow: InfoWindow(title:"SIAN KIAT SDN BHD" ));
    Marker marker12=Marker(markerId: markerId12,position: LatLng(1.870826458132218, 102.9303948353746),infoWindow: InfoWindow(title:"Kae Recycle Sdn. Bhd." ));
    Marker marker13=Marker(markerId: markerId13,position: LatLng(2.2573481681420806, 102.25563087195486),infoWindow: InfoWindow(title:"UER Resources Melaka branch" ));
    Marker marker14=Marker(markerId: markerId14,position: LatLng(1.5327275261441495, 103.6952508690293),infoWindow: InfoWindow(title:"Dynasty Recycling Disposal Services" ));
    Marker marker15=Marker(markerId: markerId15,position: LatLng(1.5457690828824873, 103.76116884119851),infoWindow: InfoWindow(title:"Edli Recycle Sdn. Bhd." ));
    Marker marker16=Marker(markerId: markerId16,position: LatLng(1.549544255438841, 103.695594191801),infoWindow: InfoWindow(title:"Yong You Recycle Enterprise" ));
    Marker marker17=Marker(markerId: markerId17,position: LatLng(1.536502721819421, 103.78279817581652),infoWindow: InfoWindow(title:"Yellow Bin - JJB1006" ));
    Marker marker18=Marker(markerId: markerId18,position: LatLng(1.5296387247312022, 103.74056947489562),infoWindow: InfoWindow(title:"Kent Soon Recycle Centre Sdn Bhd" ));
    Marker marker19=Marker(markerId: markerId19,position: LatLng(1.5440530931369223, 103.77352846098024),infoWindow: InfoWindow(title:"Yeh Soon Recycling Sdn. Bhd." ));
    Marker marker20=Marker(markerId: markerId20,position: LatLng(1.9964346515827562, 103.05353908824407),infoWindow: InfoWindow(title:"Hup Soon recycle" ));
    Marker marker21=Marker(markerId: markerId21,position: LatLng(2.2758730917965737, 102.27417030014944),infoWindow: InfoWindow(title:"Tan Wee Choon Sdn Bhd" ));
    Marker marker22=Marker(markerId: markerId22,position: LatLng(2.2796466581537937, 102.18250312010161),infoWindow: InfoWindow(title:"SYP Recovery & Recycling Sdn. Bhd." ));
    Marker marker23=Marker(markerId: markerId23,position: LatLng(2.08346352324295, 102.56741481507545),infoWindow: InfoWindow(title:"Greentech recycle resource" ));
    Marker marker24=Marker(markerId: markerId24,position: LatLng(2.0471931044961007, 102.6617144019175),infoWindow: InfoWindow(title:"E DING CKF ENTERPRISE RECYCLE" ));
    Marker marker25=Marker(markerId: markerId25,position: LatLng(2.159350414087793, 102.42019300319646),infoWindow: InfoWindow(title:"Penta Recycling" ));

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
      markers[markerId10]=marker10;
      markers[markerId11]=marker11;
      markers[markerId12]=marker12;
      markers[markerId13]=marker13;
      markers[markerId14]=marker14;
      markers[markerId15]=marker15;
      markers[markerId16]=marker16;
      markers[markerId17]=marker17;
      markers[markerId18]=marker18;
      markers[markerId19]=marker19;
      markers[markerId20]=marker20;
      markers[markerId21]=marker21;
      markers[markerId22]=marker22;
      markers[markerId23]=marker23;
      markers[markerId24]=marker24;
      markers[markerId25]=marker25;
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

