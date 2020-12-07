import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  Future<void> addBlogs(Map blogData,String blogId) async{
    await Firestore.instance.collection('blogs').document(blogId).setData(blogData).catchError((e){
      print(e);
    });
  }

  getBlogData() async{
    await Firestore.instance.collection('blogs').snapshots();
  }

}