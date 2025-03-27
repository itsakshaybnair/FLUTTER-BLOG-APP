import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_blog_app/core/error/failures.dart';
import 'package:flutter_blog_app/core/usecase/usecase.dart';
import 'package:flutter_blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter_blog_app/features/blog/domain/repositories/blog_repository.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params)async {
return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterid: params.postedId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final String postedId;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.postedId,
    required this.topics,
  });
}
