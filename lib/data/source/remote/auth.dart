import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/exceptions/app_exception.dart';
import '../../../core/providers/firestore_provider.dart';
import '../../../domain/model/user.dart' as usr;
import '../../../presentation/auth/providers/firebase_instance_provider.dart';

part 'auth.g.dart';

@riverpod
AuthSource authSource(AuthSourceRef ref) => AuthSource(
// ignore: avoid_manual_providers_as_generated_provider_dependency
    auth: ref.read(firebaseAuthInstanceProvider),
// ignore: avoid_manual_providers_as_generated_provider_dependency
    db: ref.read(firestoredbProvider));

class AuthSource {
  AuthSource({required this.db, required this.auth});
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  Future<Either<AppException, String>> registerUser(
      {required usr.User userData}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: userData.email.toLowerCase().trim(),
          password: userData.password.trim());
      final userDocRef = db.collection(EntityType.user).doc(userData.email);
      final data = await userDocRef.get();

      await userDocRef.set(userData.toJson()..remove('email'));
      return right('User registered successfully');
    } on FirebaseException catch (e) {
      return Left(AppException(message: e.code, type: ErrorType.firebaseError));
    } catch (e) {
      return Left(
          AppException(message: 'Something went wrong', type: ErrorType.other));
    }
  }

  Future<Either<AppException, String>> loginUser(
      {required usr.User userData}) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userData.email.toLowerCase().trim(),
          password: userData.password.trim());
      return right('Login successfull...');
    } on FirebaseException catch (e) {
      return Left(AppException(message: e.code, type: ErrorType.firebaseError));
    } catch (e) {
      return Left(
          AppException(message: 'Something went wrong', type: ErrorType.other));
    }
  }
}
