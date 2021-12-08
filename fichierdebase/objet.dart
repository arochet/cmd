import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:base_de_projet/domain/core/value_objects.dart';
import 'package:base_de_projet/domain/auth/value_objects.dart';

part 'objet-freezed.freezed.dart';

@freezed
abstract class AZER with _$AZER {
  const AZER._();

  const factory AZER({
    required UniqueId id,
    //insert-default-params
  }) = _AZER;

  factory AZER.empty() => AZER(
        id: UniqueId(),
        //insert-object-params
      );
}
