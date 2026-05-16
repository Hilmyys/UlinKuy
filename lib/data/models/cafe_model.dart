class Cafe {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String priceRange; // $, $$, $$$
  final int wifiSpeed; // Mbps
  final double crowdLevel; // 0.0 to 1.0 (percentage)
  final String tasteRating; // e.g., 9.5/10
  final List<String> tags;
  final List<String> facilities;
  final List<MenuDetail> specialMenus;
  final List<ReviewDetail> reviews;
  final String operatingHours;

  Cafe({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.priceRange,
    required this.wifiSpeed,
    required this.crowdLevel,
    required this.tasteRating,
    required this.tags,
    required this.facilities,
    required this.specialMenus,
    required this.reviews,
    required this.operatingHours,
  });
}

class MenuDetail {
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  MenuDetail({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

class ReviewDetail {
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date;

  ReviewDetail({
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
