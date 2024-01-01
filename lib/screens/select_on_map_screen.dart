import 'package:adventure_diary/styles/app_styles.dart';
import 'package:adventure_diary/widgets/location_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:routemaster/routemaster.dart';

final previousLocationProvider = StateProvider<GeoPoint?>((ref) => null);

final addressProvider = StateProvider<String?>((ref) => null);

final class SelectOnMapScreen extends ConsumerStatefulWidget {
  const SelectOnMapScreen({super.key});
  static const routePath = '/selectLocation';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectOnMapScreenState();
}

class _SelectOnMapScreenState extends ConsumerState<SelectOnMapScreen> {
  final _mapController = MapController(initMapWithUserPosition: true);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _mapController.listenerMapSingleTapping.addListener(() async {
        // when we tap the map we will add the marker
        var position = _mapController.listenerMapSingleTapping.value;
        if (position != null) {
          final prevPos = ref.read(previousLocationProvider);
          if (kDebugMode) {
            print("PREVIOUS LATITUDE = ${prevPos?.latitude}");
            print("PREVIOUS LONGITUDE = ${prevPos?.longitude}");
          }
          if (prevPos != null) {
            if (kDebugMode) {
              print("REMOVING LOCATION....");
            }
            await _mapController.removeMarker(prevPos);
            if (kDebugMode) {
              print('PREVIOUS LOCATION REMOVED');
            }
          }
          if (kDebugMode) {
            print('----------');
            print("ADDING LOCATION FOR THE FIRST TIME....");
          }
          await _mapController.changeLocation(position);
          if (kDebugMode) {
            print("LOCATION ADDED FOR FIRST TIME");
            print('----------');
            print('UPDATING PROVIDER...');
          }
          ref
              .read(previousLocationProvider.notifier)
              .update((state) => position);
          if (kDebugMode) {
            print('PROVIDER UPDATED !!');
            print("LATITUDE = ${position.latitude}");
            print("LONGITUDE = ${position.longitude}");
          }
          final Future<List<Placemark>> address =
              placemarkFromCoordinates(position.latitude, position.longitude);
          selectAddress(address);
        }
      });
    });
  }

  void selectAddress(Future<List<Placemark>> address) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          enableDrag: true,
          elevation: 0,
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Address",
                        style: TextStyle(
                          fontFamily: 'notoSans',
                          color: Color(0xff347C68),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppStyles.AppIconButton(
                        icon: const Icon(Icons.cancel),
                        onTap: () {
                          Routemaster.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: address,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("Cannot get addresses."));
                      } else {
                        final data = snapshot.data;
                        if (data == null) {
                          return const Text("No addressed found.");
                        }
                        return Expanded(
                          child: ListView(children: [
                            ...data.mapWithIndex(
                              (e, index) => MaterialButton(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                onPressed: () {
                                  ref.read(addressProvider.notifier).update(
                                      (state) =>
                                          "${e.name}, ${e.street}, ${e.locality}, ${e.subAdministrativeArea}, ${e.subAdministrativeArea}, Postal Code : ${e.postalCode}, ${e.country}");
                                  Routemaster.of(context).pop();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "${index + 1}. ",
                                          style: const TextStyle(
                                            fontFamily: 'notoSans',
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(
                                          text:
                                              "${e.name}, ${e.street}, ${e.locality}, ${e.subAdministrativeArea}, ${e.subAdministrativeArea}, postal code : ${e.postalCode}, ${e.country}",
                                          style: const TextStyle(
                                            fontFamily: 'notoSans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ]),
                        );
                      }
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select a place on map",
          style: AppStyles.titleTheme,
        ),
      ),
      body: Stack(
        children: [
          OSMFlutter(
            showZoomController: true,
            controller: _mapController,
            mapIsLoading: const Center(
              child: CircularProgressIndicator(),
            ),
            androidHotReloadSupport: true,
            trackMyPosition: true,
            initZoom: 14,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon:
                    Icon(Icons.personal_injury, color: Colors.black, size: 48),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(Icons.location_on, color: Colors.black, size: 48),
              ),
            ),
            roadConfiguration: RoadConfiguration(roadColor: Colors.blueGrey),
            markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
                iconWidget: Icon(Icons.person_pin_circle,
                    color: Colors.black, size: 100),
              ),
            ),
            onMapIsReady: (isReady) async {
              if (isReady) {
                Future.delayed(const Duration(seconds: 1), () async {
                  await _mapController.currentLocation();
                });
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Consumer(
              builder: (context, ref, child) {
                var positions = ref.watch(previousLocationProvider);
                if (positions == null) {
                  return const SizedBox();
                }
                return Container(
                  width: MediaQuery.of(context).size.width - 30,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ref.read(updateAddScreenFunctionProvider)(positions);
                      ref.read(showPreviewProvider.notifier).update((state) => true);
                      Routemaster.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.done,
                      size: 25,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff1b6c55)),
                    label: const Text(
                      "DONE",
                      style: TextStyle(fontFamily: 'notoSans', fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Consumer(
              builder: (context, ref, child) {
                var address = ref.watch(addressProvider);
                if (address == null) {
                  return const SizedBox();
                }
                return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text("SELECTED ADDRESS:\n$address",
                        style: const TextStyle(
                          fontFamily: 'notoSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
