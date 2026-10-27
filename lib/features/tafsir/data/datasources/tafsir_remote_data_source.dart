import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';
import 'package:mishkat/features/tafsir/data/requests_params/editions_params.dart';
import 'package:mishkat/features/tafsir/data/requests_params/tafsir_params.dart';

// Fetches tafsir books and tafsir text from the API.
abstract class TafsirRemoteDataSource {
  // Returns the available Arabic tafsir books.
  Future<List<TafsirEditionModel>> getEditions(EditionsParams params);

  // Returns the tafsir of one ayah.
  Future<TafsirModel> getTafsir(TafsirParams params);
}

// API implementation of TafsirRemoteDataSource.
class TafsirRemoteDataSourceImp implements TafsirRemoteDataSource {
  final ApiConsumer _apiConsumer;

  // Creates the data source with the shared API consumer.
  TafsirRemoteDataSourceImp(this._apiConsumer);

  // Returns the available Arabic tafsir books.
  @override
  Future<List<TafsirEditionModel>> getEditions(EditionsParams params) async {
    final response = await _apiConsumer.get(EndPoints.editions, queryParameters: params.toJson());
    final data = response['data'] as List<dynamic>;
    return data.map((e) => TafsirEditionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Returns the tafsir of one ayah.
  @override
  Future<TafsirModel> getTafsir(TafsirParams params) async {
    final response = await _apiConsumer.get(EndPoints.ayah(params.reference, params.edition));
    return TafsirModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
