
import 'package:adventure_diary/midels/place.dart';
import 'package:adventure_diary/repository/great_places_repo.dart';
import 'package:adventure_diary/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:routemaster/routemaster.dart';

class AdventureCard extends ConsumerWidget {
  const AdventureCard({
    super.key,
    required this.size,
    required this.e,
  });
  final Place e;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: (){
          Routemaster.of(context).push('${PlaceDetailsScreen.routePath}/${e.id}');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          // margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(7),
          height: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(tag: e.id,
                child: Container(
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
              ),
              SizedBox(
                // color: Colors.amber,
                width: size.width * 0.65 - 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: e.title,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          e.title,
                          style: const TextStyle(
                            fontFamily: 'notoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
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
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ElevatedButton(
                        //   onPressed: (){
                        //     QuickAlert.show(context: context, type: QuickAlertType.loading,text: "Feature yet to arrive");
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xff015b42),
                        //     foregroundColor: Colors.white,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10)
                        //     )
                        //   ),
                        //   child: const Text("Edit")
                        // ),
                        // const SizedBox(width: 10),
                        TextButton(
                          onPressed: (){
                            QuickAlert.show(context: context, type: QuickAlertType.confirm,
                            widget: Text.rich(
                              TextSpan(
                                text: "You want to delete ",
                                children: [
                                  TextSpan(text: e.title,style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " adventure"),
                                ]
                              ),
                              textAlign: TextAlign.center,
                            ),
                            confirmBtnColor: const Color(0xff015b42),
                            onConfirmBtnTap: () {
                            ref.read(greatPlacesProvider.notifier).deleteItem(e.id);
                            Navigator.of(context).pop();
                            },onCancelBtnTap: (){
                              Navigator.of(context).pop();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: const Text("Delete")
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
