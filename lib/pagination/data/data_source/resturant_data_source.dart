import 'dart:convert';
import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:http/http.dart';
import 'package:ballon/services/geolocation.dart';
import 'package:geolocator/geolocator.dart';

abstract class RemoteDataDistance {
  Future<List<Result>?> getDataDistance(
      {required int pageNumber, required int numberOfDistancesPerRequest});
}

class RemoteDataImplDistance extends RemoteDataDistance {
  @override
  Future<List<Result>> getDataDistance({
  required int pageNumber, 
  required int numberOfDistancesPerRequest
}) async {
  try {
    // Get location
    LocationService locationService = LocationService();
    Position currentPosition = await locationService.getCurrentLocation();
    
    // Build URL with dynamic latitude and longitude
    String url = "${Urls.baseUrl}/prof/restaurants-high-rated/"
        "?lat=${currentPosition.latitude}"
        "&lon=${currentPosition.longitude}"
        "&sort_by=distance"
        "&page=$pageNumber";
    
    final response = await get(Uri.parse(url));
    
    var map = jsonDecode(utf8.decode(response.bodyBytes));
    print(url);
    return Resturants.fromJson(map).data!.results!;
    
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
  // Future<List<Result>> getDataDistancex(
  //     {required int pageNumber, required int numberOfDistancesPerRequest}) async {
  //   final response = await get(Uri.parse(
  //       "${Urls.baseUrl}/prof/restaurants-distance/?page=$pageNumber"));

  //   try {
  //      var map = jsonDecode(utf8.decode(response.bodyBytes));
  //      print(map);
  //       return Resturants.fromJson(map).data!.results!;

  //     // List responseList = json.decode(response.body);
  //     // List<Result> postList =  responseList
  //     //     .map((data) => Result.fromJson(data))
  //     //     .toList();
  //     //   //   List<Activity> emplist = await resultsJson
  //     //   // .map<Activity>((json) => Activity.fromJson(json))
  //     //   // .toList();
  //     //   print(postList);
  //     // return postList;
  //   } catch (e) {
  //     throw ServerException(message: e.toString());
  //   }
  // }

  final int limit = 10;
  // final baseUrl = "https://panel.supplyline.network/api";

  // Future<List<Result>?> fetchProducts(int offset, String slug) async {
  //   try {
  //     final response = await get(
  //         Uri.parse(
  //             "$baseUrl/product/search-suggestions?limit=$limit&offset=$offset&search=$slug"),
  //         headers: {'Content-Type': 'application/json'});
  //     if (response.statusCode == 200) {
  //       var map = jsonDecode(utf8.decode(response.bodyBytes));
  //       return ProductModel.fromJson(map).results;
  //     }
  //   } catch (err) {
  //     return [];
  //   }
  //     return [];
  // }
}
