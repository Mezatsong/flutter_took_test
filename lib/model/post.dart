const _columnId = '_id';
const _columnImage = 'image';
const _columnContent = 'content';

class Post {
  int? id;
  String? image;
  String? content;

  Post({
    this.id,
    this.image,
    this.content
  });

  Map<String, dynamic> toMap() {
    var map = <String, Object?>{
      _columnImage: image,
      _columnContent: content
    };
    if (id != null) {
      map[_columnId] = id;
    }
    return map;
  }

  Post.fromMap(Map<String, Object?> map) {
    id = map[_columnId] as int;
    content = map[_columnContent] as String;
    image = map[_columnImage] as String;
  }
}
