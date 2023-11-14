class Store {
  final String storeEmail;
  final String storeName;
  final String storeTaxId;
  final String storeLogoLink;
  final int storeIsOn;
  final String openingTime;
  final String closingTime;

  Store({
    required this.storeEmail,
    required this.storeName,
    required this.storeTaxId,
    required this.storeLogoLink,
    required this.storeIsOn,
    required this.openingTime,
    required this.closingTime,
  });
}
