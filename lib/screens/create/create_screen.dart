import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:took_test/bloc/post/post_cubit.dart';
import 'package:took_test/bloc/post/post_state.dart';
import 'package:took_test/model/post.dart';
import 'package:took_test/widgets/user_avatar.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {

  final bool openGallery;

  const CreateScreen({Key? key, this.openGallery = false}) : super(key:key);

  @override 
  _State createState() => _State();
}

class _State extends State<CreateScreen> {
  
  String? _retrieveDataError;
  XFile? _imageFile;

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(textListener);
    if (widget.openGallery) {
      pickImage(ImageSource.gallery);
    }
  }

  void textListener() {
    // Refresh only when the UI will change
    // At 0, it will disable the submit button
    // At x > 0 it will enable the submit button
    if (_controller.text.length < 2) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(textListener);
    _controller.dispose();
    super.dispose();
  }

  onSubmit() {
    if (_controller.text.isEmpty && _imageFile == null) {
      return;
    }
    
    final post = Post();

    if (_controller.text.isNotEmpty) {
      post.content = _controller.text;
    }

    if (_imageFile != null) {
      post.image = _imageFile!.path;
    }

    BlocProvider.of<PostCubit>(context).createPost(post);
  }

  void pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: Image.file(File(_imageFile!.path)),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        title: const Text(
          'Create post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        /* actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              'PUBLISH',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold
              )
            ),
          )
        ], */
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is SuccessCreatePost) {
            Navigator.pop(context);
          } else if (state is FailedCreatePost) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent
              )
            );
          }
        },
        buildWhen: (previous, current) => (
          current is InitPostState ||
          current is LoadingCreatePost ||
          current is SuccessCreatePost ||
          current is FailedCreatePost
        ),
        builder: (context, state) {
          final _isLoading = (state is LoadingCreatePost);
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
                      )
                    ]
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  child: TextField(
                    minLines: 4,
                    maxLines: 4,
                    controller: _controller,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      hintText: 'What do you think ?',
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: InkWell(
                    onTap: () => _isLoading ? {} : pickImage(ImageSource.camera),
                    enableFeedback: !_isLoading,
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt_outlined, color: Colors.green, size: 20),
                        SizedBox(width: 10),
                        Text(
                        'Take a photo from your camera',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          )
                        )
                      ]
                    )
                  )
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: InkWell(
                    onTap: () => _isLoading ? {} : pickImage(ImageSource.gallery),
                    enableFeedback: !_isLoading,
                    child: Row(
                      children: const [
                        Icon(Icons.photo_library_outlined, color: Colors.orange, size: 20),
                        SizedBox(width: 10),
                        Text(
                        'Choose a photo from gallery',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          )
                        )
                      ]
                    )
                  )
                ),
                const SizedBox(height: 10),
                if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: InkWell(
                    onTap: () => _isLoading ? {} : setState(() => _imageFile = null),
                    enableFeedback: !_isLoading,
                    child: Row(
                      children: const [
                        Icon(Icons.delete_forever_outlined, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text(
                        'Remove current image',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          )
                        )
                      ]
                    )
                  )
                ),
                if (_imageFile != null)
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Platform.isAndroid ? FutureBuilder<void>(
                      future: retrieveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Text(
                              'You have not yet picked an image.',
                              textAlign: TextAlign.center,
                            );
                          case ConnectionState.done:
                            return _previewImage();
                          default:
                            if (snapshot.hasError) {
                              return Text(
                                'Pick image/video error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const Text(
                                'You have not yet picked an image.',
                                textAlign: TextAlign.center,
                              );
                            }
                        }
                      },
                    ) : _previewImage(),
                  )
                ),
                InkWell(
                  onTap: () {
                    if (!_isLoading && (_controller.text.isNotEmpty || _imageFile != null)) {
                      onSubmit();
                    }
                  },
                  enableFeedback: (!_isLoading || _controller.text.isNotEmpty || _imageFile != null),
                  child: Container(
                    alignment: Alignment.center,
                    color: (_controller.text.isNotEmpty || _imageFile != null) 
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 10), 
                    child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('PUBLISH',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          )
                        )
                  )
                )
              ]
            )
          );
        }
      )
    );
  }
  
}
