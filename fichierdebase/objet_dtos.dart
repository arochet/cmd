import 'package:base_de_projet/domain/core/value_objects.dart';
import 'package:base_de_projet/domain/auth/value_objects.dart';
import 'package:base_de_projet/domain/nom_fichier/nom_fichier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'objet-freezed-dtos.freezed.dart';
part 'objet-freezed-dtos.g.dart';

@freezed
abstract class AZERDTO implements _$AZERDTO {
  const AZERDTO._();

  const factory AZERDTO({
    @JsonKey(ignore: true) String? id,
    //insert-param-dto
  }) = _AZERDTO;

  factory AZERDTO.fromDomain(AZER obj) {
    return AZERDTO(
      id: obj.id.getOrCrash(),
      //insert-param-fromdomain
    );
  }

  AZER toDomain() {
    return AZER(
      id: UniqueId.fromUniqueString(id!),
      //insert-param-todomain
    );
  }

  factory AZERDTO.fromJson(Map<String, dynamic> json) =>
      _$AZERDTOFromJson(json);

  factory AZERDTO.fromFirestore(DocumentSnapshot doc) {
    return AZERDTO
        .fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }
}
