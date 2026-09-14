import 'package:ballon/pagination/data/data_source/bussines_type_data_source.dart';
import 'package:ballon/pagination/data/data_source/event_data_source.dart';
import 'package:ballon/pagination/data/data_source/resturant_data_source.dart';
import 'package:ballon/pagination/data/data_source/resturants_reviews_data_source.dart';
import 'package:ballon/pagination/data/repo/bussinessrepo.dart';
import 'package:ballon/pagination/data/repo/distancerepo.dart';
import 'package:ballon/pagination/data/repo/eventrepo.dart';
import 'package:ballon/pagination/data/repo/reviewsrepo.dart';
import 'package:ballon/pagination/domain/base_repo/base_repo.dart';
import 'package:ballon/pagination/domain/usecase/use_case.dart';
import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../handle_error/network_info.dart';

final GetIt appServiceLocator = GetIt.instance;

class AppServiceLocator {
  static Future<void> initAppServiceLocator() async {
    appServiceLocator.registerFactory<PaginationBlocEvent>(
        () => PaginationBlocEvent(appServiceLocator()));

    appServiceLocator.registerLazySingleton<GetDataUseCaseEvent>(
        () => GetDataUseCaseEvent(baseRepo: appServiceLocator()));

    appServiceLocator.registerLazySingleton<BaseRepoEvent>(() => RepoEvent(
        networkInfo: appServiceLocator(), remoteData: appServiceLocator()));

    appServiceLocator.registerLazySingleton<RemoteDataEvent>(() => RemoteDataImplEvent());
// project
appServiceLocator.registerFactory<PaginationBlocReviews>(
        () => PaginationBlocReviews(appServiceLocator()));

    appServiceLocator.registerLazySingleton<GetDataUseCaseReviews>(
        () => GetDataUseCaseReviews(baseRepo: appServiceLocator()));

    appServiceLocator.registerLazySingleton<BaseRepoReviews>(() => RepoReviews(
        networkInfo: appServiceLocator(), remoteDataReviews: appServiceLocator()));

    appServiceLocator.registerLazySingleton<RemoteDataReviews>(() => RemoteDataImplReviews());
// project
appServiceLocator.registerFactory<PaginationBlocBusinessType>(
        () => PaginationBlocBusinessType(appServiceLocator()));

    appServiceLocator.registerLazySingleton<GetDataUseCaseBusinessType>(
        () => GetDataUseCaseBusinessType(baseRepo: appServiceLocator()));

    appServiceLocator.registerLazySingleton<BaseRepoBusinessType>(() => RepoBusinessType(
        networkInfo: appServiceLocator(), remoteDataBusinessType: appServiceLocator()));

    appServiceLocator.registerLazySingleton<RemoteDataBusinessType>(() => RemoteDataImplBusinessType());

// project
appServiceLocator.registerFactory<PaginationBlocDistance>(
        () => PaginationBlocDistance(appServiceLocator()));

    appServiceLocator.registerLazySingleton<GetDataUseCaseDistance>(
        () => GetDataUseCaseDistance(baseRepo: appServiceLocator()));

    appServiceLocator.registerLazySingleton<BaseRepoDistance>(() => RepoDistance(
        networkInfo: appServiceLocator(), remoteDataDistance: appServiceLocator()));

    appServiceLocator.registerLazySingleton<RemoteDataDistance>(() => RemoteDataImplDistance());

    // Network information
    appServiceLocator.registerLazySingleton(
        () => InternetConnectionChecker.createInstance());
    appServiceLocator.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(appServiceLocator()));

    // appServiceLocator.registerLazySingleton<NetworkInfo>(
    // () => NetworkInfoImpl(
    //     appServiceLocator.get<InternetConnectionChecker>()
    // )
// );
  }
}
