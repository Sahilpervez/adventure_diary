import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/screens/place_details_screen.dart';
import 'package:adventure_diary/screens/places_list_screen.dart';
import 'package:adventure_diary/screens/select_on_map_screen.dart';
import 'package:adventure_diary/screens/update_app_screen.dart';
import 'package:adventure_diary/screens/view_on_map.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:upgrader/upgrader.dart';

final routes = RouteMap(routes: {
  PlacesListScreen.routePath: (route) =>
      const MaterialPage(child: PlacesListScreen()),
  AddPlacesScreen.routePath: (route) =>
      const MaterialPage(child: AddPlacesScreen()),
  "${AddPlacesScreen.routePath}${SelectOnMapScreen.routePath}": (route) =>
      const MaterialPage(child: SelectOnMapScreen()),
  "${PlaceDetailsScreen.routePath}/:id": (route) {
    return MaterialPage(
      child: PlaceDetailsScreen(id: route.pathParameters['id'] as String),
    );
  },
  "${PlaceDetailsScreen.routePath}/:id/${ViewOnMap.routePath}" : (route){
    return const MaterialPage(child: ViewOnMap());
  },
  "${UpdateAppScreen.routePath}":(route) {
    return const MaterialPage(child: UpdateAppScreen());
  }
});
