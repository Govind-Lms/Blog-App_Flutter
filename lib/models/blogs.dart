import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String blogId;
  final String title;
  final String desc;
  BlogModel(
      {this.blogId,
        this.title,
        this.desc,

      });

  factory BlogModel.fromDocument(doc) {
    return BlogModel(
        blogId: doc['blogId'],
        title: doc['title'],
        desc: doc['desc']
    );
  }
}
