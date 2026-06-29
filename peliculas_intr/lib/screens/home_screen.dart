import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_intr/entities/movie.dart';
import 'package:peliculas_intr/screens/add_movie_dialog.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({super.key, this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Movie> _movies;

  @override
  void initState() {
    super.initState();
    _movies = [
      const Movie(
        title: 'Oppenheimer',
        genre: 'Drama histórico',
        year: 2023,
        duration: '3h 0m',
        rating: 8.6,
        description:
            'Retrata el ascenso científico de J. Robert Oppenheimer y el costo moral de liderar el proyecto que cambió la guerra moderna.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/4/4a/Oppenheimer_%28film%29.jpg',
        director: 'Christopher Nolan',
        accentColor: Color(0xFF374151),
      ),
      const Movie(
        title: 'Interstellar',
        genre: 'Ciencia ficción',
        year: 2014,
        duration: '2h 49m',
        rating: 8.7,
        description:
            'Un grupo de exploradores viaja más allá del sistema solar para encontrar un nuevo hogar para la humanidad.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/b/bc/Interstellar_film_poster.jpg',
        director: 'Christopher Nolan',
        accentColor: Color(0xFF1F3B73),
      ),
      const Movie(
        title: 'Transformers',
        genre: 'Acción y ciencia ficción',
        year: 2007,
        duration: '2h 24m',
        rating: 7.0,
        description:
            'La guerra entre Autobots y Decepticons llega a la Tierra y un adolescente queda en el centro del conflicto.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/6/66/Transformers07.jpg',
        director: 'Michael Bay',
        accentColor: Color(0xFF9C2C2C),
      ),
      const Movie(
        title: 'Transformers: Dark Of The Moon',
        genre: 'Acción y ciencia ficción',
        year: 2011,
        duration: '2h 34m',
        rating: 6.2,
        description:
            'Sam Witwicky descubre una conspiración ligada a la carrera espacial y a un antiguo secreto de Cybertron.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/b/bf/Transformers_dark_of_the_moon_ver5.jpg',
        director: 'Michael Bay',
        accentColor: Color(0xFF4A5568),
      ),
      const Movie(
        title: 'Avatar',
        genre: 'Ciencia ficción y aventura',
        year: 2009,
        duration: '2h 42m',
        rating: 7.9,
        description:
            'En Pandora, un exmarine se integra al mundo na\'vi y debe elegir entre obedecer a su misión o proteger a un planeta vivo.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/d/d6/Avatar_%282009_film%29_poster.jpg',
        director: 'James Cameron',
        accentColor: Color(0xFF2A6F97),
      ),
      const Movie(
        title: 'Avatar: El camino del agua',
        genre: 'Ciencia ficción y aventura',
        year: 2022,
        duration: '3h 12m',
        rating: 7.6,
        description:
            'La familia de Jake y Neytiri busca refugio entre los clanes del agua mientras una amenaza regresa a Pandora.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/5/54/Avatar_The_Way_of_Water_poster.jpg',
        director: 'James Cameron',
        accentColor: Color(0xFF0F6E8C),
      ),
      const Movie(
        title: 'Avatar: Fire and Ash',
        genre: 'Ciencia ficción y aventura',
        year: 2025,
        duration: '3h 17m',
        rating: 7.2,
        description:
            'La siguiente etapa de la saga de Pandora promete llevar el conflicto a nuevas regiones y expandir el mundo de los na\'vi.',
        posterUrl:
            'https://m.media-amazon.com/images/M/MV5BZDYxY2I1OGMtN2Y4MS00ZmU1LTgyNDAtODA0MzAyYjI0N2Y2XkEyXkFqcGc@._V1_.jpg',
        director: 'James Cameron',
        accentColor: Color(0xFF7F1D1D),
      ),
      const Movie(
        title: 'Project Hail Mary',
        genre: 'Ciencia ficción',
        year: 2026,
        duration: '2h 36m',
        rating: 8.2,
        description:
            'Un profesor despierta a bordo de una nave espacial sin recordar su misión y debe descubrir cómo salvar a la Tierra.',
        posterUrl:
            'https://m.media-amazon.com/images/M/MV5BNTkwNzJiYTctNzI3NC00NjE1LTlhYjktY2Q5MTdmMWFmNzcxXkEyXkFqcGc@._V1_.jpg',
        director: 'Phil Lord y Christopher Miller',
        accentColor: Color(0xFF334155),
      ),
      const Movie(
        title: 'Nobody',
        genre: 'Acción y thriller',
        year: 2021,
        duration: '1h 32m',
        rating: 7.4,
        description:
            'Un hombre aparentemente común revela un pasado violento cuando un robo doméstico desata una cadena de consecuencias.',
        posterUrl:
            'https://upload.wikimedia.org/wikipedia/en/c/c7/Nobody_2021_Film_Poster.jpeg',
        director: 'Ilya Naishuller',
        accentColor: Color(0xFFB45309),
      ),
    ];
  }

  void _openMovie(Movie movie) {
    context.push('/movie-detail', extra: movie);
  }

  void _showAddMovieDialog() {
    showDialog<Movie>(
      context: context,
      builder: (context) => const AddMovieDialog(),
    ).then((movie) {
      if (movie != null) {
        setState(() {
          _movies.add(movie);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Película agregada correctamente!')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.username ?? 'Usuario';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        title: Text('Hola, $username'),
        backgroundColor: const Color(0xFFF4F1EA),
        elevation: 0,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: 'Agregar película',
              child: IconButton(
                onPressed: _showAddMovieDialog,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 28,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Películas destacadas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Toca una película para ver información completa y sinopsis.',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: _movies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final movie = _movies[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _openMovie(movie),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.black12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: SizedBox(
                                width: 74,
                                height: 110,
                                child: Image.network(
                                  movie.posterUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: movie.accentColor,
                                      child: const Icon(
                                        Icons.local_movies,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${movie.genre} • ${movie.year} • ${movie.duration}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    movie.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber[700],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
