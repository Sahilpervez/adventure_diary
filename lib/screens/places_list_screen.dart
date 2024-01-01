import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/styles/app_styles.dart';
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
              AppStyles.AppIconButton(
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
              const Center(child: CircularProgressIndicator()),
            if(loading == false)
              if(places.isEmpty && ref.read(dbLoadingProvier) == false)
                const Center(child: CircularProgressIndicator()),
              if(places.isEmpty && ref.read(dbLoadingProvier) == true)
                const Center(child:Text("Seems you haven't added any places yet")),
              if (places.isNotEmpty)
                ...places.map(
                (e) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(7),
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: FileImage(
                                e.image,
                              ),
                              fit: BoxFit.cover),
                        ),
                        width: size.width * 0.35,
                      ),
                      SizedBox(
                        // color: Colors.amber,
                        width: size.width * 0.65 - 54,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontFamily: 'notoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              e.location!.address,
                              style: const TextStyle(
                                fontFamily: 'notoSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
