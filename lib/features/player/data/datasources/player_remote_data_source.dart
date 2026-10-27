import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/data/requests_params/surah_audio_params.dart';
import 'package:mishkat/features/tafsir/data/requests_params/editions_params.dart';

// Fetches reciters and recitation audio from the API and CDN.
abstract class PlayerRemoteDataSource {
  // Returns the Arabic verse-by-verse reciters.
  Future<List<ReciterModel>> getReciters();

  // Returns the audio of every ayah of a surah for a reciter.
  Future<List<AyahAudioModel>> getSurahAudio(SurahAudioParams params);

  // Downloads one audio file to the given path.
  Future<void> downloadAudio(String url, String savePath, {void Function(double progress)? onProgress});
}

// API implementation of PlayerRemoteDataSource.
class PlayerRemoteDataSourceImp implements PlayerRemoteDataSource {
  final ApiConsumer _apiConsumer;

  // Creates the data source with the shared API consumer.
  PlayerRemoteDataSourceImp(this._apiConsumer);

  // Returns the Arabic verse-by-verse reciters.
  @override
  Future<List<ReciterModel>> getReciters() async {
    final response = await _apiConsumer.get(EndPoints.editions, queryParameters: EditionsParams.arabicRecitations.toJson());
    final data = response['data'] as List<dynamic>;
    return data.map((e) => ReciterModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Returns the audio of every ayah of a surah for a reciter.
  @override
  Future<List<AyahAudioModel>> getSurahAudio(SurahAudioParams params) async {
    final response = await _apiConsumer.get(EndPoints.surah(params.surahNumber, params.reciter));
    final ayahs = (response['data'] as Map<String, dynamic>)['ayahs'] as List<dynamic>;
    return ayahs.map((e) => AyahAudioModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Downloads one audio file to the given path.
  @override
  Future<void> downloadAudio(String url, String savePath, {void Function(double progress)? onProgress}) =>
      _apiConsumer.download(url, savePath, onProgress: onProgress);
}
