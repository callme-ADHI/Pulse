import 'package:flutter_graph_view/flutter_graph_view.dart';
import '../../db/database.dart';
import '../home/home_providers.dart';

/// Converts Pulse DB types (ProjectWithDecay / Relation) into the Map-based
/// format expected by flutter_graph_view's built-in [MapConvertor].
///
/// We extend [MapConvertor] directly so we inherit the full convertVertex /
/// convertEdge / convertGraph implementations and only override the two
/// Iterable extractors to pull from our custom data keys.
class PulseGraphConvertor extends MapConvertor {
  @override
  Iterable originVertexes(dynamic data) {
    final projects = data['projects'] as List<ProjectWithDecay>? ?? [];
    return projects.map((p) => <String, dynamic>{
      'id'    : p.project.id,
      'tag'   : p.zone,
      'tags'  : [p.zone],
      // store business data under 'data' so vertex.data == this map's 'data'
      'data'  : <String, dynamic>{
        'id'    : p.project.id,
        'name'  : p.project.name,
        'score' : p.score,
        'zone'  : p.zone,
        'weight': p.project.weight,
      },
    });
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
