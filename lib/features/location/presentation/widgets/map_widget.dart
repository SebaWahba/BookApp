import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final ValueChanged<GoogleMapController>? onMapCreated;
  final ValueChanged<LatLng>? onCameraIdleTarget;
  final ValueChanged<bool>? onMovingStateChanged;
  final bool isPermissionGranted;

  const MapWidget({
    super.key,
    required this.initialPosition,
    this.onMapCreated,
    this.onCameraIdleTarget,
    this.onMovingStateChanged,
    this.isPermissionGranted = false,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _latestTarget;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _latestTarget = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 15.0,
      ),
      onMapCreated: widget.onMapCreated,
      onCameraMove: (position) {
        _latestTarget = position.target;
        if (!_isMoving) {
          _isMoving = true;
          widget.onMovingStateChanged?.call(true);
        }
      },
      onCameraIdle: () {
        if (_isMoving) {
          _isMoving = false;
          widget.onMovingStateChanged?.call(false);
        }
        widget.onCameraIdleTarget?.call(_latestTarget);
      },
      myLocationEnabled: widget.isPermissionGranted,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
    );
  }
}
