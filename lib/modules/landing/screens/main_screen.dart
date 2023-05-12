import 'package:blog_application/modules/landing/screens/widgets/image_preview.dart';
import 'package:blog_application/modules/landing/screens/widgets/list_view_blog.dart';
import 'package:blog_application/services/db/auth/firebase_auth.dart';
import 'package:blog_application/widget/flutter_toast_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, ${user!.displayName}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(onPressed: () async {
            flutterSuccessMessage("User logged out");
            await FirebaseAuthService().logoutUser();
          }, icon: const Icon(Icons.logout_rounded))
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Image Slider here
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: const ImagePreviewWidget(),
            ),
            const Divider(),
            const Text("Recent Blogs",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            //  List View here
            Container(
              height: MediaQuery.of(context).size.height * 0.57,
              padding: const EdgeInsets.only(right: 10),
              child: const ListViewBlog(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=> Navigator.pushNamed(context, '/add_blog'),
        label: const Text(
          "Add blog",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
