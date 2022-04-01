import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/models/user_detail.dart';

import '../../config.dart';
import 'auth_manager.dart';
import 'rest_api_helper.dart';

class ApiProvider {
  RestApiHelper _helper = RestApiHelper();

  // MARK: - User -
  Future<Response> login(String email, String password) async {
    final url = "${Config.baseUrl}/user/login.php";
    final credentials = '$email:$password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };

    return await _helper.post(url, headers: headers, body: {});
  }

  Future<Response> register(String firstName, String lastName, String email, String password) async {
    final url = "${Config.baseUrl}/user/create.php";
    final body = {
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "Password": password,
    };
    return await _helper.post(url, body: {
      "User": json.encode(body),
      "UserRegister": "djkdi837487kdjkdfj93fdj1234w",
    });
  }

  Future<Response> getActivationCode(String email, String password) async {
    final url = "${Config.baseUrl}/user/requestActivateCode.php";
    final credentials = '$email:$password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };

    return await _helper.post(url, headers: headers, body: {});
  }

  Future<Response> verifyActivationCode(String email, String activationCode) async {
    final url = "${Config.baseUrl}/user/validateAccount.php";
    final credentials = '$email:$activationCode';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };

    return await _helper.post(url, headers: headers, body: {});
  }

  Future<Response> updatePassword(String email, String password) async {
    final url = "${Config.baseUrl}/user/updateUserPassword.php";
    final credentials = '$email:$password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };

    return await _helper.post(url, headers: headers, body: {"PasswordUpdate": "PasswordUpdate"});
  }

  Future<Response> resetPassword(String email) async {
    final url = "${Config.baseUrl}/user/resetPasswordRequest.php";
    final credentials = '$email:""';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };

    return await _helper.post(url, headers: headers, body: {"reset": "ResetPassword88f01885"});
  }

  Future<Response> getUserDetail({int id}) async {
    final url = "${Config.baseUrl}/user/userDetail.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    final Map<String, String> body = new Map();
    if (id != null) {
      body.putIfAbsent("UserID", () => "$id");
    }

    return await _helper.get(url, headers: headers, body: body);
  }

  Future<Response> getUserReviews(int id) async {
    final url = "${Config.baseUrl}/user/userReviews.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(url, headers: headers, body: json.encode({"UserID": id}));
  }

  Future<Response> getFavoritePlaces(int userId) async {
    final url = "${Config.baseUrl}/user/favouriteList.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);

    return await _helper.post(url, headers: headers, body: jsonEncode({"UserID": userId}));
  }

  Future<Response> updateUserDetail(User user, UserDetail detail) async {
    final url = "${Config.baseUrl}/user/update.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);
    return await _helper.post(url, headers: headers, body: {
      "User": json.encode(user.toJson()),
      "UserDetail": json.encode(detail.toJson()),
    });
  }

  Future<Response> updateUserImage(String imageName, String imageBase64) async {
    final url = "${Config.baseUrl}/user/updateImage.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);

    return await _helper.post(url, headers: headers, body: {
      "ImageName": imageName,
      "Image": imageBase64,
    });
  }

  Future<Response> updatePlaceImage(String imageName, String imageBase64) async {
    final url = "${Config.baseUrl}/place/updateImage.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);

    return await _helper.post(url, headers: headers, body: {
      "ImageName": imageName,
      "Image": imageBase64,
    });
  }

  Future<Response> updatePlace(
      Place place, String address, String phone, String city, String location, String website, String bio) async {
    final url = "${Config.baseUrl}/place/update.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);

    var placeMap = place.toJson();
    placeMap.putIfAbsent("Phone", () => phone);

    var details = {
      "PlaceAddress": address,
      "PlaceBio": bio,
      "PlaceLocation": location,
      "PlaceCity": city,
      "PlaceWebsite": website,
    };

    return await _helper.post(url, headers: headers, body: {
      "Place": json.encode(placeMap),
      "PlaceDetail": json.encode(details),
    });
  }

  Future<Response> getCities() async {
    final url = "${Config.baseUrl}/city/read.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    // headers.remove(HttpHeaders.contentTypeHeader);

    return await _helper.get(url, headers: headers, body: {});
  }

  Future<Response> getCategories() async {
    final url = "${Config.baseUrl}/category/read.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.get(url, headers: headers, body: {});
  }

  Future<Response> getPlaces(int subCategoryId) async {
    final url = "${Config.baseUrl}/place/read.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{'SubCategoryID': subCategoryId},
      ),
    );
  }

  Future<Response> getPlaceDetail(int placeId) async {
    final url = "${Config.baseUrl}/placeDetail/read.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{'PlaceID': placeId},
      ),
    );
  }

  Future<Response> getNotifications() async {
    final url = "${Config.baseUrl}/message/read.php";
    // final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.get(
      url,
      headers: {},
      body: {},
    );
  }

  Future<Response> getRatingTypes() async {
    final url = "${Config.baseUrl}/rating/read.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.get(
      url,
      headers: headers,
      body: {},
    );
  }

  Future<Response> postUserReview(int placeId, int userId, String review, Map<String, double> ratings) async {
    final url = "${Config.baseUrl}/rating/create.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    List<Map<String, dynamic>> data = new List.empty(growable: true);

    ratings.forEach((key, value) {
      data.add(
        {
          "RatingTypeID": key,
          "RateValue": value,
        },
      );
    });

    final body = {
      "PlaceID": placeId,
      "UserID": userId,
      "Review": review,
      "UserRating": data,
    };

    return await _helper.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
  }

  Future<Response> replyOnReview(int ratingId, int userId, String text) async {
    final url = "${Config.baseUrl}/rating/reply.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{'RatingID': ratingId, "UserID": userId, "Reply": text},
      ),
    );
  }

  Future<Response> like(int ratingId, bool isLike) async {
    final url = "${Config.baseUrl}/rating/like.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{
          'RatingID': ratingId,
          "Like": isLike ? 1 : 0,
        },
      ),
    );
  }

  Future<Response> favorite(int placeId, bool isFavorite) async {
    final url = "${Config.baseUrl}/user/favourite.php";
    final headers = await AuthManager.instance.getAuthHeaders();
    headers.remove(HttpHeaders.contentTypeHeader);

    return await _helper.post(
      url,
      headers: headers,
      body: json.encode({
        'PlaceID': placeId,
        "Favourite": isFavorite ? 1 : 0,
      }),
    );
  }

  // Followers
  Future<Response> getFollowersList(int userId) async {
    final url = "${Config.baseUrl}/follow/followerList.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{'UserID': userId},
      ),
    );
  }

  Future<Response> getFollowingList(int userId) async {
    final url = "${Config.baseUrl}/follow/followingList.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{'UserID': userId},
      ),
    );
  }

  Future<Response> follow(int followerId, int followingId, bool isFollow) async {
    final url = "${Config.baseUrl}/follow/follow.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, int>{
          'FollowerID': followerId,
          "FollowingID": followingId,
          "Follow": isFollow ? 1 : 0,
        },
      ),
    );
  }

  // Vendors
  Future<Response> registerVendor(
      String email,
      String password,
      String placeEng,
      String placeArb,
      String phone,
      int subCategoryId,
      String address,
      String bio,
      String website,
      String location,
      String imageBase64,
      String imageName) async {
    final url = "${Config.baseUrl}/place/create.php";

    var body = {
      "PlaceEnglish": placeEng,
      "PlaceArabic": placeArb,
      "Phone": phone,
      "SubCategoryID": subCategoryId,
      "Email": email,
      "Password": password,
      "PlaceAddress": address,
      "PlaceBio": bio,
      "PlaceWebsite": website,
      "PlaceLocation": location,
      "AdminID": 0,
    };

    if (imageName.isNotEmpty) {
      body.putIfAbsent("ImageName", () => imageName);
    }

    if (imageBase64.isNotEmpty) {
      body.putIfAbsent("Image", () => imageBase64);
    }

    return await _helper.post(url, body: {
      "Place": json.encode(body),
      "PlaceRegister": "djkdi837487kdjkdfj93fdj1234w",
    });
  }

  Future<Response> message(String title, String message, {String imageName, String imageBase64}) async {
    final url = "${Config.baseUrl}/message/create.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    var map = <String, String>{
      "MessageTitle": title,
      'Message': message,
    };
    if (imageName != null && imageName.isNotEmpty) {
      map.putIfAbsent("ImageName", () => imageName);
    }

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      map.putIfAbsent("Image", () => imageBase64);
    }

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(map),
    );
  }

  Future<Response> setDeviceToken(String deviceToken) async {
    final url = "${Config.baseUrl}/user/deviceToken.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.post(
      url,
      headers: headers,
      body: jsonEncode(
        <String, String>{"deviceToken": deviceToken},
      ),
    );
  }

  Future<Response> getVendorStats() async {
    final url = "${Config.baseUrl}/place/stat.php";
    final headers = await AuthManager.instance.getAuthHeaders();

    return await _helper.get(
      url,
      headers: headers,
      body: {},
    );
  }
}
