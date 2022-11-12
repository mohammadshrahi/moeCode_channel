import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  const MapScreen() : super(key: null);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey _markerKey = GlobalKey();
  bool showChild = false;
  Uint8List? markerImage;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final RenderBox renderBox =
          _markerKey.currentContext?.findRenderObject() as RenderBox;
      if (renderBox.hasSize) {
        _getMarkerImage(context);
      }
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      _getMarkerImage(context);
    });
    // Timer.periodic(const Duration(microseconds: 6), (timer) async {
    //   if (markerImage != null) timer.cancel();
    //   await _getMarkerImage(context);
    // });
    super.initState();
  }

  ///
  Future<void> _getMarkerImage(BuildContext context) async {
    try {
      if (_markerKey.currentContext == null) return;
      final boundary = _markerKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary?.debugNeedsPaint ?? true) {
        return;
      }
      final image = await boundary?.toImage();
      if (image == null) return;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final ui.Codec codec = await ui.instantiateImageCodec(
          byteData!.buffer.asUint8List(),
          targetWidth: 300,
          targetHeight: 150);
      final ui.FrameInfo fi = await codec.getNextFrame();
      markerImage = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
      if (markerImage != null) {
        setState(() {
          showChild = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return showChild
        ? MapWidget(
            markerImage: markerImage!,
          )
        : Scaffold(
            body: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                Transform.translate(
                    offset: const Offset(0, -200),
                    child: MarkerWidget(markerKey: _markerKey)),
              ],
            ),
          );
  }
}

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    Key? key,
    required GlobalKey<State<StatefulWidget>> markerKey,
  })  : _markerKey = markerKey,
        super(key: key);

  final GlobalKey<State<StatefulWidget>> _markerKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: _markerKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    blurRadius: 0.2, spreadRadius: 0.2, color: Colors.grey),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(5),
            child: const Text(
              'MoeCode',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, required this.markerImage});
  final Uint8List markerImage;

  @override
  State<MapWidget> createState() => MapSampleState();
}

class MapSampleState extends State<MapWidget> {
  final _controller = Completer();
  late Marker demo;
  @override
  void initState() {
    demo = Marker(
        position: const LatLng(37.43296265331129, -122.08832357078792),
        markerId: const MarkerId('marker_id'),
        icon: BitmapDescriptor.fromBytes(widget.markerImage,
            size: const Size(2000, 30)));
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 19.151926040649414,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        markers: {demo},
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
