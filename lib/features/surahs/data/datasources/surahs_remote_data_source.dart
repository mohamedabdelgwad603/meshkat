import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// Fetches surah metadata from the API.
abstract class SurahsRemoteDataSource {
  // Returns the list of all 114 surahs.
  Future<List<SurahModel>> getSurahs();
}

// API implementation of SurahsRemoteDataSource.
class SurahsRemoteDataSourceImp implements SurahsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  // Creates the data source with the shared API consumer.
  SurahsRemoteDataSourceImp(this._apiConsumer);

  // Returns the list of all 114 surahs.
  @override
  Future<List<SurahModel>> getSurahs() async {
    final response = await _apiConsumer.get(EndPoints.surahs);
    final data = response['data'] as List<dynamic>;
    return data.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
