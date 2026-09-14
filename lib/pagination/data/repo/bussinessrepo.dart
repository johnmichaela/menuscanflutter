import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/core/handle_error/failure.dart';
import 'package:ballon/core/handle_error/network_info.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/pagination/data/data_source/bussines_type_data_source.dart';
import 'package:ballon/pagination/domain/base_repo/base_repo.dart';
import 'package:dartz/dartz.dart';

class RepoBusinessType extends BaseRepoBusinessType {
  final RemoteDataBusinessType remoteDataBusinessType;
  final NetworkInfo networkInfo;
  RepoBusinessType({required this.remoteDataBusinessType,required this.networkInfo});

  @override
  Future<Either<Failure, List<Datum>>> getDataBusinessType(
      {required int pageNumber, required int numberOfBusinessTypesPerRequest}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataBusinessType.getDataBusinessType(
            numberOfBusinessTypesPerRequest: numberOfBusinessTypesPerRequest,
            pageNumber: pageNumber);
        return Right(result!);
      } on ServerException catch (failure) {
        return left(ServerFailure(message: failure.message.toString()));
      }
    } else {
      return left(const ServerFailure(message: 'No Internet Connection'));
    }
  }


  
}


