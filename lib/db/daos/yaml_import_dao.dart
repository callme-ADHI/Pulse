import 'package:drift/drift.dart';
import '../database.dart';

part 'yaml_import_dao.g.dart';

@DriftAccessor(tables: [YamlImports])
class YamlImportDao extends DatabaseAccessor<PulseDatabase>
    with _$YamlImportDaoMixin {
  YamlImportDao(super.db);

  Stream<List<YamlImport>> watchAllImports() {
    return (select(yamlImports)
          ..orderBy([(y) => OrderingTerm.desc(y.importedAt)]))
        .watch();
  }

  Future<YamlImport?> getImportById(String id) {
    return (select(yamlImports)..where((y) => y.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertImport(YamlImportsCompanion companion) {
    return into(yamlImports).insert(companion);
  }

  Future<void> markReverted(String id) {
    return (update(yamlImports)..where((y) => y.id.equals(id))).write(
      const YamlImportsCompanion(isReverted: Value(true)),
    );
  }
}
