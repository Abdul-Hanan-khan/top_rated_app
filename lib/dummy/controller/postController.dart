import 'package:get/get.dart';
import 'package:top_rated_app/dummy/controller/get_data_fb.dart';

class NotificationController extends GetxController {
  MyDatabaseController dbController = Get.find();

  RxInt totalComments = 0.obs;
  RxInt totalReplies = 0.obs;
  RxInt currentPostIndex = 0.obs;
  RxInt allLikes=0.obs;

  void calculateComments(var notification) {

    currentPostIndex.value = dbController.allPosts.indexWhere((element) => element.postID == notification.id);
    if (currentPostIndex.value == -1) {
      totalComments.value = 0;
    } else {
      totalComments.value =  dbController.allPosts[currentPostIndex.value].comment.length;
    }
  }
}
