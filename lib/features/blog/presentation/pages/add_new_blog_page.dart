import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_blog_app/core/common/widgets/loader.dart';
import 'package:flutter_blog_app/core/constants/constants.dart';
import 'package:flutter_blog_app/core/theme/app_palette.dart';
import 'package:flutter_blog_app/core/utils/pick_image.dart';
import 'package:flutter_blog_app/core/utils/show_snackbar.dart';
import 'package:flutter_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_blog_app/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogpage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogpage(),
      );

  const AddNewBlogpage({super.key});

  @override
  State<AddNewBlogpage> createState() => _AddNewBlogpageState();
}

class _AddNewBlogpageState extends State<AddNewBlogpage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
            BlogUpload(
              image: image!,
              title: titleController.text,
              content: contentController.text,
              postedId: posterId,
              topics: selectedTopics,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Blog App'),
        actions: [
          IconButton(
              onPressed: () {
                uploadBlog();
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          } else if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
         return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image == null
                        ? GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              color: AppPallete.borderColor,
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: Constants.topics
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (selectedTopics.contains(e)) {
                                            selectedTopics.remove(e);
                                          } else {
                                            selectedTopics.add(e);
                                          }
                                          setState(() {});
                                        },
                                        child: Chip(
                                          color: selectedTopics.contains(e)
                                              ? const WidgetStatePropertyAll(
                                                  AppPallete.gradient1)
                                              : null,
                                          side: selectedTopics.contains(e)
                                              ? null
                                              : const BorderSide(
                                                  color: AppPallete.borderColor,
                                                ),
                                          label: Text(e),
                                        ),
                                      ),
                                    ))
                                .toList())),
                    const SizedBox(
                      height: 20,
                    ),
                    BlogEditor(
                        controller: titleController, hintText: 'Blog Title'),
                    const SizedBox(
                      height: 20,
                    ),
                    BlogEditor(
                        controller: contentController,
                        hintText: 'Blog Content'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
