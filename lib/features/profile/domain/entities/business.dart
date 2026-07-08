enum BusinessType { groceryStore, retail, food, service, other }

class Business {
  const Business({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.address,
    this.syncedAt,
  });

  final String id;

  /// Nama usaha, contoh: Toko Sembako Ibu.
  final String name;

  /// Nama pemilik usaha.
  final String ownerName;

  final BusinessType type;

  final String? phoneNumber;
  final String? address;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Nullable untuk future cloud sync.
  final DateTime? syncedAt;

  String get typeLabel {
    switch (type) {
      case BusinessType.groceryStore:
        return 'Toko Sembako';
      case BusinessType.retail:
        return 'Ritel';
      case BusinessType.food:
        return 'Makanan';
      case BusinessType.service:
        return 'Jasa';
      case BusinessType.other:
        return 'Lainnya';
    }
  }

  Business copyWith({
    String? id,
    String? name,
    String? ownerName,
    BusinessType? type,
    String? phoneNumber,
    bool clearPhoneNumber = false,
    String? address,
    bool clearAddress = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    bool clearSyncedAt = false,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      type: type ?? this.type,
      phoneNumber: clearPhoneNumber ? null : phoneNumber ?? this.phoneNumber,
      address: clearAddress ? null : address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: clearSyncedAt ? null : syncedAt ?? this.syncedAt,
    );
  }
}
