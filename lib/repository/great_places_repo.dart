import 'dart:io';

import 'package:adventure_diary/midels/place.dart';
import 'package:adventure_diary/screens/places_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adventure_diary/helpers/db_helper.dart';

final greatPlacesProvider = StateNotifierProvider<GreatPlaces, List<Place>>(
  (ref) {
    return GreatPlaces([], ref: ref);
  },
);

class GreatPlaces extends StateNotifier<List<Place>> {
  final StateNotifierProviderRef _ref;

  GreatPlaces(super._state, {required ref}) : _ref = ref;

  List<Place> get places {
    return [...state];
  }
  Place getPlaceById(String id){
    final ele = state.firstWhere((element) => element.id == id);
    return ele;
  }
  void addPlace(
      String pickedTitle, File pickedImage, PlaceLocation? pickedLoation) {
    final currPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: pickedLoation,
        image: pickedImage);
    state = [
      currPlace,
      ...state,
    ];
    DBHelper.insert('places', {
      'id': currPlace.id,
      'title': currPlace.title,
      'image': currPlace.image.path,
      'loc_lat':
          (currPlace.location == null) ? 0.0 : currPlace.location!.latitude,
      'loc_long':
          (currPlace.location == null) ? 0.0 : currPlace.location!.longitude,
      'address':
          (currPlace.location == null) ? '' : currPlace.location!.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    _ref.read(loadingProvider.notifier).update((state) => true);
    final loadingState = _ref.read(dbLoadingProvier);
    if (loadingState == true) {
      _ref.read(loadingProvider.notifier).update((state) => false);
      return;
    }
    final data = await DBHelper.getData('places');
    final List<Place> places = [];
    for (var element in data) {
      places.add(Place(
        id: element['id'],
        image: File(element['image']),
        title: element['title'],
        location: PlaceLocation(
          address: element['address'],
          latitude: element['loc_lat'],
          longitude: element['loc_long'],
        ),
      ));
    }
    state = [
      ...places,
      ...state,
    ];
    _ref.read(dbLoadingProvier.notifier).update((state) => true);
    _ref.read(loadingProvider.notifier).update((state) => false);
  }

  Future<bool> deleteItem(id) async{
    final res = await DBHelper.deleteAdventure(id);
    if(res != true){
      return false;
    }
    state.removeWhere((element) => element.id == id);
    state = [...state];
    return true;
  }
}
