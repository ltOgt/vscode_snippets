Container(
  decoration: BoxDecoration(
    color: Colors.white,
    //border: Border(top: BorderSide(color: Colors.blueAccent))
    border: Border.all(color: Colors.blueAccent),
    // borderRadius: BorderRadius.only(topLeft: const Radius.circular(4.0)),
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1, offset: Offset(1, 1))],
    shape: BoxShape.circle,
  ),
  child: const SizedBox(),
),
