import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePreviewWidget extends StatefulWidget {
  const ImagePreviewWidget({Key? key}) : super(key: key);

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  final _storageRef = FirebaseStorage.instance.ref();
  List<String?> imgUrlList = [
  ];

  @override
  void initState() {
    getImages();
    super.initState();
  }

  getImages() async {
    List<String?> imageUrls = [];
    final imagesQuery = await _storageRef.child("images").listAll();
    print(imagesQuery.items.length);
    for(var item in imagesQuery.items){
      imageUrls.add(await item.getDownloadURL());
    }
    setState(() {
      imgUrlList = imageUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
            imgUrlList.length,
            (index) => Card(
                  elevation: 5,
                  child: Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            fit: BoxFit.cover,
                            image: NetworkImage(imgUrlList[index]!))),
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       "Image ${index + 1}",
                    //       style: const TextStyle(
                    //           color: Colors.white, fontSize: 16),
                    //     ),
                    //   ],
                    // ),
                  ),
                )),
      ),
    );
  }
}
