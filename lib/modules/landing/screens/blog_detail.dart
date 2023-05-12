import 'package:blog_application/models/blog/blog_model.dart';
import 'package:blog_application/services/db/blog/blog_service.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

class BlogDetails extends StatefulWidget {
  String id;
  BlogDetails({required this.id, Key? key}) : super(key: key);

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  BlogModel blog = BlogModel();
  bool isLoading = true;

  @override
  void initState() {
    getBlogDetail();
    super.initState();
  }

  getBlogDetail() async {
    blog = await FirebaseBlogService().getBlogDetail(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : DraggableHome(
            title: Text(blog.title!),
            headerWidget: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: const ColorFilter.mode(
                          Colors.black45, BlendMode.multiply),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        blog.imgUrl!,
                      ))),
              child: Center(
                child: Text(
                  blog.title!,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            body: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.justify,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      blog.description!,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.justify,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "- ${blog.writter!}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
