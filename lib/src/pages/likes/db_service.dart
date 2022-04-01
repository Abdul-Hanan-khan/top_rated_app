import 'package:firebase_database/firebase_database.dart';
import 'package:top_rated_app/src/sdk/models/likes.dart';


class DatabaseService {

  static Future<List<Likes>> getlikes() async {

    DatabaseReference likesRef;
    likesRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('81')
        .child('likes');
    List<Likes> likes;

    likesRef.once().then((snapShot) {
      Map<dynamic, dynamic> values = snapShot.value;
      values.forEach((key, values) {
        // likes.add(Likes.fromSnapshot(values));
      });

    });

    print(likes);


    return likes;
  }
}