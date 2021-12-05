import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:took_test/bloc/post/post_cubit.dart';
import 'package:took_test/bloc/post/post_state.dart';
import 'package:took_test/model/post.dart';
import 'package:took_test/widgets/user_avatar.dart';

class PostCard extends StatelessWidget {

  final Post post;

  const PostCard(this.post, {Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const UserAvatar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ben MEZATSONG',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: const [
                          Text(
                            'Public',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.public, size: 15, color: Colors.grey)
                        ]
                      )
                    ],
                  )
                ),
                
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: BlocBuilder<PostCubit, PostState>(
                    buildWhen: (previous, current) => (
                      (current is LoadingDeletePost && current.id == post.id) ||
                      (previous is LoadingDeletePost && previous.id == post.id)
                    ),
                    builder: (context, state) {
                      if (state is LoadingDeletePost && state.id == post.id) {
                        return const CircularProgressIndicator();
                      }
                      return IconButton(
                        onPressed: () => context.read<PostCubit>().deletePost(post.id!), 
                        icon: const Icon(Icons.delete_forever_outlined, size: 35)
                      );
                    }
                  )
                )
              ],
            )
          ),
          
          if (post.content != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              post.content ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            )
          ), 
          
          if (post.image != null)
          Image.file(File(post.image!), fit: BoxFit.fitWidth)
        ]
      )
    );
  }
}