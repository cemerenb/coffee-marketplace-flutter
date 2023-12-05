class Rating {
  final String ratingId;
  final String storeEmail;
  final String userEmail;
  final String orderId;
  final int ratingPoint;
  final String comment;
  final int isRatingDisplayed;
  final String ratingDisabledComment;
  final String ratingDate;
  Rating({
    required this.ratingId,
    required this.storeEmail,
    required this.userEmail,
    required this.orderId,
    required this.ratingPoint,
    required this.comment,
    required this.isRatingDisplayed,
    required this.ratingDisabledComment,
    required this.ratingDate,
  });
}
