import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String restaurantId;
  final String userName;
  final String content;
  final double rating;
  final DateTime date;
  String? imageUrl;

  Review({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.date,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'userName': userName,
      'content': content,
      'rating': rating,
      'date': date,
      'imageUrl': imageUrl,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['userId'],
      restaurantId: map['restaurantId'],
      userName: map['userName'],
      content: map['content'],
      rating: map['rating'],
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
    );
  }

  Review copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? userName,
    String? content,
    double? rating,
    DateTime? date,
    String? imageUrl,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
