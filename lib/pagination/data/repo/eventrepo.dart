import 'package:ballon/core/handle_error/failure.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/pagination/data/data_source/event_data_source.dart';
import 'package:ballon/pagination/domain/base_repo/base_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../core/handle_error/execptions.dart';
import '../../../core/handle_error/network_info.dart';

class RepoEvent extends BaseRepoEvent {
  final RemoteDataEvent remoteData;
  final NetworkInfo networkInfo;
  RepoEvent({required this.remoteData,required this.networkInfo});

  @override
  Future<Either<Failure, List<ResultEvent>>> getDataEvent(
      {required int pageNumber, required int numberOfEventsPerRequest}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteData.getDataEvent(
            numberOfEventsPerRequest: numberOfEventsPerRequest,
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


