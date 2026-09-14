import 'dart:convert';

import 'package:ballon/core/handle_error/execptions.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:http/http.dart';




abstract class RemoteDataBusinessType {
  Future<List<Datum>?> getDataBusinessType(
      {required int pageNumber, required int numberOfBusinessTypesPerRequest});
}

class RemoteDataImplBusinessType extends RemoteDataBusinessType{
  @override
  Future<List<Datum>> getDataBusinessType(
      {required int pageNumber, required int numberOfBusinessTypesPerRequest}) async {
    final response = await get(Uri.parse(
        "${Urls.baseUrl}/prof/business-types/?page=$pageNumber"));

    try {
       var map = jsonDecode(utf8.decode(response.bodyBytes));
       print(map);
        return Bussinestype.fromJson(map).data!;

      // List responseList = json.decode(response.body);
      // List<Result> postList =  responseList
      //     .map((data) => Result.fromJson(data))
      //     .toList();
      //   //   List<Activity> emplist = await resultsJson
      //   // .map<Activity>((json) => Activity.fromJson(json))
      //   // .toList();
      //   print(postList);
      // return postList;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

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
