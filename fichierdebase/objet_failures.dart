import 'package:freezed_annotation/freezed_annotation.dart';

part 'insert-freezed_failure.freezed.dart';

@freezed
abstract class AZERFailure with _$AZERFailure {
  const factory AZERFailure.unexpected() = _Unexpected;
  const factory AZERFailure.insufficientPermission() = _InsufficientPermission;
  const factory AZERFailure.unableToUpdate() = _UnableToUpdate;
}
