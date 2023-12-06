class LoyaltyRules {
  final int isPointsEnabled;
  final String storeEmail;
  final int pointsToGain;
  final int category1Gain;
  final int category2Gain;
  final int category3Gain;
  final int category4Gain;

  LoyaltyRules({
    required this.isPointsEnabled,
    required this.storeEmail,
    required this.pointsToGain,
    required this.category1Gain,
    required this.category2Gain,
    required this.category3Gain,
    required this.category4Gain,
  });
}
