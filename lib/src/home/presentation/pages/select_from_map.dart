import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:oktoast/oktoast.dart';

class SelectFromMapPage extends StatefulWidget {
  final Map<String, dynamic>? params;
  const SelectFromMapPage({
    super.key,
    required this.params,
  });

  @override
  State<SelectFromMapPage> createState() => _SelectFromMapPageState();
}

class _SelectFromMapPageState extends State<SelectFromMapPage> {
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {}
    final geolocator = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return geolocator;
  }

  final homeBloc = locator<HomeBloc>();
  Position? loc;
  num? lat;
  num? lng;

  String location = "";
  bool isActive = false;

  void mapCreated(GoogleMapController controller) async {
    loc = await getLocation();

    // mapController = controller;
    // setState(() {});
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   mapController.dispose();
  // }

  //late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:  Container(
            height: Sizes().height(context, 0.23),
            padding: EdgeInsets.symmetric(
              horizontal: Sizes().width(context, 0.054),
              vertical: Sizes().height(context, 0.02),
            ),
            child: Column(
              children: [
                const Text("Location"),
                Space().height(context, 0.02),
                Text(location),
                Space().height(context, 0.04),
                BlocConsumer(
                  bloc:homeBloc,
                  listener: (context, state) {
                    if (state is GetPlaceByLatLngLoaded) {
            location = state.placeSearch.results?[0].formatedAddress ?? "";
            lat = state.placeSearch.results?[0].geometry?.location.lat ?? 5.0;
            lng = state.placeSearch.results?[0].geometry?.location.lng ?? 0.20;
            isActive = true;
            setState(() {});
          }
          if (state is GetPlaceByLatLngError) {
            OKToast(child: Text(state.errorMessage));
          }
                  },
                  builder: (context, state) {
                    if (state is GetPlaceByLatLngLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
                    return DefaultButton(
                      isActive: isActive,
                      label: "Save",
                      onTap: !isActive
                          ? null
                          : () {
                              Map<String, dynamic> params = {
                                "lat": lat,
                                "lng": lng,
                                "formatted_address": location,
                              };
                              //mapController.dispose();
                              //  print(params);
                              context.pop(params);
                            },
                    );
                  },
                ),
              ],
            ),
          
        
        
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            onMapCreated: mapCreated,
            minMaxZoomPreference: const MinMaxZoomPreference(6, 16),
            initialCameraPosition: CameraPosition(
                target: LatLng(loc?.latitude ?? 5.617830930291503,
                    loc?.longitude ?? -0.16952356970849),
                zoom: 15.0,
                bearing: loc?.heading ?? 0),
            myLocationEnabled: true,
            onTap: (latLng) async {
              Map<String, dynamic> params = {
                "lat": latLng.latitude,
                "lng": latLng.longitude,
              };
              homeBloc.add(GetPlaceByLatLngEvent(params: params));
            },
          ),
        ],
      ),
    );
  }
}
