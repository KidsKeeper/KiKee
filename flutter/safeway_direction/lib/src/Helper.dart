import 'dart:math';

keyGenerate() {
  var random = new Random();
  return 1 + random.nextInt( 9999 - 1 );
}