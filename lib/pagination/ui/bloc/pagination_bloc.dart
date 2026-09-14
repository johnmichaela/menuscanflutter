import 'package:ballon/core/handle_error/failure.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBlocEvent extends Bloc<PaginationEvent, PaginationState> {
  final GetDataUseCaseEvent getDataUseCase;

  bool isLastPage = false;
  int pageNumber = 1;
  final int numberOfEventsPerRequest = 5;
  List<ResultEvent> posts = [];
  final int nextPageTrigger = 3;

  PaginationBlocEvent(this.getDataUseCase) : super(PaginationInitialState()) {
    on<LoadPageEvent>((event, emit) async {
      emit(PaginationLoadingState());
      try {
        final Either<Failure, List<ResultEvent>> result = (await getDataUseCase(
          numberOfEventsPerRequest: numberOfEventsPerRequest,
          pageNumber: pageNumber,
        ));
        result.fold((l) {
          print("error --> $l");
          emit(PaginationErrorState());
        }, (postList) {
          isLastPage = postList.length < numberOfEventsPerRequest;
          pageNumber = pageNumber + 1;
          posts.addAll(postList);
          print('DDDDDDDDDDDDDD');
          emit(PaginationLoadedState());
        });
      } catch (e) {
        print("error --> $e");
        emit(PaginationErrorState());
      }
    });
    on<CheckIfNeedMoreDataEvent>((event, emit) async {
      emit(PaginationLoadingState());
      if (event.index == posts.length - nextPageTrigger) {
        add(const LoadPageEvent());
      }
    });
  }
}

class PaginationBlocReviews extends Bloc<PaginationEvent, PaginationState> {
  final GetDataUseCaseReviews getDataUseCase;

  bool isLastPage = false;
  int pageNumber = 1;
  final int numberOfReviewsPerRequest = 5;
  List<Result> posts = [];
  final int nextPageTrigger = 3;

  PaginationBlocReviews(this.getDataUseCase) : super(PaginationInitialState()) {
    on<LoadPageEvent>((event, emit) async {
      emit(PaginationLoadingState());
      try {
        final Either<Failure, List<Result>> result = (await getDataUseCase(
          numberOfReviewsPerRequest: numberOfReviewsPerRequest,
          pageNumber: pageNumber,
        ));
        result.fold((l) {
          print("error --> $l");
          emit(PaginationErrorState());
        }, (postList) {
          isLastPage = postList.length < numberOfReviewsPerRequest;
          pageNumber = pageNumber + 1;
          posts.addAll(postList);
          print('DDDDDDDDDDDDDD');
          emit(PaginationLoadedState());
        });
      } catch (e) {
        print("error --> $e");
        emit(PaginationErrorState());
      }
    });
    on<CheckIfNeedMoreDataEvent>((event, emit) async {
      emit(PaginationLoadingState());
      if (event.index == posts.length - nextPageTrigger) {
        add(const LoadPageEvent());
      }
    });
  }
}


class PaginationBlocDistance extends Bloc<PaginationEvent, PaginationState> {
  final GetDataUseCaseDistance getDataUseCase;

  bool isLastPage = false;
  int pageNumber = 1;
  final int numberOfDistancePerRequest = 5;
  List<Result> posts = [];
  final int nextPageTrigger = 3;

  PaginationBlocDistance(this.getDataUseCase) : super(PaginationInitialState()) {
    on<LoadPageEvent>((event, emit) async {
      emit(PaginationLoadingState());
      try {
        final Either<Failure, List<Result>> result = (await getDataUseCase(
          numberOfDistancePerRequest: numberOfDistancePerRequest,
          pageNumber: pageNumber,
        ));
        result.fold((l) {
          print("error --> $l");
          emit(PaginationErrorState());
        }, (postList) {
          isLastPage = postList.length < numberOfDistancePerRequest;
          pageNumber = pageNumber + 1;
          posts.addAll(postList);
          print('DDDDDDDDDDDDDD');
          emit(PaginationLoadedState());
        });
      } catch (e) {
        print("error --> $e");
        emit(PaginationErrorState());
      }
    });
    on<CheckIfNeedMoreDataEvent>((event, emit) async {
      emit(PaginationLoadingState());
      if (event.index == posts.length - nextPageTrigger) {
        add(const LoadPageEvent());
      }
    });
  }
}


class PaginationBlocBusinessType extends Bloc<PaginationEvent, PaginationState> {
  final GetDataUseCaseBusinessType getDataUseCase;

  bool isLastPage = false;
  int pageNumber = 1;
  final int numberOfBusinessTypePerRequest = 5;
  List<Datum> posts = [];
  final int nextPageTrigger = 3;

  PaginationBlocBusinessType(this.getDataUseCase) : super(PaginationInitialState()) {
    on<LoadPageEvent>((event, emit) async {
      emit(PaginationLoadingState());
      try {
        final Either<Failure, List<Datum>> result = (await getDataUseCase(
          numberOfBusinessTypePerRequest: numberOfBusinessTypePerRequest,
          pageNumber: pageNumber,
        ));
        result.fold((l) {
          print("error --> $l");
          emit(PaginationErrorState());
        }, (postList) {
          isLastPage = postList.length < numberOfBusinessTypePerRequest;
          pageNumber = pageNumber + 1;
          posts.addAll(postList);
          print('DDDDDDDDDDDDDD');
          emit(PaginationLoadedState());
        });
      } catch (e) {
        print("error --> $e");
        emit(PaginationErrorState());
      }
    });
    on<CheckIfNeedMoreDataEvent>((event, emit) async {
      emit(PaginationLoadingState());
      if (event.index == posts.length - nextPageTrigger) {
        add(const LoadPageEvent());
      }
    });
  }
}