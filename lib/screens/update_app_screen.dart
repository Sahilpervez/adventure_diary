import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateAppScreen extends ConsumerStatefulWidget {
  const UpdateAppScreen({super.key});
  static const routePath = "/UpdateAppScreen";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UpdateAppScreenState();
}

class UpdateAppScreenState extends ConsumerState<UpdateAppScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
              height: size.height * 2 / 3.5,
              width: size.width,
              child: SvgPicture.asset('assets/images/force_update.svg',
                  fit: BoxFit.cover)),
          const Spacer(
            flex: 1,
          ),
          const Text(
            "We are better than ever",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
          ),
          // Text(
          //   "Here is an awesome update",
          //   style: TextStyle(fontSize: 20),
          // ),
          const Text("Update the app to keep using the service",
              style: TextStyle(fontSize: 17)),
          const SizedBox(height: 15),
          ElevatedButton(
              onPressed: () async {
                await InAppUpdate.checkForUpdate().then((value) async {
                  await InAppUpdate.performImmediateUpdate();
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff22C8D6),
                  foregroundColor: Colors.white),
              child:  const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text("UPDATE",style: TextStyle(fontSize: 16)))),
          const Spacer(flex: 2),
        ],
      ),
    ));
  }
}
