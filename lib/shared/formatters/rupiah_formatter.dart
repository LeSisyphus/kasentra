class RupiahFormatter {
  const RupiahFormatter._();

  static String format(int amount) {
    final isNegative = amount < 0;
    final digits = amount.abs().toString();

    final reversedChars = digits.split('').reversed.toList();
    final groups = <String>[];

    for (var i = 0; i < reversedChars.length; i += 3) {
      final group = reversedChars.skip(i).take(3).toList().reversed.join();
      groups.add(group);
    }

    final groupedDigits = groups.reversed.join('.');
    final prefix = isNegative ? '-Rp ' : 'Rp ';

    return '$prefix$groupedDigits';
  }

  static int parse(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.isEmpty) {
      return 0;
    }

    return int.parse(cleaned);
  }
}
