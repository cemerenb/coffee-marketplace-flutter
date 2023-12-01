class Store {
  final String storeEmail;
  final String storeName;
  final String storeTaxId;
  final String storeLogoLink;
  final int storeIsOn;
  final String openingTime;
  final String closingTime;
  final String storeCoverImageLink;
  final num storeLatitude;
  final num storeLongitude;

  Store({
    required this.storeEmail,
    required this.storeName,
    required this.storeTaxId,
    required this.storeLogoLink,
    required this.storeIsOn,
    required this.openingTime,
    required this.closingTime,
    required this.storeCoverImageLink,
    required this.storeLatitude,
    required this.storeLongitude,
  });
}
