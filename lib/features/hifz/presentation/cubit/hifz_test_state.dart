import 'package:equatable/equatable.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';

// Self-test progress: how much of each ayah is shown and how the user rated it.
class HifzTestData extends Equatable {
  final HifzSessionModel session;
  final List<int> revealedWords;
  final Map<int, bool> results;
  final bool firstWordHint;

  // Creates the test data.
  const HifzTestData({
    required this.session,
    required this.revealedWords,
    required this.results,
    required this.firstWordHint,
  });

  // Tells whether the whole ayah at the given index is shown.
  bool isFullyRevealed(int index) => revealedWords[index] >= session.ayahs[index].words.length;

  // Returns how many ayahs were rated as memorized in this test.
  int get memorizedCount => results.values.where((v) => v).length;

  // Returns how many ayahs were rated in this test.
  int get ratedCount => results.length;

  // Returns a copy with the given fields replaced.
  HifzTestData copyWith({List<int>? revealedWords, Map<int, bool>? results, bool? firstWordHint}) => HifzTestData(
        session: session,
        revealedWords: revealedWords ?? this.revealedWords,
        results: results ?? this.results,
        firstWordHint: firstWordHint ?? this.firstWordHint,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [session, revealedWords, results, firstWordHint];
}

// Base state of the self-test.
abstract class HifzTestState extends Equatable {
  // Creates the base state.
  const HifzTestState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The test has not loaded yet.
class HifzTestInitial extends HifzTestState {
  // Creates the initial state.
  const HifzTestInitial();
}

// The ayahs are loading.
class HifzTestLoading extends HifzTestState {
  // Creates the loading state.
  const HifzTestLoading();
}

// The test is ready.
class HifzTestSuccess extends HifzTestState {
  final HifzTestData data;

  // Creates the success state.
  const HifzTestSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// The test failed to load; message is a translation key.
class HifzTestError extends HifzTestState {
  final String message;

  // Creates the error state.
  const HifzTestError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
