import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:relation_canvas/relation_canvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyCanvas(),
    );
  }
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({Key? key}) : super(key: key);

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class CanvasModel extends ChangeNotifier {
  final Map<CanvasRelationId, CanvasRelation> _relations = {};
  final Map<CanvasNodeId, CanvasNode> _nodes = {};
  final Map<CanvasExternalId, CanvasExternal> _externals = {};

  /// - [update] receives null     <-- [id] was not found in [_nodes].
  /// - [update] returns null      --> node behind [id] will not be changed
  ///                              --> node behind [id] will not be removed. use [removeNode] instead.
  /// - [update] returns a node    --> node behind [id] will be replaced.
  void _updateMap<K, V>(Map<K, V> map, K id, V? Function(V? node) update) {
    final value = map[id];
    final updated = update(value);
    if (updated != null) {
      map[id] = updated;
    }
    notifyListeners();
  }

  V? _removeMap<K, V>(Map<K, V> map, K key) {
    final removed = map.remove(key);
    notifyListeners();
    return removed;
  }

  void updateNode(CanvasNodeId id, CanvasNode? Function(CanvasNode? node) update) => _updateMap(_nodes, id, update);
  void updateRelations(CanvasRelationId id, CanvasRelation? Function(CanvasRelation? node) update) =>
      _updateMap(_relations, id, update);
  void updateExternals(CanvasExternalId id, CanvasExternal? Function(CanvasExternal? node) update) =>
      _updateMap(_externals, id, update);
  CanvasNode? removeNode(CanvasNodeId id) => _removeMap(_nodes, id);
  CanvasRelation? removeRelations(CanvasRelationId id) => _removeMap(_relations, id);
  CanvasExternal? removeExternals(CanvasExternalId id) => _removeMap(_externals, id);

  ReadOnlyMap<CanvasRelationId, CanvasRelation> get relations => _relations.readOnly;
  ReadOnlyMap<CanvasNodeId, CanvasNode> get nodes => _nodes.readOnly;
  ReadOnlyMap<CanvasExternalId, CanvasExternal> get externals => _externals.readOnly;
}

class _MyCanvasState extends ComponentState<MyCanvas> {
  // =========================================================================== Canvas Settings
  final CanvasSettings canvasSettings = CanvasSettings.uniform(10000);

  // =========================================================================== Controller Setup
  late final RelationCanvasStateComponent ctrl;
  void initCtrl() => ctrl = RelationCanvasStateComponent(
        state: this,
        canvasSettings: canvasSettings,
      );

  CanvasModel get canvasModel => _scCanvasModel.value;
  late final StateComponent<CanvasModel> _scCanvasModel;
  void initModel() => _scCanvasModel = StateComponent(
        onInit: () => CanvasModel(),
        onDispose: (_) {},
        state: this,
        setStateOnChange: true,
        onChange: () {},
      );

  @override
  void initState() {
    super.initState();

    initCtrl();
    initModel();
  }

  final CircleIdGen idGen = CircleIdGen();

  Set<CanvasNodeId> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNodeInViewportCenter,
      ),
      body: RelationCanvas(
        relations: canvasModel.relations,
        nodeCanvasParameters: NodeCanvasParameters(

            /// Set-Up
            referenceFrameController: ctrl.referenceFrameController,
            nodeCanvasController: ctrl.nodeCanvasController,
            backgroundColor: Colors.blueGrey.shade900,

            /// Transformation options for nodes
            nodes: canvasModel.nodes,
            nodeOptions: NodeOptionsNC(
              moveables: {...canvasModel.nodes.keys},
              scalables: {...canvasModel.nodes.keys},
              onEnd: (data) {
                final single = data.asSingle;
                if (single != null) {
                  canvasModel.updateNode(
                    single.nodeId,
                    (node) => node?.copyWith(
                      rect: single.currentRect,
                    ),
                  );
                } else {
                  final group = data.asGroup!;
                  // Transform group
                  for (final member in group.memberRects.entries) {
                    canvasModel.updateNode(
                      member.key,
                      (node) => node?.copyWith(
                        rect: member.value,
                      ),
                    );
                  }
                }
              },
            ),

            /// External UI elements that should be in [ordering] or
            /// placed relatively via [externalPlacementOptions].
            ///
            /// [externals] placed via [externalPlacementOptions] will be
            /// automatically removed from [ordering].
            externals: canvasModel.externals,
            externalPlacementOptions: const ExternalPlacementOptionsNC(),

            /// Ordering of all canvas elements
            ordering: {
              ...canvasModel.nodes.keys,
              ...canvasModel.relations.keys,
              ...canvasModel.externals.keys,
            } as LinkedHashSet<CanvasElementId>,

            /// Groups of [CanvasNodeId]s that can be transformed together
            groups: {
              if (selected.isNotEmpty)
                CanvasGroup(
                  members: selected,
                  isMoveable: true,
                  isScalable: true,
                  placement: PlacementCanvasGroup.belowMembers,
                  color: Colors.white.withAlpha(100),
                ),
            },

            /// Selection boxes
            selectionOptions: SelectionOptionsNC(
              // TODO ---------------- this is not currently called after transform => changed selection
              onSelectionChange: (areas) {
                // do stuff with rect intersection
                setState(() {
                  selected = canvasModel.nodes.values
                      .where((n) => areas.fold(false, (acc, sRect) => acc || sRect.overlaps(n.rect)))
                      .map((e) => e.id)
                      .toSet();
                });
              },
            ),

            /// Canvas Tap Callback
            onTapCanvas: (details) {
              final OffsetCanvas co = ctrl.rfc.offsetCanvasTLToCanvas(
                OffsetCanvasTL.fromOffset(details.localPosition),
              );
              print(\"Tapped the canvas at ${co.toValueString()}\");

              /// Clear selection
              ctrl.ncCtrl.clearSelection();
            },

            /// Widget to put as background
            backgroundWidget: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF444444),
                    Color(0xFF333333),
                    Color(0xFF222222),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),

            /// Ruler Options
            rulerOptions: const RulerOptions(
              color: Colors.transparent,
              width: 1,
            )),
      ),
    );
  }

  void createNewNodeInViewportCenter() {
    final id = CanvasNodeId.decode(idGen.next.value);
    final viewportRect = ctrl.rfc.viewportAsCanvasRect;

    canvasModel.updateNode(
      id,
      (node) => CanvasNode(
        id: id,
        rect: viewportRect.shrink(viewportRect.smallSide / 4),
        builder: CanvasElementCachelessBuilder(builder: (context, lod) {
          return Container(color: Colors.blue);
        }),
      ),
    );
  }
}