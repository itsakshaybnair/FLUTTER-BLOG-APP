import 'package:fpdart/fpdart.dart';
import 'package:flutter_blog_app/core/error/failures.dart';
import 'package:flutter_blog_app/core/usecase/usecase.dart';
import 'package:flutter_blog_app/core/common/entity/user.dart';
import 'package:flutter_blog_app/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(params) async {
    return authRepository.currentUser();
  }
}
