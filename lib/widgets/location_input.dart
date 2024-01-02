import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/screens/select_on_map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:routemaster/routemaster.dart';

// final updateAddScreenFunctionProvider = StateProvider<Function>((ref) => (){});
final currentLocationProvider = StateProvider<LocationData?>((ref) => null);

final showPreviewProvider = StateProvider<bool>((ref) => false);

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  // final _mapController = MapController.withPosition(
  //     initPosition: GeoPoint(latitude: 28.70041, longitude: 77.1025));
  late MapController _mapController;

  Future<void> _getCurentUserLocation() async {
    final userlocation = ref.read(currentLocationProvider);
    ref.read(previousLocationProvider.notifier).update((state) => GeoPoint(
        latitude: userlocation!.latitude!,
        longitude: userlocation.longitude!));
    ref.read(showPreviewProvider.notifier).update((state) => true);
    if (kDebugMode) {
      print("LATITUDE = ${userlocation!.latitude}");
      print("LONGITUDE = ${userlocation.longitude}");
    }
  }

  @override
  void initState() {
    super.initState();
    setIntialLocation();
  }

  void setIntialLocation() async {
    final locationData = await Location().getLocation();
    ref.read(currentLocationProvider.notifier).update((state) => locationData);
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(previousLocationProvider);
    final showPreviewMap = ref.watch(showPreviewProvider);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(7),
          ),
          child: (position == null)
              ? const Center(
                  child: Text(
                    "No Preview Available",
                    textAlign: TextAlign.center,
                  ),
                )
              : (showPreviewMap == false)
                  ? const Center(
                      child: Text(
                        "No Preview Available",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Consumer(builder: (context, ref, _) {
                      final selectedPosition =
                          ref.watch(previousLocationProvider);
                      _mapController = MapController(
                        initMapWithUserPosition: false,
                        initPosition: selectedPosition,
                      );
                      return OSMFlutter(
                        showZoomController: true,
                        controller: _mapController,
                        mapIsLoading: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        initZoom: 15,
                        androidHotReloadSupport: true,
                        userLocationMarker: UserLocationMaker(
                          personMarker: const MarkerIcon(
                            icon: Icon(Icons.personal_injury,
                                color: Colors.black, size: 48),
                          ),
                          directionArrowMarker: const MarkerIcon(
                            icon: Icon(Icons.location_on,
                                color: Colors.black, size: 48),
                          ),
                        ),
                        roadConfiguration:
                            RoadConfiguration(roadColor: Colors.blueGrey),
                        markerOption: MarkerOption(
                          defaultMarker: const MarkerIcon(
                            iconWidget: Icon(Icons.person_pin_circle,
                                color: Colors.black, size: 100),
                          ),
                        ),
                        onMapIsReady: (isReady) async {
                          if (isReady) {
                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              await _mapController.addMarker(GeoPoint(
                                  latitude: position.latitude,
                                  longitude: position.longitude));
                            });
                          }
                        },
                      );
                    }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _getCurentUserLocation();
                  // final navigator = Routemaster.of(context);
                  // navigator.push("${AddPlacesScreen.routePath}/${SelectOnMapScreen.routePath}");
                },
                icon: const Icon(Icons.location_on),
                label: const Text(
                  "Current Location",
                  style: TextStyle(
                    fontFamily: 'notoSans',
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final navigator = Routemaster.of(context);
                  navigator.push(
                      "${AddPlacesScreen.routePath}${SelectOnMapScreen.routePath}");
                },
                icon: const Icon(Icons.map),
                label: const Text(
                  "Select on Map",
                  style: TextStyle(
                    fontFamily: 'notoSans',
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
