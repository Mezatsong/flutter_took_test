import 'package:equatable/equatable.dart';
import 'package:took_test/model/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class InitPostState extends PostState {
  const InitPostState();
}

// Create Post
class LoadingCreatePost extends PostState {}

class SuccessCreatePost extends PostState {
  final Post post;
  const SuccessCreatePost(this.post);
}

class FailedCreatePost extends PostState {
  final String error;
  const FailedCreatePost(this.error);
}

// Delete Post
class LoadingDeletePost extends PostState {
  final int id;
  const LoadingDeletePost(this.id);}

class SuccessDeletePost extends PostState {
  final int id;
  const SuccessDeletePost(this.id);
}

class FailedDeletePost extends PostState {
  final String error;
  const FailedDeletePost(this.error);
}

// Get All Post
class LoadingAllPostList extends PostState {}

class SuccessAllPostList extends PostState {
  final List<Post> allPosts;
  const SuccessAllPostList(this.allPosts);
}

class FailedAllPostList extends PostState {
  final String error;
  const FailedAllPostList(this.error);
}
