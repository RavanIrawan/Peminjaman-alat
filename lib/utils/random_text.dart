import 'dart:math';

class RandomText {
  String generateRandomString(int len) {
    final random = Random();

    const char = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return List.generate(len, (index) => char[random.nextInt(char.length)],).join();
  }
}