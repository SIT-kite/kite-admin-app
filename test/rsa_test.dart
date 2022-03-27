import 'dart:convert';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test', () async {
    final text = '2203272|1812100505|2|49|1648392466';
    final pem = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5GqOoJY2vuODKVgJoJ67
YPLBOMtwZHnoxz1Fr2bclMwTuPizMMxLl6tHxXBwYR1s56fl8tbpt03CJ8/asM3v
PmZAgEtG2XjpbJ2qlueTWXbpQw5zhgrUDrbOznVLSE4z9kYHY93dmM7qKhTtVg+t
7wQ53ceN7bDUHmEGibe868dtF85yf7AmXbzJJO0UixIgM8iq2MX2sWxqdtANnWhP
qVKh4fsESbylddOwTcag6cKuSOX6f39Na7J4AK4VvFTVu2oTtJuA75Dl9qDRKUCd
C+jMNc4dnDBDFatl2V/o00MeTyOHgqDeZs8Ny+wl1381dbs1VVvqK+s5EFrb2QJJ
TwIDAQAB
-----END PUBLIC KEY-----''';

    final key = RSAPublicKey.fromPEM(pem);
    final sign =
        'xwFbOH6eM+jN5J+jNH83YgmSi5TYoKTHxxYodnR5TuLQ+qkH9qcskwG1g8zklscUizniE5F+ouFf3stknHjFcE7bfkSt/91IMTBaJGbgoKYjYeegTuIiP7QwbCNkSG7ju6TvVOahYnyc/LnnZK7qpMq7iQ7UfLuF2Sb9uQYd/EVx3Bw16oecoKs7nh9d8OGvGozfWdJV6JXfeNBU/y3vlqTHyg9CeMZYpqOi3RUOCwns+coPu6+RrQYV9qf5x9QM9YLTI9ob+Ljfi3H3NVw/oM17bImtZ+EyCjWXr2HbslYWa8PxToEFDerlLfO2cUCwc8GkIY9A4u0RQiCISOMCsg==';

    final a = key.verifySHA256Signature(utf8.encode(text) as Uint8List, base64Decode(sign));
    print(a);
  });
}
