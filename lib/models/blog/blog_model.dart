class BlogModel {
  String? id;
  String? imgUrl;
  String? title;
  String? description;
  String? writtenBy;
  String? writter;

  BlogModel(
      {this.id, this.imgUrl, this.title, this.description, this.writtenBy, this.writter});

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'title': title,
        'desc': description,
        'author': writtenBy,
        'writter': writter
      };
}
