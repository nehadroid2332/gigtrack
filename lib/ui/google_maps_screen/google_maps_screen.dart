import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/google_maps_screen/google_maps_presenter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends BaseScreen {
  final double latitude, longitude;
  GoogleMapsScreen(AppListener appListener, {this.latitude, this.longitude})
      : super(appListener, title: "Maps");

  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState
    extends BaseScreenState<GoogleMapsScreen, GoogleMapsPresenter> {
  GoogleMapController _controller;

  CameraPosition _kGooglePlex;

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 12,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 450));
      final MarkerId markerId = MarkerId("markerIdVal");
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          widget.latitude,
          widget.longitude,
        ),
      );
      setState(() {
        markers[markerId] = marker;
      });
      _controller?.animateCamera(
          CameraUpdate.newLatLng(LatLng(widget.latitude, widget.longitude)));
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget buildBody() {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      markers: Set<Marker>.of(markers.values),
    );
  }

  @override
  GoogleMapsPresenter get presenter => GoogleMapsPresenter(this);
}
