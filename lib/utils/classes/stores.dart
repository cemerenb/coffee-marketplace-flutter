class Store {
  final String storeEmail;
  final String storeName;
  final String storeTaxId;
  final String storeLogoLink;
  final int storeIsOn;
  final String openingTime;
  final String closingTime;
  final String storeCoverImageLink;

  Store({
    required this.storeEmail,
    required this.storeName,
    required this.storeTaxId,
    required this.storeLogoLink,
    required this.storeIsOn,
    required this.openingTime,
    required this.closingTime,
    required this.storeCoverImageLink,
  });
}
