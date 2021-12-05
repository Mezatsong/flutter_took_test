
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:took_test/bloc/post/post_state.dart';
import 'package:took_test/model/post.dart';
import 'package:took_test/repository/post_repository.dart';

class PostCubit extends Cubit<PostState> {

  final PostRepository _postRepository;

  PostCubit(this._postRepository) : super(const InitPostState());

  Future<void> createPost(Post post) async {
    emit(LoadingCreatePost());
    try {
      Post newPost = await _postRepository.insert(post);
      emit(SuccessCreatePost(newPost));
    } catch (_) {
      emit(const FailedCreatePost("Unable to create post"));
    }
  }

  Future<void> deletePost(int id) async {
    emit(LoadingDeletePost(id));
    try {
      await _postRepository.delete(id);
      emit(SuccessDeletePost(id));
    } catch (_) {
      emit(const FailedDeletePost("Unable to delete post"));
    }
  }

  Future<void> getAllPostList() async {
    emit(LoadingAllPostList());
    try {
      List<Post> allPosts = await _postRepository.all();
      emit(SuccessAllPostList(allPosts));
    } catch (_) {
      emit(const FailedAllPostList("Error while loading posts"));
    }
  }

}
