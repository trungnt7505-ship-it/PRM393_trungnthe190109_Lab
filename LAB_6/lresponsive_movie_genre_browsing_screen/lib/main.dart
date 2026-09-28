import 'dart:math';
import 'package:flutter/material.dart';

// ==============================================================================
// LAB 6.1 - STEP 1: Project Setup
// ==============================================================================
void main() {
  runApp(const ResponsiveMovieApp());
}

// ==============================================================================
// LAB 6.1 - STEP 2: Define the Movie Model & Sample Data
// ==============================================================================
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Constant list of sample movies (3-6 items)
final List<Movie> allMovies = [
  Movie(
    title: 'Dune: Part Two',
    year: 2024,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://picsum.photos/id/1069/600/400',
    rating: 8.6,
  ),
  Movie(
    title: 'Deadpool & Wolverine',
    year: 2024,
    genres: ['Action', 'Comedy'],
    posterUrl: 'https://picsum.photos/id/1040/600/400',
    rating: 8.3,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/id/1074/600/400',
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/id/1084/600/400',
    rating: 8.7,
  ),
  Movie(
    title: 'Joker',
    year: 2019,
    genres: ['Drama', 'Crime'],
    posterUrl: 'https://picsum.photos/id/1062/600/400',
    rating: 8.4,
  ),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Genre Browsing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GenreScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Controller to manage text inside the search bar dynamically
  final TextEditingController _searchController = TextEditingController();

  // State variables
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z'; // Options: 'A-Z', 'Z-A', 'Random'

  // Available genre options for chips
  final List<String> availableGenres = [
    'Action',
    'Adventure',
    'Drama',
    'Sci-Fi',
    'Comedy',
    'Crime'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================================================
    // LAB 6.2 - STEP 7: Filter and Sort the Movie List
    // ==========================================================================
    List<Movie> filteredMovies = allMovies.where((movie) {
      // Case-insensitive check matching search input or genre title
      final query = searchQuery.toLowerCase();
      final matchesTitle = movie.title.toLowerCase().contains(query);
      final matchesGenreName = movie.genres.any((g) => g.toLowerCase().contains(query));

      final matchesSearch = query.isEmpty || matchesTitle || matchesGenreName;

      // Filter by selected chips if any are toggled
      final matchesGenreChip = selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenreChip;
    }).toList();

    // Apply sorting logic (A-Z, Z-A, Random)
    if (selectedSort == 'A-Z') {
      filteredMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort == 'Z-A') {
      filteredMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (selectedSort == 'Random') {
      filteredMovies.shuffle(Random());
    }

    // ==========================================================================
    // LAB 6.1 - STEP 3: Build the Base Scaffold
    // ==========================================================================
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // Title Heading Section ("Find a Movie")
              // ==============================================================
              const Text(
                'Find a Movie',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ==============================================================
              // LAB 6.2 - STEP 4: Responsive Search Bar with Controller
              // ==============================================================
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search movie title or genre...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchQuery = '';
                        selectedGenres.clear();
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // ==============================================================
              // LAB 6.2 - STEP 5: Genre Chips (Clicking populates search/filter)
              // ==============================================================
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                          // Automatically set the search text to match the clicked genre
                          searchQuery = genre;
                          _searchController.text = genre;
                        } else {
                          selectedGenres.remove(genre);
                          searchQuery = '';
                          _searchController.clear();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // ==============================================================
              // LAB 6.2 - STEP 6: Sort Dropdown Bar & Dynamic Result Counter
              // ==============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dynamically updates count based on filtered results
                  Text(
                    'Results (${filteredMovies.length})',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ['A-Z', 'Z-A', 'Random']
                        .map((sortOption) => DropdownMenuItem(
                      value: sortOption,
                      child: Text('Sort: $sortOption'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ==============================================================
              // LAB 6.3 - STEP 8 & STEP 9: Responsive Movie List & Adaptability
              // ==============================================================
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWideScreen = constraints.maxWidth >= 800;

                    if (filteredMovies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    if (!isWideScreen) {
                      // Single-column list for phones (< 800px)
                      return ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(filteredMovies[index]);
                        },
                      );
                    } else {
                      // Two-column grid layout for tablets/web (>= 800px)
                      return GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.8,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(filteredMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget method to build an individual movie card item
  Widget _buildMovieCard(Movie movie) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                movie.posterUrl,
                width: 90,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Year: ${movie.year} • ⭐ ${movie.rating}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.genres.join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}