import 'package:flutter/material.dart';

class Movie {
  final String id;
  final String title;
  final String genre;
  final int year;
  final String duration;
  final double rating;
  final String description;
  final String posterUrl;
  final String director;
  final Color accentColor;

  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.year,
    required this.duration,
    required this.rating,
    required this.description,
    required this.posterUrl,
    required this.director,
    required this.accentColor,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'genre': genre,
      'year': year,
      'duration': duration,
      'rating': rating,
      'description': description,
      'posterUrl': posterUrl,
      'director': director,
      'accentColorHex': _colorToHex(accentColor),
    };
  }

  factory Movie.fromFirestore(String id, Map<String, dynamic> data) {
    return Movie(
      id: id,
      title: data['title'] as String? ?? '',
      genre: data['genre'] as String? ?? '',
      year: data['year'] as int? ?? 0,
      duration: data['duration'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
      posterUrl: data['posterUrl'] as String? ?? '',
      director: data['director'] as String? ?? '',
      accentColor: _colorFromHex(data['accentColorHex'] as String?),
    );
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static Color _colorFromHex(String? hex) {
    final normalized = (hex ?? '#FF374151').replaceFirst('#', '');
    final parsed = int.tryParse(normalized.length == 6 ? 'FF$normalized' : normalized, radix: 16);
    return Color(parsed ?? 0xFF374151);
  }
}
