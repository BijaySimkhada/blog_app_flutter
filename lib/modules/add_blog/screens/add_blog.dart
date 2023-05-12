import 'dart:io';
import 'package:blog_application/models/blog/blog_model.dart';
import 'package:blog_application/services/db/blog/blog_service.dart';
import 'package:blog_application/services/image_picker/image_picker_service.dart';
import 'package:blog_application/widget/flutter_toast_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddBLogScreen extends StatefulWidget {
  const AddBLogScreen({Key? key}) : super(key: key);

  @override
  State<AddBLogScreen> createState() => _AddBLogScreenState();
}

class _AddBLogScreenState extends State<AddBLogScreen> {
  String? imgUrl;
  bool _isUploading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final FirebaseStorage _storageRef = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();

  Future<String?> uploadImageToFirebase(String imgPath) async {
    try {
      setState(() {
        _isUploading = true;
      });
      File file = File(imgPath);
      var uploadFile =
          await _storageRef.ref('post/${file.hashCode}').putFile(file);

      var downloadURL = await uploadFile.ref.getDownloadURL();
      setState(() {
        _isUploading = false;
      });
      if (downloadURL != null || downloadURL != '') {
        return downloadURL;
      }
      return null;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  _showModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select mode"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    String? path =
                        await ImagePickerService().getImageFromCamera();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                    if (path != null) {
                      String? downloadUrl = await uploadImageToFirebase(path);
                      setState(() {
                        imgUrl = downloadUrl;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    size: 45,
                    color: Colors.black54,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String? path =
                        await ImagePickerService().getImageFromGallery();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                    if (path != null) {
                      String? downloadUrl = await uploadImageToFirebase(path);
                      setState(() {
                        imgUrl = downloadUrl;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.image,
                    size: 45,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          );
        });
  }

  postBlog() async {
    if (imgUrl == null) {
      flutterWarningMessage("Upload a blog image");
    }
    if (_formKey.currentState!.validate() && imgUrl != null) {
      await FirebaseBlogService().postBlog(
        BlogModel(
            imgUrl: imgUrl,
            title: _titleController.value.text,
            description: _descController.value.text,
            writtenBy: FirebaseAuth.instance.currentUser!.uid,
            writter: FirebaseAuth.instance.currentUser!.displayName),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add blog",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    InkWell(
                      onTap: _showModal,
                      child: Stack(
                        children: [
                          Image.network(
                            imgUrl ??
                                "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png",
                            width: MediaQuery.of(context).size.width * 0.40,
                            fit: BoxFit.contain,
                            height: 150,
                          ),
                          Positioned(
                            top: 50,
                            left: 55,
                            child: Visibility(
                              visible: _isUploading,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: TextFormField(
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Enter title here';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("Title"),
                            hintText: "Enter your title here"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _descController,
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Enter description here';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 15,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Description"),
                    hintText: "Enter your description here"),
              ),
              SizedBox(
                child: ElevatedButton(
                    onPressed: postBlog,
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
