import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_rated_app/dummy/controller/get_data_fb.dart';
class TestHome extends StatefulWidget {
  const TestHome({Key key}) : super(key: key);

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  MyDatabaseController dbController=Get.find();
  @override
  Widget build(BuildContext context) {
    MyDatabaseController dbController=Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text("test home",style: TextStyle(color: Colors.black),),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Add comment FS'),
              onPressed: (){
                // dbController.addCommentToFirestore();
              },
            ),
          ),  Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Add reply Fs'),
              onPressed: (){
                // dbController.addReplyToFirestore();
              },
            ),
          ),  Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Get all data FS'),
              onPressed: (){
                // dbController.getDataFromFireStore();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Get commens FB'),
              onPressed: (){
                dbController.getCommentsData();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Get post FB'),
              onPressed: (){
                dbController.getPostData();
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Obx(()=> Text('${dbController.allPosts.length}',style: TextStyle(fontSize: 25),))

        ],
      ),

      // body: Obx(()=>
      //     dbController.isLoading.value?Center(child: CircularProgressIndicator(),):
      //     Center(child: Text('${dbController.allPosts[0]["80"]["likes"]["80-23"]["likeStatus"]}',style: TextStyle(fontSize: 30),))),
    );
  }
}
