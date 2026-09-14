import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/models/resturants.dart';
import 'package:dartz/dartz.dart';

import '../../../core/handle_error/failure.dart';

abstract class BaseRepoBusinessType{
  Future<Either<Failure, List<Datum>>> getDataBusinessType({required int pageNumber, required int numberOfBusinessTypesPerRequest});
}
abstract class BaseRepoReviews{
  Future<Either<Failure, List<Result>>> getDataReviews({required int pageNumber, required int numberOfReviewsPerRequest});
}
abstract class BaseRepoDistance{
  Future<Either<Failure, List<Result>>> getDataDistance({required int pageNumber, required int numberOfDistancesPerRequest});
}
abstract class BaseRepoEvent{
  Future<Either<Failure, List<ResultEvent>>> getDataEvent({required int pageNumber, required int numberOfEventsPerRequest});
}