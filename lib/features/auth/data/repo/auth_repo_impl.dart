import 'package:dartz/dartz.dart';
import 'package:hiracosmetics/core/handlers/error-handler/error_handler.dart';
import 'package:hiracosmetics/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repo.dart';
import '../data-source/auth_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource;

  AuthRepoImpl({required this.authDataSource});
  @override
  Future<Either<String, User>> getSignedInUser() async {
    try {
      final user = await authDataSource.getSignedInUser();
      return Right(user);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

  @override
  Future<Either<String, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await authDataSource.signInWithEmailAndPassword(email, password);
      final fetchedUser = await authDataSource.getSignedInUser();
      return Right(fetchedUser);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

  @override
  Future<Either<String, Unit>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(unit);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

  @override
  Future<Either<String, User>> signUp(User user) async {
    try {
      await authDataSource.signUp(user);
      final fetchedUser = await authDataSource.getSignedInUser();
      return Right(fetchedUser);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }
}
