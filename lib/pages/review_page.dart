import 'dart:developer';
import 'dart:io';
import 'package:final_year_project/models/review.dart';
import 'package:final_year_project/services/database/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ReviewPage extends StatefulWidget {
  final String restaurantId;

  const ReviewPage({super.key, required this.restaurantId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewService _reviewService = ReviewService();
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  File? _imageFile;
  final List<double> ratingOptions = [0, 1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    _reviews =
        await _reviewService.getReviewsByRestaurantId(widget.restaurantId);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addOrUpdateReview(Review review) async {
    try {
      if (_reviews.any((r) => r.id == review.id)) {
        await _reviewService.updateReview(review, _imageFile);
      } else {
        await _reviewService.addReview(review, _imageFile);
      }
      _fetchReviews();
    } catch (e) {
      print('Error adding or updating review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding or updating review: $e')),
      );
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    await _reviewService.deleteReview(reviewId);
    _fetchReviews();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showReviewDialog({Review? review}) {
    final formKey = GlobalKey<FormState>();
    final contentController =
        TextEditingController(text: review?.content ?? '');
    final ratingController =
        TextEditingController(text: review?.rating.toString() ?? '');

    // Clear the image file if it's a new review
    if (review == null) {
      _imageFile = null;
    }

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dialog from being dismissed by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(review == null ? 'Add Review' : 'Edit Review'),
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(labelText: 'Content'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some content';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<double>(
                        value: review?.rating,
                        decoration: const InputDecoration(labelText: 'Rating'),
                        items: ratingOptions.map((double value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text(value
                                .toInt()
                                .toString()), // Convert double to int for display
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            ratingController.text = value.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a rating';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    await _pickImage(ImageSource.camera);
                                    setState(() {});
                                  },
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    await _pickImage(ImageSource.gallery);
                                    setState(() {});
                                  },
                          ),
                          if (_imageFile != null || review?.imageUrl != null)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _isSubmitting
                                  ? null
                                  : () {
                                      setState(() {
                                        _imageFile = null;
                                        review?.imageUrl = null;
                                        log("review: ${review?.imageUrl.toString()}");
                                      });
                                    },
                            ),
                        ],
                      ),
                      if (_imageFile != null)
                        Image.file(
                          _imageFile!,
                          height: 100,
                          width: 100,
                        ),
                      if (_imageFile == null && review?.imageUrl != null)
                        Image.network(
                          review!.imageUrl!,
                          height: 100,
                          width: 100,
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final newReview = Review(
                                id: review?.id ?? const Uuid().v4(),
                                userId: user.uid,
                                restaurantId: widget.restaurantId,
                                userName: user.displayName ?? 'Anonymous',
                                content: contentController.text,
                                rating: double.parse(ratingController.text),
                                date: DateTime.now(),
                                imageUrl: review?.imageUrl,
                              );
                              await _addOrUpdateReview(newReview);
                              setState(() {
                                _isSubmitting = false;
                              });
                              Navigator.of(context).pop();
                            }
                          }
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final isCurrentUser =
                    review.userId == FirebaseAuth.instance.currentUser?.uid;
                return ListTile(
                  title: Text(review.userName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review.imageUrl != null)
                        Image.network(
                          review.imageUrl!,
                          height: 100,
                          width: 100,
                        ),
                      Text(review.content),
                      Text('Rating: ${review.rating}'),
                      if (isCurrentUser)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showReviewDialog(review: review);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteReview(review.id);
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReviewDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
