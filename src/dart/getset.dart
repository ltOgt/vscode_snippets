// 1: type, 2: name
$1 _$2;
$1 get $2 => _$2;
set $2($1 v) => notify(() => _$2 = v);
