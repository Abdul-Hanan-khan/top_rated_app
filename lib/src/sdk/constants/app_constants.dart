class AppConstants {
  static final apiDateFormat = "dd-MM-yyyy";
  static final apiTimeFormat = "hh:mm a";
  static final apiDateTimeFormat = "yyyy-MM-dd HH:mm:ss";

  static final appDateFormat = "dd/MM/yyyy";
  static final appTimeFormat = "hh:mm a";
  static final appDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  static final imageCategoryBaseUrl =
      "http://www.topratedworld.com/toprated/AppApi/api/category/imageDownloader.php?image=";

  static final imagePlaceBaseUrl = "http://www.topratedworld.com/toprated/AppApi/api/place/imageDownloader.php?image=";
  static final imageMessageBaseUrl = "http://www.topratedworld.com/toprated/AppApi/api/message/imageDownloader.php?image=";
  static final imageUserBaseUrl = "http://www.topratedworld.com/toprated/AppApi/api/user/imageDownloader.php?image=";
}

class Routes {
  static final login = "/login";
  static final userRegister = "/userRegister";
  static final vendorRegister = "/vendorRegister";
  static final home = "/home";
  static final vendorHome = "/vendorHome";
  static final verification = "/verification";
}

class WidgetConstants {
  static final cornerRadius = 20.0;
  static final textFieldRadius = 20.0;
  static final cardHeight = 140.0;
}

class FirebaseTopics {
  static final general = "General";
}
