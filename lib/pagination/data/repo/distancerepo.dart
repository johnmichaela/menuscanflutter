import 'package:ballon/core/handle_error/failure.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/event_data_source.dart';
import 'package:ballon/pagination/data/data_source/resturant_data_source.dart';
import 'package:ballon/pagination/domain/base_repo/base_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../core/handle_error/execptions.dart';
import '../../../core/handle_error/network_info.dart';

class RepoDistance extends BaseRepoDistance {
  final RemoteDataDistance remoteDataDistance;
  final NetworkInfo networkInfo;
  RepoDistance({required this.remoteDataDistance,required this.networkInfo});

  @override
  Future<Either<Failure, List<Result>>> getDataDistance(
      {required int pageNumber, required int numberOfDistancesPerRequest}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataDistance.getDataDistance(
            numberOfDistancesPerRequest: numberOfDistancesPerRequest,
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


