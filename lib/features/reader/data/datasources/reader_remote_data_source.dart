import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';

// Fetches surah text from the API.
abstract class ReaderRemoteDataSource {
  // Returns the full text of one surah.
  Future<SurahTextModel> getSurahText(SurahTextParams params);
}

// API implementation of ReaderRemoteDataSource.
class ReaderRemoteDataSourceImp implements ReaderRemoteDataSource {
  final ApiConsumer _apiConsumer;

  // Creates the data source with the shared API consumer.
  ReaderRemoteDataSourceImp(this._apiConsumer);

  // Returns the full text of one surah.
  @override
  Future<SurahTextModel> getSurahText(SurahTextParams params) async {
    final response = await _apiConsumer.get(EndPoints.surah(params.surahNumber, params.edition));
    return SurahTextModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
