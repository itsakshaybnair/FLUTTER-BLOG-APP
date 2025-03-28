import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_blog_app/core/error/failures.dart';
import 'package:flutter_blog_app/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterid,
    required List<String> topics
  });

   Future<Either<Failure, List<Blog>>> getAllBlogs();
}
