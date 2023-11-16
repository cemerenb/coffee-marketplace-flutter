class Menu {
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemImageLink;
  final String storeEmail;
  final int menuItemIsAvaliable;
  final int menuItemPrice;
  final int menuItemCategory;
  final String menuItemId;

  Menu(
      {required this.menuItemName,
      required this.menuItemDescription,
      required this.menuItemImageLink,
      required this.storeEmail,
      required this.menuItemIsAvaliable,
      required this.menuItemPrice,
      required this.menuItemCategory,
      required this.menuItemId});
}
