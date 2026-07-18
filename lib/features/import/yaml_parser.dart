import 'package:yaml/yaml.dart';

/// Result of parsing and validating a YAML import block.
class YamlParseResult {
  const YamlParseResult({
    required this.projects,
    required this.warnings,
  });

  final List<ParsedProject> projects;
  final List<String> warnings;

  bool get hasWarnings => warnings.isNotEmpty;
  bool get isEmpty => projects.isEmpty;
}

class ParsedProject {
  ParsedProject({
    required this.name,
    required this.description,
    required this.priority,
    required this.phases,
    required this.ideas,
    required this.relations,
    required this.isNew,
    this.existingProjectId,
    this.startDate,
    this.endDate,
  });

  final String name;
  final String? description;
  String priority;
  final List<ParsedPhase> phases;
  final List<String> ideas;
  final List<ParsedRelation> relations;
  final bool isNew;
  final String? existingProjectId;
  final DateTime? startDate;
  final DateTime? endDate;
}

class ParsedPhase {
  const ParsedPhase({required this.name, required this.summary});
  final String name;
  final String? summary;
}

class ParsedRelation {
  const ParsedRelation({
    required this.toName,
    required this.type,
    this.note,
    this.matchedProjectId,
    this.willCreateShell,
  });

  final String toName;
  final String type;
  final String? note;

  /// Existing project id if fuzzy-matched above threshold.
  final String? matchedProjectId;

  /// True if no match found, a shell project will be created.
  final bool? willCreateShell;
}

/// YAML schema validator and parser.
///
/// Handles both single-project and multi-project YAML formats (§4.2, §4.3).
/// Validation rules from §4.4:
///   - `name` is the only required field.
///   - `priority` must be low|medium|high; anything else → medium + warning.
///   - Relation types must be one of the 5 accepted values.
///   - Malformed YAML fails fast with a specific line/column error.
class YamlParser {
  static const List<String> _validPriorities = ['low', 'medium', 'high'];
  static const List<String> _validRelationTypes = [
    'depends_on',
    'blocks',
    'inspired_by',
    'part_of',
    'related_to',
  ];

  final List<String> _warnings = [];

  /// Main entry point.
  ///
  /// [rawYaml] — the pasted text.
  /// [existingProjects] — map of {name.toLowerCase(): id} for fuzzy matching.
  YamlParseResult parse(String rawYaml, Map<String, String> existingProjects) {
    _warnings.clear();
    final dynamic doc;

    try {
      doc = loadYaml(rawYaml);
    } catch (e) {
      throw YamlSyntaxException('YAML syntax error: $e');
    }

    if (doc is! YamlMap) {
      throw YamlSyntaxException('Top-level YAML must be a map.');
    }

    final List<YamlMap> rawProjects = [];

    if (doc.containsKey('project')) {
      // Single-project format
      rawProjects.add(doc['project'] as YamlMap);
    } else if (doc.containsKey('projects')) {
      // Multi-project format
      final list = doc['projects'];
      if (list is! YamlList) {
        throw YamlSyntaxException('"projects" must be a list.');
      }
      for (final item in list) {
        if (item is YamlMap && item.containsKey('project')) {
          rawProjects.add(item['project'] as YamlMap);
        }
      }
    } else {
      throw YamlSyntaxException(
        'Expected a "project" or "projects" key at the top level.',
      );
    }

    // Parse and deduplicate by name
    final Map<String, ParsedProject> parsed = {};
    for (final raw in rawProjects) {
      final project = _parseProject(raw, existingProjects);
      if (parsed.containsKey(project.name.toLowerCase())) {
        // Merge phases and ideas — §4.4 duplicate handling
        final existing = parsed[project.name.toLowerCase()]!;
        existing.phases.addAll(project.phases);
        existing.ideas.addAll(project.ideas);
        _warnings.add(
          'Duplicate project name "${project.name}" in paste — merged into one.',
        );
      } else {
        parsed[project.name.toLowerCase()] = project;
      }
    }

    return YamlParseResult(
      projects: parsed.values.toList(),
      warnings: List.unmodifiable(_warnings),
    );
  }

  ParsedProject _parseProject(
    YamlMap raw,
    Map<String, String> existingProjects,
  ) {
    // Required: name
    final name = raw['name']?.toString().trim();
    if (name == null || name.isEmpty) {
      throw YamlSyntaxException('A project entry is missing the "name" field.');
    }

    // Optional: description
    final description = raw['description']?.toString().trim();

    // Optional: priority (auto-corrected)
    var priority = (raw['priority']?.toString().trim() ?? 'medium').toLowerCase();
    if (!_validPriorities.contains(priority)) {
      _warnings.add(
        'Project "$name": invalid priority "$priority" — auto-corrected to "medium".',
      );
      priority = 'medium';
    }

    // Optional: phases
    final phases = <ParsedPhase>[];
    final rawPhases = raw['phases'];
    if (rawPhases is YamlList) {
      for (final ph in rawPhases) {
        if (ph is YamlMap) {
          phases.add(
            ParsedPhase(
              name: ph['name']?.toString() ?? 'Unnamed phase',
              summary: ph['summary']?.toString(),
            ),
          );
        }
      }
    }

    // Optional: ideas
    final ideas = <String>[];
    final rawIdeas = raw['ideas'];
    if (rawIdeas is YamlList) {
      for (final idea in rawIdeas) {
        final ideaStr = idea?.toString().trim();
        if (ideaStr != null && ideaStr.isNotEmpty) {
          ideas.add(ideaStr);
        }
      }
    }

    // Optional: relations
    final relations = <ParsedRelation>[];
    final rawRelations = raw['relations'];
    if (rawRelations is YamlList) {
      for (final rel in rawRelations) {
        if (rel is YamlMap) {
          final parsedRel = _parseRelation(rel, existingProjects, name);
          if (parsedRel != null) relations.add(parsedRel);
        }
      }
    }

    // Optional: startDate
    DateTime? startDate;
    final rawStartDate = raw['startDate']?.toString().trim();
    if (rawStartDate != null && rawStartDate.isNotEmpty) {
      startDate = DateTime.tryParse(rawStartDate);
      if (startDate == null) {
        _warnings.add('Project "$name": invalid startDate "$rawStartDate" — ignored.');
      }
    }

    // Optional: endDate
    DateTime? endDate;
    final rawEndDate = raw['endDate']?.toString().trim();
    if (rawEndDate != null && rawEndDate.isNotEmpty) {
      endDate = DateTime.tryParse(rawEndDate);
      if (endDate == null) {
        _warnings.add('Project "$name": invalid endDate "$rawEndDate" — ignored.');
      }
    }

    // Check if matches an existing project (fuzzy match)
    final matchId = _fuzzyMatch(name, existingProjects);

    return ParsedProject(
      name: name,
      description: description,
      priority: priority,
      phases: phases,
      ideas: ideas,
      relations: relations,
      isNew: matchId == null,
      existingProjectId: matchId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  ParsedRelation? _parseRelation(
    YamlMap raw,
    Map<String, String> existingProjects,
    String sourceProjectName,
  ) {
    final toName = raw['to']?.toString().trim();
    if (toName == null || toName.isEmpty) {
      _warnings.add(
        'Project "$sourceProjectName": a relation is missing the "to" field — skipped.',
      );
      return null;
    }

    var type = (raw['type']?.toString().trim() ?? 'related_to').toLowerCase().replaceAll(' ', '_');
    if (!_validRelationTypes.contains(type)) {
      _warnings.add(
        'Project "$sourceProjectName": unknown relation type "$type" → defaulted to "related_to".',
      );
      type = 'related_to';
    }

    final note = raw['note']?.toString().trim();
    final matchId = _fuzzyMatch(toName, existingProjects);

    return ParsedRelation(
      toName: toName,
      type: type,
      note: note,
      matchedProjectId: matchId,
      willCreateShell: matchId == null,
    );
  }

  /// Case-insensitive exact match first, then token-overlap fuzzy match.
  /// Returns existing project id if confidence >= threshold, otherwise null.
  String? _fuzzyMatch(String name, Map<String, String> existingProjects) {
    final nameLower = name.toLowerCase().trim();

    // Exact match (case-insensitive)
    if (existingProjects.containsKey(nameLower)) {
      return existingProjects[nameLower];
    }

    // Token overlap fuzzy match
    final nameTokens = _tokenize(nameLower);
    String? bestMatchId;
    double bestScore = 0.0;

    for (final entry in existingProjects.entries) {
      final candidateTokens = _tokenize(entry.key);
      final overlap = nameTokens.intersection(candidateTokens).length;
      final total =
          nameTokens.union(candidateTokens).length;
      if (total == 0) continue;
      final score = overlap / total;
      if (score > bestScore) {
        bestScore = score;
        bestMatchId = entry.value;
      }
    }

    // Threshold: 50% token overlap
    return bestScore >= 0.5 ? bestMatchId : null;
  }

  Set<String> _tokenize(String s) {
    return s
        .split(RegExp(r'[\s\-_]+'))
        .where((t) => t.length > 1)
        .toSet();
  }
}

class YamlSyntaxException implements Exception {
  const YamlSyntaxException(this.message);
  final String message;

  @override
  String toString() => 'YamlSyntaxException: $message';
}
