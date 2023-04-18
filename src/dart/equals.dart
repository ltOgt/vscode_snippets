@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Class &&
              runtimeType == other.runtimeType &&
              id == other.property;

@override
int get hashCode => property.hashCode;
