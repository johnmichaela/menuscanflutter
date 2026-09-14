import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/models/resturants.dart';
import 'package:dartz/dartz.dart';

import '../../../core/handle_error/failure.dart';
import '../base_repo/base_repo.dart';

class GetDataUseCaseEvent {
  final BaseRepoEvent baseRepo;

  GetDataUseCaseEvent({required this.baseRepo});

  Future<Either<Failure, List<ResultEvent>>> call(
      {required int pageNumber, required int numberOfEventsPerRequest}) async {
    return await baseRepo.getDataEvent(
        numberOfEventsPerRequest: numberOfEventsPerRequest,
        pageNumber: pageNumber);
  }
}



class GetDataUseCaseReviews {
  final BaseRepoReviews baseRepo;

  GetDataUseCaseReviews({required this.baseRepo});

  Future<Either<Failure, List<Result>>> call(
      {required int pageNumber, required int numberOfReviewsPerRequest}) async {
    return await baseRepo.getDataReviews(
        numberOfReviewsPerRequest: numberOfReviewsPerRequest,
        pageNumber: pageNumber);
  }
}

class GetDataUseCaseDistance {
  final BaseRepoDistance baseRepo;

  GetDataUseCaseDistance({required this.baseRepo});

  Future<Either<Failure, List<Result>>> call(
      {required int pageNumber, required int numberOfDistancePerRequest}) async {
    return await baseRepo.getDataDistance(
        numberOfDistancesPerRequest: numberOfDistancePerRequest,
        pageNumber: pageNumber);
  }
}
class GetDataUseCaseBusinessType {
  final BaseRepoBusinessType baseRepo;

  GetDataUseCaseBusinessType({required this.baseRepo});

  Future<Either<Failure, List<Datum>>> call(
      {required int pageNumber, required int numberOfBusinessTypePerRequest}) async {
    return await baseRepo.getDataBusinessType(
        numberOfBusinessTypesPerRequest: numberOfBusinessTypePerRequest,
        pageNumber: pageNumber);
  }
}
