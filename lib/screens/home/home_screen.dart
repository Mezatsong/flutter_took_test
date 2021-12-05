import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:took_test/bloc/post/post_cubit.dart';
import 'package:took_test/bloc/post/post_state.dart';
import 'package:took_test/model/post.dart';
import 'package:took_test/widgets/new_post_header.dart';
import 'package:took_test/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}
  

class _State extends State<HomeScreen> {

  buildInitState() => const Center(child: CircularProgressIndicator());

  buildLoadingState() => Column(
    children: const [
      NewPostHeader(),
      Center(child: CircularProgressIndicator())
    ]
  );

  buildFailedState(String error) => Column(
    children: [
      const NewPostHeader(),
      Center(child: Text(error))
    ]
  );

  buildSuccessState(List<Post> allPosts) => ListView.builder(
    itemCount: allPosts.length + 1,
    itemBuilder: (c, i) {
      if (i == 0) {
        return const NewPostHeader();
      }
      return PostCard(allPosts[i-1]);
    }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Took test',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
          ),
        ),
        /*actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade200
            ),
            child: IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.search, color: Colors.grey, size: 30)
            )
          )
        ],*/
        centerTitle: false,
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is SuccessDeletePost) {
            context.read<PostCubit>().getAllPostList();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Post deleted successfuly !"),
                backgroundColor: Colors.green
              )
            );
          } else if (state is FailedDeletePost) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent
              )
            );
          } else if (state is SuccessCreatePost) {
            context.read<PostCubit>().getAllPostList();
          }
        },
        buildWhen: (previous, current) => (
          current is InitPostState ||
          current is LoadingAllPostList ||
          current is SuccessAllPostList ||
          current is FailedDeletePost ||
          current is FailedAllPostList
        ),
        builder: (context, state) {
          if (state is InitPostState) {
            context.read<PostCubit>().getAllPostList();
          } else if (state is LoadingAllPostList) {
            return buildLoadingState();
          } else if (state is SuccessAllPostList) {
            return buildSuccessState(state.allPosts);
          } else if (state is FailedAllPostList) {
            return buildFailedState(state.error);
          }
          return buildInitState();
        }
      )
    );
  }
  
}