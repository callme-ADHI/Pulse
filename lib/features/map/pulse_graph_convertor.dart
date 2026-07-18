import 'package:flutter_graph_view/flutter_graph_view.dart';
import '../../db/database.dart';
import '../home/home_providers.dart';

/// Converts Pulse DB types (ProjectWithDecay / Idea / Relation) into the Map-based
/// format expected by flutter_graph_view's built-in [MapConvertor].
class PulseGraphConvertor extends MapConvertor {
  @override
  Iterable originVertexes(dynamic data) {
    final projects = data['projects'] as List<ProjectWithDecay>? ?? [];
    final ideas = data['ideas'] as List<Idea>? ?? [];

    final projectVertices = projects.map((p) => <String, dynamic>{
      'id'    : p.project.id,
      'tag'   : p.zone,
      'tags'  : [p.zone],
      'data'  : <String, dynamic>{
        'id'    : p.project.id,
        'name'  : p.project.name,
        'score' : p.score,
        'zone'  : p.zone,
        'weight': p.project.weight,
        'type'  : 'project',
      },
    });

    final ideaVertices = ideas.map((i) => <String, dynamic>{
      'id'    : i.id,
      'tag'   : 'idea',
      'tags'  : ['idea'],
      'data'  : <String, dynamic>{
        'id'    : i.id,
        'name'  : i.content,
        'score' : 0.0,
        'zone'  : 'idea',
        'weight': 1.0,
        'type'  : 'idea',
      },
    });

    return [...projectVertices, ...ideaVertices];
  }

  @override
  Iterable originEdges(dynamic data) {
    final relations = data['relations'] as List<Relation>? ?? [];
    return relations.map((r) => <String, dynamic>{
      'srcId'   : r.fromId,
      'dstId'   : r.toId,
      'edgeName': r.relationType,
      'ranking' : 0,
    });
  }
}
