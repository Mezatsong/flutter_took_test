import 'package:sqflite/sqflite.dart';
import 'package:took_test/model/post.dart';

const _tablePost = 'posts';
const _columnId = '_id';
const _columnImage = 'image';
const _columnContent = 'content';

class PostRepository {

  late Database db;

  PostRepository(this.db);

  Future<Post> insert(Post post) async {
    post.id = await db.insert(_tablePost, post.toMap());
    return post;
  }

  
  Future<List<Post>> all() async {
    List<Map<String, dynamic>> maps = await db.query(_tablePost);
    return List.generate(
      maps.length, 
      (i) => Post(
        id: maps[i][_columnId],
        image: maps[i][_columnImage],
        content: maps[i][_columnContent]
      )
    );
  }
  

  Future<Post?> find(int id) async {
    List<Map<String, Object?>> maps = await db.query(_tablePost,
      columns: [_columnId, _columnContent, _columnImage],
      where: '$_columnId = ?',
      whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Post.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(_tablePost, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Post post) async {
    return await db.update(_tablePost, post.toMap(),
      where: '$_columnId = ?', 
      whereArgs: [post.id]
    );
  }

}
