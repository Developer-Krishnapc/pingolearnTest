import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';

abstract class PrinterRepository {
  Future<Either<AppException, CommonSuccessModel>> printLabel({
    required String printerName,
    required String zplCommand,
  });

  Future<Either<AppException, CommonSuccessModel>> dummy();
}
