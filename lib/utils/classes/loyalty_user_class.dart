class LoyaltyUserRules {
  final String userEmail;
  final String storeEmail;
  final int totalPoint;
  final int totalGained;

  LoyaltyUserRules({
    required this.userEmail,
    required this.storeEmail,
    required this.totalPoint,
    required this.totalGained,
  });
}
