final _rng = Random();
int rng(int min, int max) => min + _rng.nextInt(max - min);
