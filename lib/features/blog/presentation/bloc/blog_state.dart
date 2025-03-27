part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogUploadSuccess extends BlogState {
  BlogUploadSuccess();
}

final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);
}

final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  BlogsDisplaySuccess(this.blogs);
}

class User {
  String? name; 

  User(String userName) { 
    name = userName; // ✅ Works, but not as clean
  }
}

final a=User("kkk");