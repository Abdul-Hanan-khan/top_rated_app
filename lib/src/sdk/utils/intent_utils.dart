import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  static initCall(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url'.tr();
    }
  }

  static initSMS(String number) async {
    String url = "sms:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url'.tr();
    }
  }

  static initMail(String address, String subject, String body) async {
    String url = "mailto:$address?subject=$subject&body=$body";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url'.tr();
    }
  }

  static openMaps(String title, String latitude, String longitude) async {
    // String googleUrl =
    //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&z=17';

    String googleUrl = "comgooglemaps://?daddr=$latitude,$longitude&directionsmode=driving";

    // String googleUrl =
    // 'comgooglemaps://?center=$latitude,$longitude&zoom=14';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not launch url'.tr();
    }
  }

  static openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url'.tr();
    }
  }
}
