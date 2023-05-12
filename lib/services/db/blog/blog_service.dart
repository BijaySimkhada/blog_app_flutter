import 'package:blog_application/models/blog/blog_model.dart';
import 'package:blog_application/widget/flutter_toast_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseBlogService {
  final databaseRef = FirebaseDatabase.instance.ref("blogs");

  postBlog(BlogModel blog) async {
    try {
      databaseRef
          .child('post')
          .push()
          .set(blog.toJson())
          .then((value) => flutterSuccessMessage("Blog posted successfully!"))
          .catchError((error) {
        flutterFailMessage("An error occurred: $error");
      });
    } on FirebaseException catch (e) {
      print('error => ${e.message}');
    }
  }

  getBlogList() async {
    try {
      List<BlogModel> blogList = [];
      DatabaseEvent data = await databaseRef.child('post').once();
      if (data.snapshot.exists) {
        for (DataSnapshot snapshot in data.snapshot.children) {
          Map<dynamic, dynamic>? data =
              snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            blogList.add(BlogModel(
                id: snapshot.key,
                title: data['title'],
                imgUrl: data['imgUrl'],
                writtenBy: data['author'],
                description: data['desc']));
          }
        }
      }
      return blogList;
    } on FirebaseException catch (e) {
      print('error => ${e.message}');
    }
  }

  getBlogDetail(String id) async {
    try {
      BlogModel blog = BlogModel();
      DataSnapshot snapshot = await databaseRef.child('post').child(id).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          blog = BlogModel(
              id: snapshot.key,
              title: data['title'],
              imgUrl: data['imgUrl'],
              writtenBy: data['author'],
              description: data['desc'],
              writter: data['writter']);
        }
      }
      return blog;
    } on FirebaseException catch (e) {
      print('error => ${e.message}');
    }
  }
}
