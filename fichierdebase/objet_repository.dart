import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:base_de_projet/INFRASTRUCTURE/core/firestore_helpers.dart';
import 'package:base_de_projet/DOMAIN/az_er/az_er.dart';
import 'package:base_de_projet/DOMAIN/az_er/az_er_failure.dart';
import 'package:base_de_projet/DOMAIN/core/value_objects.dart';
import 'az_er_dtos.dart';

abstract class IAZERRepository {
  Stream<Either<AZERFailure, List<AZER>>> watch();
  Future<Either<AZERFailure, AZER>> watchWithId(UniqueId id);
  Future<Either<AZERFailure, Unit>> create(AZER azer);
  Future<Either<AZERFailure, Unit>> update(AZER azer);
  Future<Either<AZERFailure, Unit>> delete(UniqueId id);
}

@LazySingleton(as: IAZERRepository)
class AZERRepository implements IAZERRepository {
  final FirebaseFirestore _firestore;

  AZERRepository(
    this._firestore,
  );

  @override
  Future<Either<AZERFailure, Unit>> create(AZER azer) async {
    try {
      /* final user = (await getIt<AuthRepository>().getUserData())
          .fold(() => null, (user) => user);

      //UID de la tâche
      final uid = user?.id;
      if (uid != null)
        azer = azer.copyWith(uid: uid);
      else
        return left(const AZERFailure.unexpected()); */

      //On crée la méchante tâche
      final azerDTO = AZERDTO.fromDomain(azer);
      await _firestore.azerCollection.doc(azerDTO.id).set(azerDTO.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const AZERFailure.insufficientPermission());
      } else if (e.message!
          .contains('The caller does not have permission to execute the specified operation')) {
        return left(const AZERFailure.insufficientPermission());
      } else {
        return left(const AZERFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<AZERFailure, Unit>> delete(UniqueId id) async {
    try {
      await _firestore.azerCollection.doc(id.getOrCrash()).delete();

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const AZERFailure.insufficientPermission());
      } else if (e.message!.contains('not-found')) {
        return left(const AZERFailure.unableToUpdate());
      } else {
        return left(const AZERFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<AZERFailure, Unit>> update(AZER azer) async {
    try {
      final azerDTO = AZERDTO.fromDomain(azer);
      await _firestore.azerCollection.doc(azerDTO.id).update(azerDTO.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const AZERFailure.insufficientPermission());
      } else if (e.message!.contains('not-found')) {
        return left(const AZERFailure.unableToUpdate());
      } else {
        return left(const AZERFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<AZERFailure, List<AZER>>> watch() async* {
    final collection = _firestore.azerCollection;

    yield* collection
        .snapshots()
        .map(
          (snapshot) => right<AZERFailure, List<AZER>>(
            snapshot.docs.map((doc) {
              try {
                return AZERDTO.fromFirestore(doc).toDomain();
              } catch (e) {}
              return AZER.empty();
            }).toList(),
          ),
        )
        .handleError((e) {
      if (e is FirebaseException && e.message!.contains('permission-denied')) {
        return left(const AZERFailure.insufficientPermission());
      } else {
        return left(const AZERFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<AZERFailure, AZER>> watchWithId(UniqueId id) async {
    final collection = _firestore.azerCollection.doc(id.getOrCrash());

    return collection.get().then((doc) => right(AZERDTO
        .fromFirestore(doc)
        .toDomain())) /* .onError((e, stackTrace) => left(const AZERFailure.unexpected())) */;
  }
}
