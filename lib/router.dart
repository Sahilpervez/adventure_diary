import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/screens/places_list_screen.dart';
import 'package:adventure_diary/screens/select_on_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final routes = RouteMap(routes: {
  PlacesListScreen.routePath: (route) =>
      const MaterialPage(child: PlacesListScreen()),
  AddPlacesScreen.routePath: (route) =>
      const MaterialPage(child: AddPlacesScreen()),
  "${AddPlacesScreen.routePath}/${SelectOnMapScreen.routePath}": (route) =>
      const MaterialPage(child: SelectOnMapScreen()),
});
