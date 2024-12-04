import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final_year_project/models/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addReview(Review review, File? imageFile) async {
    if (imageFile != null) {
      final imageUrl = await _uploadImage(review.id, imageFile);
      review = review.copyWith(imageUrl: imageUrl);
    }
    await _firestore.collection('reviews').doc(review.id).set(review.toMap());
  }

  Future<void> updateReview(Review review, File? imageFile) async {
    final existingReviewDoc =
        await _firestore.collection('reviews').doc(review.id).get();
    if (existingReviewDoc.exists) {
      final existingReview = Review.fromMap(existingReviewDoc.data()!);
      if (imageFile != null) {
        if (existingReview.imageUrl != null) {
          await _deleteImage(existingReview.imageUrl!);
        }
        final imageUrl = await _uploadImage(review.id, imageFile);
        review = review.copyWith(imageUrl: imageUrl);
      } else if (existingReview.imageUrl != null && review.imageUrl == null) {
        // If the imageFile is null and the review's imageUrl is null, delete the existing image
        await _deleteImage(existingReview.imageUrl!);
        review = review.copyWith(imageUrl: null);
      }
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .update(review.toMap());
    }
  }

  Future<void> deleteReview(String reviewId) async {
    final reviewDoc =
        await _firestore.collection('reviews').doc(reviewId).get();
    if (reviewDoc.exists) {
      final review = Review.fromMap(reviewDoc.data()!);
      if (review.imageUrl != null) {
        await _deleteImage(review.imageUrl!);
      }
      await _firestore.collection('reviews').doc(reviewId).delete();
    }
  }

  Future<List<Review>> getReviewsByRestaurantId(String restaurantId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .get();
    return snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();
  }

  Future<List<Review>> getReviewsByUserId(String userId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();
  }

  Future<String> _uploadImage(String reviewId, File imageFile) async {
    final storageRef = _storage.ref().child('review_images/$reviewId.jpg');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  Future<void> _deleteImage(String imageUrl) async {
    final storageRef = _storage.refFromURL(imageUrl);
    await storageRef.delete();
  }
}
