class KasentraValidators {
  const KasentraValidators._();

  static String? requiredField(String? value, {String fieldName = 'Data'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  static String? positiveAmount(String? value, {String fieldName = 'Nominal'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(cleaned);

    if (amount == null || amount <= 0) {
      return '$fieldName harus lebih dari 0';
    }

    return null;
  }

  static String? nonNegativeAmount(
    String? value, {
    String fieldName = 'Nominal',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(cleaned);

    if (amount == null || amount < 0) {
      return '$fieldName tidak boleh negatif';
    }

    return null;
  }

  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final cleaned = value.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleaned.length < 8) {
      return 'Nomor HP terlalu pendek';
    }

    return null;
  }
}
