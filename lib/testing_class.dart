
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:localize_and_translate/localize_and_translate.dart';



class TestingClass extends StatefulWidget {
  @override
  _TestingClassState createState() => _TestingClassState();
}

class _TestingClassState extends State<TestingClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity,height: 30,),
          Column(
            children: translator.locals().map((i) {
              return OutlinedButton(
                onPressed: () {
                  translator.setNewLanguage(
                    context,
                    newLanguage: i.languageCode,
                    remember: true,
                    restart: true,
                  );
                },
                child: Text(i.languageCode == "en"?'English':'Arabic'),
              );
            }).toList(),
          ),
        ],
      ),
      // body: Column(
      //   children: [
      //     ListTile(
      //       title: Text("English"),
      //       onTap: () {
      //         LocaleNotifier.of(context).change('en');
      //         Get.off(MainPage());
      //       },
      //     ),
      //     ListTile(
      //       title: Text("دری"),
      //       onTap: () {
      //         LocaleNotifier.of(context).change('ar');
      //         Get.off(MainPage());
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
