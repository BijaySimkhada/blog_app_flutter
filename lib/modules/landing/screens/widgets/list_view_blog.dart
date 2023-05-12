import 'package:blog_application/models/blog/blog_model.dart';
import 'package:blog_application/modules/landing/screens/blog_detail.dart';
import 'package:blog_application/services/db/blog/blog_service.dart';
import 'package:flutter/material.dart';

class ListViewBlog extends StatefulWidget {
  const ListViewBlog({Key? key}) : super(key: key);

  @override
  State<ListViewBlog> createState() => _ListViewBlogState();
}

class _ListViewBlogState extends State<ListViewBlog> {
  List<BlogModel> blogList = [];

  @override
  void initState() {
    getBlogList();
    super.initState();
  }

  getBlogList() async {
    blogList = await FirebaseBlogService().getBlogList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: blogList.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("${blogList[index].title}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BlogDetails(id: blogList[index].id!)));
              },
              leading: Image.network("${blogList[index].imgUrl}"),
              subtitle: Text("${blogList[index].description}"),
            ),
          );
        });
  }
}
