import 'dart:math';

String generateRandomHex() {
  Random random = Random();
  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < 10; i++) {
    buffer.write(random.nextInt(16).toRadixString(16));
  }

  return buffer.toString().toUpperCase();
}
