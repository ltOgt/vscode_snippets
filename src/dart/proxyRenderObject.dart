class $1 extends SingleChildRenderObjectWidget {
  const $1({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Render$1 createRenderObject(BuildContext context) {
    return Render$1();
  }

  @override
  void updateRenderObject(BuildContext context, Render$1 renderObject) {
    // TODO update via setters here
  }
}

class Render$1 extends RenderProxyBox {
  Render$1({
    RenderBox? child,
  }) : super(child);

  // int _myvar;
  // int get myvar => _myvar;
  // set myvar(int value) {
  //   if (value == _myvar) return;
  //   assert(value > 0);
  //   _myvar = value;
  //   markNeedsLayout(); // or paint or parent ...
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
