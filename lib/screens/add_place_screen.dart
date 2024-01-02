import 'dart:io';

import 'package:adventure_diary/midels/place.dart';
import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/select_on_map_screen.dart';
import 'package:adventure_diary/styles/app_styles.dart';
import 'package:adventure_diary/widgets/image_input.dart';
import 'package:adventure_diary/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});
  static const String routePath = "/addPlaces";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _addressController.dispose();
  }

  File? _pickedImage;

  void _selectedImage(File img) {
    _pickedImage = img;
  }

  void submitPlace() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter the title"),
      ));
      return;
    }
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Select an Image"),
      ));
      return;
    }
    final location = ref.read(previousLocationProvider);
    var address = ref.read(addressProvider);
    if (address == null && _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a address"),
        ),
      );
        return;
    }
    if(address == null && _addressController.text.isNotEmpty){
      address = _addressController.text;
    }
    final PlaceLocation? pickedLocation;
    if (location != null || address != null) {
      pickedLocation = PlaceLocation(
        latitude: (location == null) ? 0 : location.latitude,
        longitude: (location == null) ? 0 : location.longitude,
        address: address ?? "",
      );
    } else {
      pickedLocation = null;
    }

    ref
        .read(greatPlacesProvider.notifier)
        .addPlace(_titleController.text, _pickedImage!, pickedLocation);

    ref.read(addressProvider.notifier).update(
          (state) => null,
        );
    ref.read(showPreviewProvider.notifier).update((state) => false);
    ref.read(previousLocationProvider.notifier).update((state) => null);
    final navigator = Routemaster.of(context);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new place", style: AppStyles.titleTheme),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            ref.read(addressProvider.notifier).update(
                  (state) => null,
                );
            ref.read(showPreviewProvider.notifier).update((state) => false);
            ref.read(previousLocationProvider.notifier).update((state) => null);
            Routemaster.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                          color: Color(0xff1b6c55),
                          fontFamily: 'notoSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Title",
                        hintStyle: const TextStyle(
                            color: Color(0xff1b6c55),
                            fontFamily: 'notoSans',
                            fontSize: 18),
                        fillColor: const Color.fromARGB(255, 233, 241, 235),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Color(0xff347c68)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer(builder: (context, ref, child) {
                      final address = ref.watch(addressProvider);
                      if (address != null && address.isNotEmpty) {
                        _addressController.text = address;
                      }
                      return TextField(
                        controller: _addressController,
                        minLines: 2,
                        maxLines: 5,
                        style: const TextStyle(
                            color: Color(0xff1b6c55),
                            fontFamily: 'notoSans',
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Enter Address",
                          hintStyle: const TextStyle(
                              color: Color(0xff1b6c55),
                              fontFamily: 'notoSans',
                              fontSize: 18),
                          fillColor: const Color.fromARGB(255, 233, 241, 235),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xff347c68)),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    ImageInput(
                      saveImage: _selectedImage,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const LocationInput(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  submitPlace();
                },
                icon: const Icon(
                  Icons.add,
                  size: 25,
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff1b6c55)),
                label: const Text(
                  "Add Place",
                  style: TextStyle(fontFamily: 'notoSans', fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
