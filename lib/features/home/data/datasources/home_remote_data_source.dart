import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';
import 'package:mishkat/features/home/data/requests_params/daily_ayah_params.dart';

// Fetches the home screen's daily ayah.
abstract class HomeRemoteDataSource {
  // Returns the ayah of the day.
  Future<DailyAyahModel> getDailyAyah(DailyAyahParams params);
}

// API implementation of HomeRemoteDataSource.
class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiConsumer _apiConsumer;

  // Creates the data source with the shared API consumer.
  HomeRemoteDataSourceImp(this._apiConsumer);

  // Returns the ayah of the day.
  @override
  Future<DailyAyahModel> getDailyAyah(DailyAyahParams params) async {
    final response = await _apiConsumer.get(EndPoints.ayah(params.ayahNumber.toString(), params.edition));
    return DailyAyahModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
