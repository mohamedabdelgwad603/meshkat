import 'package:equatable/equatable.dart';

// Base failure returned on the Left side of repository results; message is a translation key.
abstract class Failure extends Equatable {
  final String message;

  // Creates a failure with a translation key message.
  const Failure(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}

// Failure raised by a remote request.
class ServerFailure extends Failure {
  // Creates a server failure with a translation key message.
  const ServerFailure(super.message);
}

// Failure raised by local storage.
class CacheFailure extends Failure {
  // Creates a cache failure with a translation key message.
  const CacheFailure(super.message);
}
