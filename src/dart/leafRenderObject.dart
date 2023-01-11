class $1 extends LeafRenderObjectWidget {
  const $1({
    Key? key,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return Render$1();
  }

  @override
  void updateRenderObject(
    BuildContext context,
    Render$1 renderObject,
  ) {
    // TODO use setters here
  }
}

class Render$1 extends RenderBox {
  Render$1();

  // int _myvar;
  // int get myvar => _myvar;
  // set myvar(int value) {
  //   if (value == _myvar) return;
  //   assert(value > 0);
  //   _myvar = value;
  //   markNeedsLayout();
  // }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // TODO compute dry layout
    return constraints.smallest;
  }

  @override
  void performLayout() {
    // TODO: implement performLayout
    size = constraints.smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
  }
}
