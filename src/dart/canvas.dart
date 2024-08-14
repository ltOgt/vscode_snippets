import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:onkel_chatty/firstTry.dart';
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

  /// - [update] receives null     <-- [id] was not found in [_relations].
  /// - [update] returns null      --> node behind [id] will not be changed
  ///                              --> node behind [id] will not be removed. use [removeNode] instead.
  /// - [update] returns a node    --> node behind [id] will be replaced.
  void _updateMap<K, V>(Map<K, V> map, K id, V? Function(V? relation) update) {
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

  UnmodifiableMapView<CanvasRelationId, CanvasRelation> get relations => _relations.readOnly;
  UnmodifiableMapView<CanvasNodeId, CanvasNode> get nodes => _nodes.readOnly;
  UnmodifiableMapView<CanvasExternalId, CanvasExternal> get externals => _externals.readOnly;
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

  CanvasModel get canvasModel => _scCanvasModel.obj;
  late final StateComponent<CanvasModel, MyCanvas> _scCanvasModel;
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
              ...canvasModel.externals.keys,
              ...canvasModel.relations.keys,
              ...canvasModel.nodes.keys,
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
              print("Tapped the canvas at ${co.toValueString()}");

              addLightExternalOnClick(co);

              /// Clear selection
              ctrl.ncCtrl.clearSelectionAreas();
            },

            /// Widget to put as background
            backgroundWidget: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
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
            ),

            /// Ruler Options
            rulerOptions: const RulerOptions(
              color: Colors.transparent,
              width: 1,
            )),
      ),
    );
  }

  CanvasExternalId? lastLight;
  void addLightExternalOnClick(OffsetCanvas center) {
    final id = CanvasNodeId.decode(idGen.next.value);
    //final viewportRect = ctrl.rfc.viewportAsCanvasRect;
    final viewportCenteredRect = RectCanvas.fromRect(
      Rect.fromCenter(
        center: center.asOffset(),
        width: 700,
        height: 400,
      ),
    );

    final newLightId = CanvasExternalId.decode(idGen.next.value);
    if (lastLight != null) {
      final relationId = CanvasRelationId.decode(idGen.next.value);
      canvasModel.updateRelations(
        relationId,
        (node) => CanvasRelation(
          id: relationId,
          anchorA: AnchorRcCenter(element: lastLight!),
          anchorB: AnchorRcCenter(element: newLightId),
          direction: DirectionRC.ab,
          waypoints: [],
          style: CanvasPathStyle(
            lineColor: Colors.white.withAlpha(44),
            lineWidth: 2,
            pointColor: Colors.white.withAlpha(44),
            pointRadius: 10,
          ),
        ),
      );
    }

    canvasModel.updateExternals(
      newLightId,
      (node) => CanvasExternal(
        id: newLightId,
        rect: viewportCenteredRect,
        builder: CanvasElementCachelessBuilder(
          builder: (context, lod) => DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(20)),
              gradient: RadialGradient(
                colors: [
                  Colors.white,
                  Colors.white.withAlpha(0),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    lastLight = newLightId;
  }
}
