import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/add_place_screen.dart';
import 'package:adventure_diary/screens/update_app_screen.dart';
import 'package:adventure_diary/styles/app_styles.dart';
import 'package:adventure_diary/widgets/adventure_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:routemaster/routemaster.dart';

final dbLoadingProvier = StateProvider<bool>((ref) => false);

final loadingProvider = StateProvider<bool>((ref) => false);

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});
  static const String routePath = "/";

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {

  @override
  void initState(){
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    print("Checking for updates");
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print("Update Available");
          update();
        }
      });
    }).catchError((e) {
      // ScaffoldMessenger.of(context).showSnackBar(e.toString());
      print(e.toString());
    });
  }

  void update() async {
    print("Updating");

    // await InAppUpdate.performImmediateUpdate();
    // InAppUpdate.completeFlexibleUpdate().then((value) {}).catchError((e) {
    //   print(e.toString());
    // });
    await InAppUpdate.performImmediateUpdate().then((value) {
      if(value == AppUpdateResult.userDeniedUpdate){
        Routemaster.of(context).replace(UpdateAppScreen.routePath);
      }else{
        
      }
      print("HELLO HERE IS THE REPLY OF THE UPDATE\n\n\n\n");
      print(value);
      print("\n\n\n\nREPLY ENDS\n\n\n\n");
    }).catchError((e){
      print("HELLO HERE IS THE ERROR OF THE UPDATE\n\n\n\n");
      print(e.toString());
      print("\n\n\n\nERROR ENDS\n\n\n\n");
    });
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.read(loadingProvider);
    Future.delayed(const Duration(seconds: 2)).then((value) {
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
            if (loading == true)
              Column(
                children: [
                  SizedBox(
                    height: (size.height / 2.7),
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            if (loading == false)
              if (places.isEmpty && ref.read(dbLoadingProvier) == false)
                Column(
                  children: [
                    SizedBox(
                      height: (size.height / 2.7),
                    ),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ),
            if (places.isEmpty && ref.read(dbLoadingProvier) == true)
              Column(children: [
                SizedBox(
                  height: (size.height / 2.7),
                ),
                const Text("Seems you haven't added any places yet")
              ]),
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
