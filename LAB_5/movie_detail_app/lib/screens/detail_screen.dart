import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Function to show a rating dialog allowing users to pick 1 to 5 stars
  void _showRatingDialog(BuildContext context) {
    int tempRating = widget.movie.userRating ?? 5;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate this Movie'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starValue = index + 1;
                  return IconButton(
                    icon: Icon(
                      starValue <= tempRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setStateDialog(() {
                        tempRating = starValue;
                      });
                    },
                  );
                }),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.movie.userRating = tempRating;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Rated $tempRating stars successfully!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar displaying the movie title
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner with Image and Gradient Overlay
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Movie poster header image
                Image.network(
                  widget.movie.posterUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay to enhance text readability over the image
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Movie title displayed over the banner
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Genres displayed as Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: widget.movie.genres.map((genre) {
                  return Chip(
                    label: Text(genre),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Overview Text section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.movie.overview,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Action Buttons (Favorite / Rate / Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Favorite button with state toggle functionality
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.movie.isFavorite = !widget.movie.isFavorite;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.movie.isFavorite
                              ? 'Added to Favorites'
                              : 'Removed from Favorites',
                        ),
                        duration: const Duration(milliseconds: 800),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: widget.movie.isFavorite ? Colors.red : Colors.grey[800],
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      const Text('Favorite', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                // Rate action button showing dynamic star text
                InkWell(
                  onTap: () => _showRatingDialog(context),
                  child: Column(
                    children: [
                      Icon(
                        Icons.star,
                        // Turns amber/yellow if user has rated, otherwise dark grey
                        color: widget.movie.userRating != null ? Colors.amber : Colors.grey[800],
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      // Dynamically display rating text: e.g. "3 stars" or "Rate"
                      Text(
                        widget.movie.userRating == null
                            ? 'Rate'
                            : '${widget.movie.userRating} ${widget.movie.userRating == 1 ? 'star' : 'stars'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Share action button with 'Link copied successfully!' message
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied successfully!'),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.share, color: Colors.grey[800], size: 28),
                      const SizedBox(height: 6),
                      const Text('Share', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),

            // 5. Trailers Section Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Trailers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // List of trailers using ListView.builder nested safely inside SingleChildScrollView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling conflicts
              itemCount: widget.movie.trailers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text(widget.movie.trailers[index]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Playing: ${widget.movie.trailers[index]}')),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}