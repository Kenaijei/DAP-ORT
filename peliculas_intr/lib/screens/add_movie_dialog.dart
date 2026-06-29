import 'package:flutter/material.dart';
import 'package:peliculas_intr/entities/movie.dart';

class AddMovieDialog extends StatefulWidget {
  const AddMovieDialog({super.key});

  @override
  State<AddMovieDialog> createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _directorController = TextEditingController();

  final List<Color> _accentColors = [
    const Color(0xFF374151),
    const Color(0xFF1F3B73),
    const Color(0xFF9C2C2C),
    const Color(0xFF4A5568),
    const Color(0xFF2A6F97),
    const Color(0xFF0F6E8C),
    const Color(0xFF7F1D1D),
    const Color(0xFF334155),
    const Color(0xFFB45309),
  ];

  int _selectedColorIndex = 0;

  void _addMovie() {
    if (_titleController.text.isEmpty ||
        _genreController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _ratingController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _posterUrlController.text.isEmpty ||
        _directorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final year = int.parse(_yearController.text);
      final rating = double.parse(_ratingController.text);

      if (rating < 0 || rating > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La calificación debe estar entre 0 y 10')),
        );
        return;
      }

      final movie = Movie(
        title: _titleController.text,
        genre: _genreController.text,
        year: year,
        duration: _durationController.text,
        rating: rating,
        description: _descriptionController.text,
        posterUrl: _posterUrlController.text,
        director: _directorController.text,
        accentColor: _accentColors[_selectedColorIndex],
      );

      Navigator.of(context).pop(movie);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Verifica que año y calificación sean números')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    _posterUrlController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar Nueva Película',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Año',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Rating (0-10)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duración (ej: 2h 30m)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _directorController,
                decoration: const InputDecoration(
                  labelText: 'Director',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _posterUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL del Póster',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Color Acento:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(_accentColors.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _accentColors[index],
                        border: _selectedColorIndex == index
                            ? Border.all(
                                color: Colors.black,
                                width: 3,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addMovie,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
