class FavoriteModel {
  final String? id;
  final String userId;
  final String adId;

  FavoriteModel({
    this.id,
    required this.adId,
    required this.userId,
  });

  FavoriteModel copyWith({
    String? id,
    String? adId,
    String? userId,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'adId': adId,
      'userId': userId,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] != null ? map['id'] as String : null,
      adId: map['adId'] as String,
      userId: map['userId'] as String,
    );
  }

  @override
  String toString() => 'FavoriteModel(id: $id, adId: $adId, userId: $userId)';
}
