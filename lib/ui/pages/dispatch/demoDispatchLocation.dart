import 'dart:async';
import 'package:dispatch_app_client/src/lib_export.dart';
import 'package:dispatch_app_client/ui/widgets/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DemoDispatchLocation extends StatefulWidget {
  final Dispatch dispatch;
  const DemoDispatchLocation({Key key, this.dispatch}) : super(key: key);
  @override
  _DemoDispatchLocationState createState() => _DemoDispatchLocationState();
}

class _DemoDispatchLocationState extends State<DemoDispatchLocation> {
  double _currentRiderLatitude;
  double _currentRiderLongitude;
  Set<Polyline> polylines;
  List<LatLng> polylineCoordinates;
  //LatLngBounds bound;
  LatLng myLocation;
  Completer<GoogleMapController> _controller = Completer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BitmapDescriptor _start;
  BitmapDescriptor _end;
  Set<Marker> _markers = {};
  String _mapStyle;
  Rider rider;
  Timer _demoTimer;
  bool _hasTripEnded = false;
  bool _isLoading;

  @override
  void dispose() {
    _demoTimer.cancel();
    super.dispose();
  }

  _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _processDemoParameters() async {
    //get rider & current rider location
    _setLoadingState(true);
    try {
      final riderResponse =
          await Provider.of<AUthProvider>(context, listen: false)
              .getRider(widget.dispatch.dispatchRiderId);
      rider = riderResponse.item2;
      await locator<GoogleMapServices>().getDemoDetails(
          rider.latitude,
          rider.longitude,
          widget.dispatch.destinationLatitude,
          widget.dispatch.destinationLongitude);

      polylines = locator<GoogleMapServices>().polylines;
      //  bound = locator<GoogleMapServices>().bounds;
      polylineCoordinates = locator<GoogleMapServices>().polylineCoordinates;
    } catch (e) {
      GlobalWidgets.showFialureDialogue(e.toString(), context);
    }
    _setLoadingState(false);
  }

  int index = 0;
  void updatePolyLinePoints() async {
    _demoTimer = Timer.periodic(Duration(milliseconds: 300), (t) {
      updateTaxiOnMap(polylineCoordinates[index]);
    });
  }

  void updateTaxiOnMap(LatLng taxiPosition) async {
    CameraPosition cPosition = CameraPosition(
      zoom: 13,
      tilt: 40,
      bearing: 30,
      target: LatLng(taxiPosition.latitude, taxiPosition.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var newTaxiPosition =
          LatLng(taxiPosition.latitude, taxiPosition.longitude);
      _markers.removeWhere((m) => m.markerId.value == 'pickup');
      _markers.add(Marker(
          markerId: MarkerId('pickup'),
          position: newTaxiPosition, // updated position
          icon: _end));
      if (index == polylineCoordinates.length - 1) {
        _hasTripEnded = true;
        _demoTimer.cancel();
        //journey has ended

      } else {
        index++;
      }
    });
  }

  @override
  void initState() {
    myLocation = LatLng(widget.dispatch.destinationLatitude,
        widget.dispatch.destinationLongitude);
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/start.png')
        .then((onValue) {
      _start = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/end.png')
        .then((onValue) {
      _end = onValue;
    });

    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _processDemoParameters();
    super.initState();
  }

  // void _getLatLngBounds(LatLng from, LatLng to) {
  //   if (from.latitude > to.latitude && from.longitude > to.longitude) {
  //     bound = LatLngBounds(southwest: to, northeast: from);
  //   } else if (from.longitude > to.longitude) {
  //     bound = LatLngBounds(
  //         southwest: LatLng(from.latitude, to.longitude),
  //         northeast: LatLng(to.latitude, from.longitude));
  //   } else if (from.latitude > to.latitude) {
  //     bound = LatLngBounds(
  //         southwest: LatLng(to.latitude, from.longitude),
  //         northeast: LatLng(from.latitude, to.longitude));
  //   } else {
  //     bound = LatLngBounds(southwest: from, northeast: to);
  //   }
  // }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  void _moveCamera() async {
    // setState(() {
    //   _markers.remove(_markers.elementAt(0));
    // });
    locator<GoogleMapServices>().getLatLngBounds(
        LatLng(_currentRiderLatitude, _currentRiderLongitude),
        LatLng(widget.dispatch.destinationLatitude,
            widget.dispatch.destinationLongitude));
    // _getLatLngBounds(
    //     LatLng(_currentRiderLatitude, _currentRiderLongitude),
    //     LatLng(widget.dispatch.destinationLatitude,
    //         widget.dispatch.destinationLongitude));
    GoogleMapController controller = await _controller.future;
    CameraUpdate u2 =
        CameraUpdate.newLatLngBounds(locator<GoogleMapServices>().bounds, 50);
    controller.animateCamera(u2).then((void v) {
      check(u2, controller);
    });
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("xxx"),
          position: LatLng(_currentRiderLatitude, _currentRiderLongitude),
          icon: _start,
          infoWindow: InfoWindow(
            title: "Rider",
            snippet: "",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSize = GlobalWidgets.getAppSize(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "CURRENT LOCATION",
            style: AppTextStyles.appLightHeaderTextStyle,
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: _isLoading
            ? GlobalWidgets.circularInidcator()
            : Container(
                width: appSize.width,
                height: appSize.height,
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  markers: _markers,
                  //  polylines: _polylines,
                  initialCameraPosition:
                      CameraPosition(target: myLocation, zoom: 12),
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(_mapStyle);
                    _controller.complete(controller);
                    setState(() {
                      _markers.add(Marker(
                          markerId: MarkerId("destination"),
                          position: LatLng(widget.dispatch.destinationLatitude,
                              widget.dispatch.destinationLongitude),
                          icon: _start,
                          infoWindow: InfoWindow(
                            title: "Destination",
                          ),
                          onTap: () {}));

                      _markers.add(Marker(
                          markerId: MarkerId("rider"),
                          position: LatLng(rider.latitude, rider.longitude),
                          icon: _end,
                          infoWindow: InfoWindow(
                            title: "Rider",
                          ),
                          onTap: () {}));
                    });

                    Future.delayed(const Duration(milliseconds: 100), () {
                      CameraUpdate u2 = CameraUpdate.newLatLngBounds(
                          locator<GoogleMapServices>().bounds, 50);
                      controller.animateCamera(u2).then((void v) {
                        //  check(u2, controller);
                      });
                    });
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(FontAwesomeIcons.biking),
        ),
      ),
    );
  }
}
