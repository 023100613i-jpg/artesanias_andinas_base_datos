import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_tables.dart';

part 'artisans_dao.g.dart';

@DriftAccessor(tables: [Artisans])
class ArtisansDao extends DatabaseAccessor<AppDatabase> with _$ArtisansDaoMixin {
  ArtisansDao(super.db);

  Future<List<Artisan>> getAllArtisans() => select(artisans).get();
  Stream<List<Artisan>> watchAllArtisans() => select(artisans).watch();
  Future<Artisan?> getArtisanById(int id) => (select(artisans)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertArtisan(ArtisansCompanion entry) => into(artisans).insert(entry);
  Future<int> deleteArtisan(int id) => (delete(artisans)..where((t) => t.id.equals(id))).go();
}