import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/view_on_map.dart';
import 'package:adventure_diary/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final previewOnMapProvider = StateProvider<Map<String,dynamic>?>((ref) {
  return null;
});

class PlaceDetailsScreen extends ConsumerWidget {
  static const routePath = '/PlaceDdetailsScreen';
  const PlaceDetailsScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currPlace = ref
        .read(greatPlacesProvider.notifier)
        .getPlaceById(id.replaceAll("%20", " "));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: currPlace.id,
                child: Container(
                    width: size.width,
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: FileImage(currPlace.image),
                      fit: BoxFit.cover,
                    ))),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: SizedBox(
                  width: size.width - 30,
                  child: Hero(
                    tag: currPlace.title,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        currPlace.title,
                        style: const TextStyle(
                          fontFamily: 'notoSans',
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15, left: 15,
                child: AppStyles.appStyleIconButton(
                    icon: const Icon(Icons.arrow_back_rounded), onTap: () {
                      Routemaster.of(context).pop();
                    }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (currPlace.location != null &&
                  currPlace.location!.address.isNotEmpty) ...[
                const Text(
                  "Address :",
                  style: TextStyle(
                    fontFamily: 'notoSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                Text(currPlace.location!.address.replaceAll(',,,', ''),
                    style: const TextStyle(
                      fontFamily: 'notoSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ],
              if (currPlace.location != null &&
                  currPlace.location!.latitude != 0 &&
                  currPlace.location!.longitude != 0) ...[
                const Text(
                  "Location :",
                  style: TextStyle(
                    fontFamily: 'notoSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                Text(
                    "Latitude: ${currPlace.location!.latitude}\nLongitude: ${currPlace.location!.longitude}",
                    style: const TextStyle(
                      fontFamily: 'notoSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )),
              ],
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(previewOnMapProvider.notifier).update((state) => {
                        'address' : currPlace.location!.address,
                        'location' : GeoPoint(latitude: currPlace.location!.latitude,longitude: currPlace.location!.longitude)
                      });
                      Routemaster.of(context).push('${PlaceDetailsScreen.routePath}/${id.replaceAll("%20", " ")}${ViewOnMap.routePath}');
                    },
                    icon: const Icon(Icons.map_rounded),
                    label: const Text("View on Map")),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
