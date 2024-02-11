import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/styles/app_styles.dart';
import 'package:adventure_diary/widgets/adventure_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final dbLoadingProvier = StateProvider<bool>((ref) => false);

final loadingProvider = StateProvider<bool>((ref) => false);

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({super.key});
  static const String routePath = "/";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.read(loadingProvider);
    Future.delayed(const Duration(seconds: 2)).then((value){
      ref.read(greatPlacesProvider.notifier).fetchAndSetPlaces();
    });
    final places = ref.watch(greatPlacesProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Adventure Diary",
                style: AppStyles.titleTheme,
              ),
              AppStyles.appStyleIconButton(
                onTap: () {
                  final navigator = Routemaster.of(context);
                  navigator.push(AddPlacesScreen.routePath);
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            const Text(
              "Places you visited : ",
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'notoSans',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if(loading == true)
              Column(
                  children: [
                    SizedBox(height: (size.height/2.7),),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ),
            if(loading == false)
              if(places.isEmpty && ref.read(dbLoadingProvier) == false)
                Column(
                  children: [
                    SizedBox(height: (size.height/2.7),),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ),
              if(places.isEmpty && ref.read(dbLoadingProvier) == true)
                Column(children:[SizedBox(height: (size.height/2.7),),const Text("Seems you haven't added any places yet")]),
              if (places.isNotEmpty)
                ...places.map(
                (e) => AdventureCard(size: size, e: e),
              ),
          ],
        ),
      ),
    );
  }
}
