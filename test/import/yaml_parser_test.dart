import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/import/yaml_parser.dart';

void main() {
  group('YamlParser', () {
    late YamlParser parser;
    late Map<String, String> existingProjects;

    setUp(() {
      parser = YamlParser();
      existingProjects = {'pulse': 'proj-pulse-id', 'atlas': 'proj-atlas-id'};
    });

    test('parses single-project format', () {
      const yaml = '''
project:
  name: "Habit Atlas"
  priority: medium
  ideas:
    - "Let users name constellations"
''';
      final result = parser.parse(yaml, existingProjects);
      expect(result.projects, hasLength(1));
      expect(result.projects.first.name, 'Habit Atlas');
      expect(result.projects.first.ideas, hasLength(1));
      expect(result.hasWarnings, isFalse);
    });

    test('parses multi-project format', () {
      const yaml = '''
projects:
  - project:
      name: "Project A"
      priority: high
  - project:
      name: "Project B"
      priority: low
''';
      final result = parser.parse(yaml, existingProjects);
      expect(result.projects, hasLength(2));
    });

    test('auto-corrects invalid priority with warning', () {
      const yaml = '''
project:
  name: "Test"
  priority: extreme
''';
      final result = parser.parse(yaml, existingProjects);
      expect(result.projects.first.priority, 'medium');
      expect(result.warnings, isNotEmpty);
      expect(result.warnings.first, contains('auto-corrected'));
    });

    test('throws YamlSyntaxException on malformed YAML', () {
      const yaml = 'project: {name: missing bracket';
      expect(() => parser.parse(yaml, existingProjects), throwsA(isA<YamlSyntaxException>()));
    });

    test('throws when top-level key is missing', () {
      const yaml = 'name: "Project"';
      expect(() => parser.parse(yaml, existingProjects), throwsA(isA<YamlSyntaxException>()));
    });

    test('name is required — throws when missing', () {
      const yaml = '''
project:
  description: "No name"
  priority: medium
''';
      expect(() => parser.parse(yaml, existingProjects), throwsA(isA<YamlSyntaxException>()));
    });

    test('exact case-insensitive relation match', () {
      const yaml = '''
project:
  name: "New App"
  relations:
    - to: "Pulse"
      type: inspired_by
''';
      final result = parser.parse(yaml, existingProjects);
      final rel = result.projects.first.relations.first;
      expect(rel.matchedProjectId, 'proj-pulse-id');
      expect(rel.willCreateShell, isFalse);
    });

    test('no match → willCreateShell = true', () {
      const yaml = '''
project:
  name: "New App"
  relations:
    - to: "Unknown Project"
      type: related_to
''';
      final result = parser.parse(yaml, existingProjects);
      final rel = result.projects.first.relations.first;
      expect(rel.matchedProjectId, isNull);
      expect(rel.willCreateShell, isTrue);
    });

    test('duplicate project names are merged', () {
      const yaml = '''
projects:
  - project:
      name: "Same Name"
      ideas:
        - "Idea one"
  - project:
      name: "Same Name"
      ideas:
        - "Idea two"
''';
      final result = parser.parse(yaml, existingProjects);
      expect(result.projects, hasLength(1));
      expect(result.projects.first.ideas, hasLength(2));
      expect(result.warnings, isNotEmpty); // warns about merge
    });

    test('invalid relation type defaults to related_to with warning', () {
      const yaml = '''
project:
  name: "Test"
  relations:
    - to: "Pulse"
      type: weird_type
''';
      final result = parser.parse(yaml, existingProjects);
      expect(result.projects.first.relations.first.type, 'related_to');
      expect(result.warnings.any((w) => w.contains('related_to')), isTrue);
    });
  });
}
