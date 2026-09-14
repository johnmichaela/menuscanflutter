import 'package:ballon/core/handle_error/failure.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/resturants_reviews_data_source.dart';
import 'package:ballon/pagination/domain/base_repo/base_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../core/handle_error/execptions.dart';
import '../../../core/handle_error/network_info.dart';

class RepoReviews extends BaseRepoReviews {
  final RemoteDataReviews remoteDataReviews;
  final NetworkInfo networkInfo;
  RepoReviews({required this.remoteDataReviews,required this.networkInfo});

  @override
  Future<Either<Failure, List<Result>>> getDataReviews(
      {required int pageNumber, required int numberOfReviewsPerRequest}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataReviews.getDataReviews(
            numberOfReviewsPerRequest: numberOfReviewsPerRequest,
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


