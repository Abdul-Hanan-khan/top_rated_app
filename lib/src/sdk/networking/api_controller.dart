import 'dart:convert';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/sdk/models/city.dart';
import 'package:top_rated_app/src/sdk/models/message.dart';
import 'package:top_rated_app/src/sdk/models/place_stats.dart';
import 'package:top_rated_app/src/sdk/models/rating_type.dart';
import 'package:top_rated_app/src/sdk/models/user_detail.dart';
import 'package:top_rated_app/src/sdk/models/user_rating.dart';

import '../constants/api_status_code.dart';
import '../constants/error_messages.dart';
import '../models/category.dart';
import '../models/place.dart';
import '../models/place_detail.dart';
import '../models/user.dart';
import 'api_provider.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';

class ApiController {
  ApiController._privateConstructor();
  static final ApiController _instance = ApiController._privateConstructor();
  static ApiController get instance => _instance;

  final _provider = ApiProvider();

  Future<Tuple2<User, Place>> login(String email, String password) async {
    Response response;
    try {
      response = await _provider.login(email, password);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          if (parsedJson["User"] != null) {
            final user = User.fromJson(parsedJson["User"]);
            return Tuple2(user, null);
          } else {
            final place = Place.fromJson(parsedJson["Place"]);
            return Tuple2(null, place);
          }
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.LOGIN.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<User> register(String firstName, String lastName, String email, String password) async {
    Response response;
    try {
      response = await _provider.register(firstName, lastName, email, password);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final user = User.fromJson(parsedJson["User"]);
          return user;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.REGISTER.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> setDeviceToken(String deviceToken) async {
    Response response;
    try {
      response = await _provider.setDeviceToken(deviceToken);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.DEVICE_TOKEN.tr());
      }
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<Place> registerVendor(
      String nameEng,
      String nameArb,
      String email,
      String password,
      String phone,
      int subCategoryId,
      String address,
      String bio,
      String website,
      String location,
      String imageName,
      String imageBase64) async {
    Response response;
    try {
      response = await _provider.registerVendor(email, password, nameEng, nameArb, phone, subCategoryId, address, bio,
          website, location, imageBase64, imageName);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final place = Place.fromJson(parsedJson["Place"]);
          return place;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.REGISTER.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> sendActivationCode(String email, String password) async {
    Response response;
    try {
      response = await _provider.getActivationCode(email, password);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<bool> resetPassword(String email) async {
    Response response;
    try {
      response = await _provider.resetPassword(email);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          throw (res.item2 ?? ErrorMessages.SEND_ACTIVATION_CODE.tr());
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<bool> updatePassword(String email, String password) async {
    Response response;
    try {
      response = await _provider.updatePassword(email, password);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          throw (res.item2 ?? ErrorMessages.UPDATE_PASSWORD.tr());
        }
      } else {
        throw (ErrorMessages.UPDATE_PASSWORD.tr());
      }
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<String> verifyActivationCode(String email, String code) async {
    Response response;
    try {
      response = await _provider.verifyActivationCode(email, code);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return UserStatus.active;
        } else {
          return null;
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<UserDetail> getUserDetail({int id}) async {
    Response response;
    try {
      response = await _provider.getUserDetail(id: id);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final detail = UserDetail.fromJson(parsedJson["UserDetail"]);
          return detail;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_USER_DETAIL.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> updateUserDetail(User user, UserDetail detail) async {
    Response response;
    try {
      response = await _provider.updateUserDetail(user, detail);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> updateUserImage(String imageName, String imageBase64) async {
    Response response;
    try {
      response = await _provider.updateUserImage(imageName, imageBase64);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        return (parsedJson["imagePath"] as String) ?? null;
      } else {
        throw (ErrorMessages.IMAGE_UPDATE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> updatePlaceImage(String imageName, String imageBase64) async {
    Response response;
    try {
      response = await _provider.updatePlaceImage(imageName, imageBase64);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        return (parsedJson["imagePath"] as String) ?? null;
      } else {
        throw (ErrorMessages.IMAGE_UPDATE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<UserRating>> getUserReviews(int userId) async {
    Response response;
    try {
      response = await _provider.getUserReviews(userId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<UserRating>.from(parsedJson['Ratings'].map((x) => UserRating.fromJson(x)));
          return list;
        } else {
          throw (ErrorMessages.GET_REVIEWS.tr());
        }
      } else {
        throw (ErrorMessages.GET_REVIEWS.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Category>> getCategories() async {
    Response response;
    try {
      response = await _provider.getCategories();
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<Category>.from(parsedJson['Categories'].map((x) => Category.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.REGISTER.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Place>> getFavoritePlaces(int userId) async {
    Response response;
    try {
      response = await _provider.getFavoritePlaces(userId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<Place>.from(parsedJson['favourites'].map((x) => Place.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_PLACES.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Place>> getPlaces(int subCategoryId) async {
    Response response;
    try {
      response = await _provider.getPlaces(subCategoryId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<Place>.from(parsedJson['Places'].map((x) => Place.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_PLACES.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<PlaceDetail> getPlaceDetail(int placeId) async {
    Response response;
    try {
      response = await _provider.getPlaceDetail(placeId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final obj = parsedJson["PlaceDetail"] as Map<String, dynamic>;
          if (obj["Ratings"] == null) {
            obj.update("Ratings", (value) => []);
          }
          if (obj["AverageRating"] == null) {
            obj.update("AverageRating", (value) => []);
          }
          final detail = PlaceDetail.fromJson(obj);
          return detail;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_PLACE_DETAIL.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Message>> getNotifications() async {
    Response response;
    try {
      response = await _provider.getNotifications();
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<Message>.from(parsedJson['Messages'].map((x) => Message.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_PLACES.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<City>> getCities() async {
    Response response;
    try {
      response = await _provider.getCities();
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<City>.from(parsedJson['Cities'].map((x) => City.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_PLACES.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<RatingType>> getRatingTypes() async {
    Response response;
    try {
      response = await _provider.getRatingTypes();
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<RatingType>.from(parsedJson['RatingTypes'].map((x) => RatingType.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_RATING_TYPES.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> postUserReview(int placeId, int userId, String review, Map<String, double> ratings) async {
    Response response;
    try {
      response = await _provider.postUserReview(placeId, userId, review, ratings);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> replyOnReview(int ratingId, int userId, String text) async {
    Response response;
    try {
      response = await _provider.replyOnReview(ratingId, userId, text);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.FOLLOW.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> like(int ratingId, bool isLike) async {
    Response response;
    try {
      response = await _provider.like(ratingId, isLike);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.LIKE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> favorite(int placeId, bool isFavorite) async {
    Response response;
    try {
      response = await _provider.favorite(placeId, isFavorite);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.FAVORITE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  // Follow
  Future<bool> follow(int followerId, int followingId, bool isFollow) async {
    Response response;
    try {
      response = await _provider.follow(followerId, followingId, isFollow);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.FOLLOW.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<User>> getFollowersList(int userId) async {
    Response response;
    try {
      response = await _provider.getFollowersList(userId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<User>.from(parsedJson['followers'].map((x) => User.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_USER_DETAIL.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<User>> getFollowingList(int userId) async {
    Response response;
    try {
      response = await _provider.getFollowingList(userId);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final list = new List<User>.from(parsedJson['followings'].map((x) => User.fromJson(x)));
          return list;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.GET_USER_DETAIL.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> message(String title, String message, {String imageName, String imageBase64}) async {
    Response response;
    try {
      response = await _provider.message(title, message, imageName: imageName, imageBase64: imageBase64);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return res.item2;
        } else {
          return null;
        }
      } else {
        throw (ErrorMessages.MESSAGE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> updatePlace(
      Place place, String address, String phone, String city, String location, String website, String bio) async {
    Response response;
    try {
      response = await _provider.updatePlace(place, address, phone, city, location, website, bio);
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          return true;
        } else {
          return false;
        }
      } else {
        throw (ErrorMessages.SEND_ACTIVATION_CODE.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<PlaceStats> getVendorStats() async {
    Response response;
    try {
      response = await _provider.getVendorStats();
      if (response.statusCode >= ApiStatusCode.OK && response.statusCode <= ApiStatusCode.ERROR) {
        final parsedJson = json.decode(response.body);
        final res = _handle(parsedJson);
        if (res.item1 == ApiStatusCode.SUCCESS) {
          final stats = PlaceStats.fromJson(parsedJson["PlaceStats"]);
          return stats;
        } else {
          throw (res.item2);
        }
      } else {
        throw (ErrorMessages.STATS.tr());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Tuple2 _handle(Map<String, dynamic> json) {
    var status = json["Success"] as int;
    if (status == null) {
      status = json["success"] as int;
    }
    String message = json["Status"] as String ?? json["message"] as String ?? null;
    return Tuple2(status, message);
  }
}
