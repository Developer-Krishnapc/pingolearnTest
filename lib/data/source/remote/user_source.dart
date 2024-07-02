import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/exceptions/app_exception.dart';
import '../../../core/providers/firestore_provider.dart';
import '../../../domain/model/user.dart';

part 'user_source.g.dart';

@riverpod
UserSource userSource(UserSourceRef ref) =>
// ignore: avoid_manual_providers_as_generated_provider_dependency
    UserSource(db: ref.read(firestoredbProvider));

class UserSource {
  UserSource({required this.db});
  final FirebaseFirestore db;

  Future<Either<AppException, User>> getUserByEmail(
      {required String email}) async {
    try {
      final data = await db.collection(EntityType.user).doc(email).get();
      if (data.exists && data.data() != null) {
        return right(User.fromJson(data.data() ?? {}).copyWith(email: email));
      } else {
        return Left(AppException(
            type: ErrorType.firebaseError, message: 'No user found'));
      }
    } on FirebaseException catch (e) {
      return Left(AppException(message: e.code, type: ErrorType.firebaseError));
    } catch (e) {
      return Left(
          AppException(message: 'Something went wrong', type: ErrorType.other));
    }
  }
}
