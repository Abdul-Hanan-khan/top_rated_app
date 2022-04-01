final String _stageFCMTopic = "top_rated_stage";
final String _productionFCMTopic = "top_rated_production";

final String _productionBaseUrl = "http://www.topratedworld.com/toprated/AppApi/api";
final String _stageBaseUrl = "http://www.topratedworld.com/toprated/AppApi/api";

class Config {
  static const APP_NAME = "Top Rated";
  static const APP_ID = "com.toprated.top_rated_app";
  static const bool _IS_LIVE = true;
  static const bool _LOG_INFO_DATA = true;

  static String get status => _IS_LIVE ? "live" : "dev";
  static String get fcmTopic => _IS_LIVE ? _productionFCMTopic : _stageFCMTopic;
  static String get baseUrl => _IS_LIVE ? _productionBaseUrl : _stageBaseUrl;

  static get canLogInfoEvents => _LOG_INFO_DATA;

  static bool get isLiveEnvironment => _IS_LIVE;

  static const NOTIFICATION_CHANNEL_ID = "top_rated_channel_id";
  static const NOTIFICATION_CHANNEL_NAME = APP_NAME;
  static const NOTIFICATION_CHANNEL_DESCRIPTION = "$APP_NAME Notifications";
  static const GOOGLE_MAPS_KEY = "AIzaSyBRGz26XaODZ9j0iICKZ1mNvtmTLLPHiZI";
}
