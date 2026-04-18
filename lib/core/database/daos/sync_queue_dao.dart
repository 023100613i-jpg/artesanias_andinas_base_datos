// ignore_for_file: prefer_const_constructors

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_tables.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<int> enqueue({
    required String operation,
    required String entityType,
    required int entityId,
    String? payload,
  }) {
    return into(syncQueue).insert(
      SyncQueueCompanion(
        operation: Value(operation),
        entityType: Value(entityType),
        entityId: Value(entityId),
        payload: Value(payload),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
        retryCount: Value(0),
        status: Value('pending'),
      ),
    );
  }

  Future<List<SyncQueueData>> getPendingItems() => (select(syncQueue)..where((t) => t.status.equals('pending'))).get();
  
  Future<void> markAsDone(int id) async {
    await (update(syncQueue)..where((t) => t.id.equals(id))).write(SyncQueueCompanion(status: Value('done')));
  }
}