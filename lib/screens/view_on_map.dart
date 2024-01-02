import 'package:adventure_diary/screens/place_details_screen.dart';
import 'package:adventure_diary/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ViewOnMap extends ConsumerStatefulWidget {
  const ViewOnMap({super.key});
  static const routePath = '/ViewOnMap';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewOnMapState();
}

class _ViewOnMapState extends ConsumerState<ViewOnMap> {
  late MapController _mapController;
  late TextEditingController _addressController;
  @override
  void initState() {
    super.initState();
    final data = ref.read(previewOnMapProvider);
    if (data == null) {
      _mapController = MapController();
      _addressController = TextEditingController();
      return;
    }
    _mapController = MapController(
      initMapWithUserPosition: false,
      initPosition: data['location'],
    );
    _addressController= TextEditingController(text: data['address']);
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = ref.read(previewOnMapProvider)!['location'];
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            showZoomController: true,
            controller: _mapController,
            mapIsLoading: const Center(
              child: CircularProgressIndicator(),
            ),
            initZoom: 17,
            androidHotReloadSupport: true,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(Icons.personal_injury, color: Colors.black, size: 48),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(Icons.location_on, color: Colors.black, size: 48),
              ),
            ),
            roadConfiguration: RoadConfiguration(roadColor: Colors.blueGrey),
            markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
                iconWidget:
                    Icon(Icons.person_pin_circle, color: Colors.black, size: 100),
              ),
            ),
            onMapIsReady: (isReady) async {
              if (isReady) {
                Future.delayed(const Duration(seconds: 1), () async {
                  await _mapController.addMarker(GeoPoint(
                      latitude: coordinates.latitude,
                      longitude: coordinates.longitude));
                });
              }
            },
          ),
          Positioned(
            // alignment: Alignment.bottomCenter,
            bottom: 25,
            child: Builder(
              builder: (context) {
                final address = _addressController.text;
                if (address.isEmpty) {
                  return const SizedBox();
                }
                return Container(
                  width: MediaQuery.of(context).size.width - 20,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(blurRadius: 20,spreadRadius: 2,color: Color.fromARGB(255, 83, 82, 82),offset: Offset(0, 8))
                      ]
                    ),
                    child: Text("ADDRESS:\n$address",
                        style: const TextStyle(
                          fontFamily: 'notoSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )));
              },
            ),
          ),
          Positioned(
            left: 15,top:15,
            child: AppStyles.appStyleIconButton(icon: const Icon(Icons.arrow_back_outlined), onTap: (){Routemaster.of(context).pop();})),
        ],
      ),
    );
  }
}
