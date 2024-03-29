import 'package:adventure_diary/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await InAppUpdate.checkForUpdate();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent,surfaceTint: Colors.white), 
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return routes;
      }),
      
    );
  }
}

// com.sahilpervez.adventure_diary