import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/util/util.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

LocationData _myLocation;


class ResultsInMaps extends StatefulWidget {

  final product;
  ResultsInMaps({@required this.product});

  @override
  _ResultsInMapsState createState() => _ResultsInMapsState();
}

class _ResultsInMapsState extends State<ResultsInMaps>  {

  GoogleMapController _mapController;
  List<Marker> allMarkers = [];
  BehaviorSubject<double> radius = BehaviorSubject.seeded(20);
  StreamSubscription _subscription ;
  MapType mapType = MapType.normal ;
  List<Posts> productsFromDB = [];
  List<String> postsUID = [] ;
  ScrollController controller ;


  @override
  void initState() {
    controller = ScrollController() ;
    super.initState();
    _myCurrentLocation();
  }

  @override
  void dispose() {
    supCancel();
    super.dispose();
  }

  supCancel() async {
    await _subscription.cancel();
  }

  _myCurrentLocation() async {
    if(_myLocation == null ){
      final myLocation = await Location().getLocation();
      setState(() {
        _myLocation = myLocation ;
      });
    }
  }

  animateToMyLocation() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_myLocation.latitude, _myLocation.longitude),
          zoom: 14,
          tilt: 90.0
        ),
      ),
    );
  }

  onMapCreated(controller) {
    setState(() {
      _mapController = controller;
      _startQuery();
    });
  }

  _startQuery() async {
    var myPos = await Location.instance.getLocation();
    double lat = myPos.latitude, lon = myPos.longitude;
    var postsRef = FirebaseFirestore.instance.collection('ProductPosts')
        .where('nameEN', isEqualTo: widget.product);
    GeoFirePoint center = GeoFirePoint(lat, lon);
    _subscription = radius.switchMap((rad) {
      return GeoFireCollectionRef(postsRef)
          .within(center: center, radius: rad, field: 'postLocation', strictMode: true);
    }).listen(updateMarkers);
  }

  updateMarkers(List<DocumentSnapshot> docList) async {

    docList.forEach((DocumentSnapshot doc) {
      GeoPoint gPoint ;
      Map map = doc.get('postLocation');
      gPoint = map.values.first ;

      Marker marker = Marker(
        position: LatLng(gPoint.latitude, gPoint.longitude),
        markerId: MarkerId(doc.get('postUID')),
        icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
        infoWindow: InfoWindow(title: '${doc.get('price')}  ${doc.get('currency')}' ),
        onTap: () {
          showBuySheet(
            context,
            Posts(
              nameAR: doc.get('nameAR'),
              nameEN: doc.get('nameEN'),
              type: doc.get('type'),
              postUID: doc.get('postUID'),
              currency: doc.get('currency'),
              vendorUID: doc.get('VendorUID'),
              price: doc.get('price'),
              url: doc.get('url'),
              likes: doc.get('likes') ?? [],
              latLng: LatLng(gPoint.latitude, gPoint.longitude),
              postLocation: doc.get('postLocation'),
            ),
          );
        },
      );
      Posts post = Posts(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        type: doc.get('type'),
        postUID: doc.get('postUID'),
        currency: doc.get('currency'),
        vendorUID: doc.get('VendorUID'),
        price: doc.get('price'),
        url: doc.get('url'),
        likes: doc.get('likes') ?? [],
        latLng: LatLng(gPoint.latitude, gPoint.longitude),
        postLocation: doc.get('postLocation'),
      );
      setState(() {
        allMarkers.add(marker);
        if(!postsUID.contains(post.postUID)){
          postsUID.add(post.postUID);
          productsFromDB.add(post);
        }
      });
    });
    print(productsFromDB);
  }

  _updateQuery(value) {
    final zoomMap = {20: 12, 30: 11.2, 40: 10.4, 50: 9.6, 60: 8.8};
    final zoom = zoomMap[value].toDouble();
    _mapController.moveCamera(CameraUpdate.zoomTo(zoom));
    setState(() => radius.add(value));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffE4E6EB),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _myLocation != null ?
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_myLocation.latitude, _myLocation.longitude),
              zoom: 10,
              tilt: 10.0,
            ),
            markers: Set.from(allMarkers),
            mapType: mapType,
            onMapCreated: onMapCreated,
            tiltGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            buildingsEnabled: false,
            indoorViewEnabled: false,
            trafficEnabled: false,
          ) :
          Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Getting Location'),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 65,
            left: 5,
            height: size.height*.25,
            width: size.width,
            child: PostsView(
              products: productsFromDB,
              mapController: _mapController,
              controller: controller,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Slider(
              activeColor: Colors.green[800],
              inactiveColor: Colors.greenAccent[400],
              max: 60,
              min: 20,
              divisions: 4,
              label: "${radius.value} km",
              value: radius.value,
              onChanged: _updateQuery,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 65,
            width: 50,
            height: 50,
            child: RawMaterialButton(
              fillColor: Colors.green[800],
              shape: StadiumBorder(),
              child: Icon(Icons.map,color: Colors.white,),
              onPressed: () {
                setState(() {
                  if(mapType == MapType.normal) mapType = MapType.satellite ;
                  else if(mapType == MapType.satellite) mapType = MapType.hybrid ;
                  else if(mapType == MapType.hybrid) mapType = MapType.terrain ;
                  else mapType = MapType.normal;
                });
              },
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            width: 50,
            height: 50,
            child: RawMaterialButton(
              fillColor: Colors.green[800],
              shape: StadiumBorder(),
              child: Icon(Icons.location_on,color: Colors.white,),
              onPressed: () {
                animateToMyLocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}

