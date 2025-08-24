import 'package:dartz/dartz.dart';
import 'package:hiracosmetics/features/auth/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/data-source/auth_data_source.dart';
import '../../data/repo/auth_repo_impl.dart';
part 'auth_repo.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepository(Ref ref) {
  return AuthRepoImpl(authDataSource: ref.read(authDataSourceProvider));
}

abstract class AuthRepo {
  Future<Either<String, User>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<String, User>> signUp(User user);
  Future<Either<String, Unit>> signOut();
  Future<Either<String, User>> getSignedInUser();
}
