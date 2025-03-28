import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_blog_app/core/constants/constants.dart';
import 'package:flutter_blog_app/core/error/exceptions.dart';
import 'package:flutter_blog_app/core/error/failures.dart';
import 'package:flutter_blog_app/core/network/connection_checker.dart';
import 'package:flutter_blog_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:flutter_blog_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:flutter_blog_app/features/blog/data/models/blog_models.dart';
import 'package:flutter_blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter_blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterid,
    required List<String> topics,
  }) async {
    try {

 if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }


      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          title: title,
          content: content,
          posterId: posterid,
          topics: topics,
          imageUrl: '',
          updatedAt: DateTime.now());

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlogs(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
       if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }

      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
