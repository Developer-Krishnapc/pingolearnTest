import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../core/extension/log.dart';
import '../../domain/repository/printer_repo.dart';
import '../model/common_success_model.dart';
import '../source/remote/printer_source.dart';

part 'printer_repo_impl.g.dart';

@riverpod
PrinterRepository printerRepo(PrinterRepoRef ref, String baseUrl) =>
// ignore: avoid_manual_providers_as_generated_provider_dependency
    PrinterRepositoryImpl(ref.watch(printerSourceProvider(baseUrl)));

class PrinterRepositoryImpl implements PrinterRepository {
  PrinterRepositoryImpl(this._source);

  final PrinterSource _source;

  @override
  Future<Either<AppException, CommonSuccessModel>> printLabel({
    required String printerName,
    required String zplCommand,
  }) {
    final body = {
      'printerName': printerName,
      'command': zplCommand,
    };
    jsonEncode(body).logError();
    print(jsonEncode(body));
    return _source.printLabel(body).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> dummy() {
    return _source.dummy().guardFuture();
  }
}
