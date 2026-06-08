class Movie {
  final String ID;
  final String title;
  final String director;
  final int year;

  Movie({
    required this.ID,
    required this.title,
    required this.director,
    required this.year,
  });
}
List<Movie> movies = [
  Movie(ID: '1', title: 'Inception', director: 'Christopher Nolan', year: 2010),
  Movie(ID: '2', title: 'The Matrix', director: 'Lana Wachowski, Lilly Wachowski', year: 1999),
  Movie(ID: '3', title: 'Interstellar', director: 'Christopher Nolan', year: 2014),
];