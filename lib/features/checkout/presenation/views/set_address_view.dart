import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class SetAddressView extends StatefulWidget {
  const SetAddressView({super.key});

  @override
  State<SetAddressView> createState() => _SetAddressViewState();
}

class _SetAddressViewState extends State<SetAddressView> {
  String selectedAddressType = 'Home';
  final MapController _mapController = MapController();

  LatLng _currentPosition = const LatLng(30.0444, 31.2357);
  String _addressTitle = 'Selected Location';
  String _addressSubtitle = 'Move map to get address...';
  bool _isLoadingAddress = false;

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isLoadingAddress = true;
      _addressSubtitle = 'Fetching address...';
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'bookapp_flutter_client'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>? ?? {};

        final road = address['road'] ?? address['pedestrian'] ?? address['suburb'] ?? 'Unnamed Road';
        final city = address['city'] ?? address['town'] ?? address['village'] ?? address['state'] ?? '';
        final country = address['country'] ?? '';
        final displayName = data['display_name'] ?? 'Selected Location';

        setState(() {
          _addressTitle = road.toString();
          _addressSubtitle = '$city, $country'.replaceAll(RegExp(r'^,\s*'), '');
          if (_addressSubtitle.isEmpty) {
            _addressSubtitle = displayName;
          }
          _isLoadingAddress = false;
        });
      } else {
        setState(() {
          _addressTitle = 'Selected Location Pin';
          _addressSubtitle = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        _addressTitle = 'Selected Location Pin';
        _addressSubtitle = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
        _isLoadingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Location', style: AppTextStyles.h4.copyWith(color: AppColors.grey900)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        actions: [
          // أيقونة الجرس المطابقة للشاشة الرئيسية في أعلى اليمين
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notifications),
                    child: SvgPicture.asset(
                      AppAssets.bellIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: SvgPicture.asset(
                      AppAssets.ellipseIcon,
                      width: 8,
                      height: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition,
                    initialZoom: 15.0,
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        final center = _mapController.camera.center;
                        _currentPosition = center;
                        _getAddressFromLatLng(center);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.bookapp.app',
                    ),
                  ],
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(
                      Icons.location_pin,
                      size: 48,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Detail Address', style: AppTextStyles.h5.copyWith(color: AppColors.grey900)),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: AppColors.primary500),
                          onPressed: () {
                            _getAddressFromLatLng(_mapController.camera.center);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey200!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary500.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: _isLoadingAddress
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary500),
                                  )
                                : const Icon(Icons.location_on, color: AppColors.primary500, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _addressTitle,
                                  style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _addressSubtitle,
                                  style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Save Address As', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTypeChip('Home'),
                        const SizedBox(width: 12),
                        _buildTypeChip('Offices'),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () => context.pop({
                          'title': _addressTitle,
                          'subtitle': _addressSubtitle,
                        }),
                        child: Text(
                          'Confirmation',
                          style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String title) {
    final isSelected = selectedAddressType == title;
    return InkWell(
      onTap: () => setState(() => selectedAddressType = title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500.withOpacity(0.15) : AppColors.grey100,
          border: Border.all(color: isSelected ? AppColors.primary500 : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMediumBold.copyWith(
            color: isSelected ? AppColors.primary500 : AppColors.grey900,
          ),
        ),
      ),
    );
  }
}