import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateProfilePictureUsecase {
  UserRepository repository;

  UpdateProfilePictureUsecase(this.repository);

  Future<Either<Failure, User>> call({
    required int employeeNumber,
    required String photo,
  }) {
    return repository.updateProfilePicture(employeeNumber: employeeNumber, photo: photo);
  }
}
