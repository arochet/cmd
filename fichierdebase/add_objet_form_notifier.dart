import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:base_de_projet/DOMAIN/core/value_objects.dart';
import 'package:base_de_projet/DOMAIN/auth/value_objects.dart';
import 'package:base_de_projet/DOMAIN/az_er/az_er.dart';
import 'package:base_de_projet/DOMAIN/az_er/az_er_failure.dart';
import 'package:base_de_projet/INFRASTRUCTURE/az_er/az_er_repository.dart';
part 'add_insert_freezed_form_notifier.freezed.dart';

@freezed
class AddAZERFormData with _$AddAZERFormData {
  const factory AddAZERFormData({
    required AZER azer,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AZERFailure, Unit>> authFailureOrSuccessOption,
  }) = _AddAZERFormData;

  factory AddAZERFormData.initial() => AddAZERFormData(
      azer: AZER.empty(), showErrorMessages: false, isSubmitting: false, authFailureOrSuccessOption: none());
}

class AZERFormNotifier extends StateNotifier<AddAZERFormData> {
  final IAZERRepository _iAZERRepository;

  AZERFormNotifier(this._iAZERRepository) : super(AddAZERFormData.initial());

  //insert-changed

  addAZERPressed() async {
    Either<AZERFailure, Unit>? failureOrSuccess;

    //insert-valid-params
    if (false /* insert-valid-condition */) {
      state = state.copyWith(isSubmitting: true, authFailureOrSuccessOption: none());

      failureOrSuccess = await this._iAZERRepository.create(state.azer);

      if (failureOrSuccess.isRight()) {
        state = state.copyWith(azer: AZER.empty());
      }
    }

    state = state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: failureOrSuccess != null
            ? some(failureOrSuccess)
            : none()); //optionOf -> value != null ? some(value) : none();     | optionOf ne fonctionne pas
  }
}
