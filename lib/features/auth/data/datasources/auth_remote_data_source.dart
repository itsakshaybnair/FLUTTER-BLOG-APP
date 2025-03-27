// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_blog_app/core/error/exceptions.dart';
import 'package:flutter_blog_app/features/auth/data/models/user_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(
    this.supabaseClient,
  );

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw (ServerException('User is Null'));
      }
      return UserModel.fromJson(response.user!.toJson());
    }  on AuthException catch (e) {
      log(e.message);
      throw (ServerException(e.message));
    }catch (e) {
      throw (ServerException(e.toString()));
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});

      if (response.user == null) {
        throw (ServerException('User is Null'));
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      log(e.message);
      throw (ServerException(e.message));
    } catch (e) {
      throw (ServerException(e.toString()));
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
