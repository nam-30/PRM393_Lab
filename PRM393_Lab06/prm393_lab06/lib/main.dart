import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// -----------------------------------------------------------------------------
// 1. MOVIE MODEL & SAMPLE DATA (Dữ liệu mẫu)
// -----------------------------------------------------------------------------
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

final List<Movie> sampleMovies = [
  const Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/inception/300/450',
    rating: 8.8,
  ),
  const Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/darkknight/300/450',
    rating: 9.0,
  ),
  const Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
    rating: 8.6,
  ),
  const Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/pulpfiction/300/450',
    rating: 8.9,
  ),
  const Movie(
    title: 'The Shawshank Redemption',
    year: 1994,
    genres: ['Drama'],
    posterUrl: 'https://picsum.photos/seed/shawshank/300/450',
    rating: 9.3,
  ),
  const Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/avengers/300/450',
    rating: 8.4,
  ),
  const Movie(
    title: 'La La Land',
    year: 2016,
    genres: ['Comedy', 'Drama', 'Music'],
    posterUrl: 'https://picsum.photos/seed/lalaland/300/450',
    rating: 8.0,
  ),
  const Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Adventure', 'Fantasy'],
    posterUrl: 'https://picsum.photos/seed/spiritedaway/300/450',
    rating: 8.6,
  ),
];

// -----------------------------------------------------------------------------
// 2. MAIN APP WIDGET
// -----------------------------------------------------------------------------
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Genre Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const GenreScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. GENRE SCREEN (STATEFUL WIDGET)
// -----------------------------------------------------------------------------
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Danh sách các thể loại phim khả dụng
  final List<String> allGenres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Drama',
    'Fantasy',
    'Music',
    'Sci-Fi',
    'Thriller',
  ];

  // Trạng thái (State variables)
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z'; // Giá trị: 'A-Z', 'Z-A', 'Year', 'Rating'

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Thuật toán Lọc và Sắp xếp danh sách phim
  List<Movie> get filteredAndSortedMovies {
    return sampleMovies.where((movie) {
      // 1. Lọc theo từ khóa tìm kiếm (không phân biệt hoa/thường)
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.trim().toLowerCase());

      // 2. Lọc theo thể loại đã chọn (chứa ít nhất 1 thể loại được chọn)
      final matchesGenre = selectedGenres.isEmpty ||
          selectedGenres.any((genre) => movie.genres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList()
      ..sort((a, b) {
        switch (selectedSort) {
          case 'Z-A':
            return b.title.compareTo(a.title);
          case 'Year':
            return b.year.compareTo(a.year); // Phim mới nhất lên đầu
          case 'Rating':
            return b.rating.compareTo(a.rating); // Đánh giá cao nhất lên đầu
          case 'A-Z':
          default:
            return a.title.compareTo(b.title);
        }
      });
  }

  // Đặt lại các bộ lọc
  void _clearFilters() {
    setState(() {
      searchQuery = '';
      _searchController.clear();
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = filteredAndSortedMovies;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Genre Browser'),
        elevation: 0,
        actions: [
          // Nút xóa bộ lọc trên AppBar khi đang lọc
          if (searchQuery.isNotEmpty || selectedGenres.isNotEmpty || selectedSort != 'A-Z')
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear Filters',
              onPressed: _clearFilters,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== LAB 6.1: HERO & HEADING ====================
              _buildHeroHeader(theme),
              const SizedBox(height: 16),

              // ==================== LAB 6.2: SEARCH, CHIPS & SORT ====================
              _buildSearchBar(theme),
              const SizedBox(height: 12),
              _buildGenreSection(theme),
              const SizedBox(height: 12),
              _buildSortAndResultBar(theme, movies.length),
              const SizedBox(height: 12),

              // ==================== LAB 6.3: RESPONSIVE LIST ====================
              Expanded(
                child: movies.isEmpty
                    ? _buildEmptyState()
                    : _buildResponsiveMovieList(movies),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPONENT LAB 6.1 ---
  Widget _buildHeroHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find a Movie',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Browse movies by title, genre, or rating seamlessly.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // --- COMPONENT LAB 6.2 ---
  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search movie by title...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              searchQuery = '';
            });
          },
        )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildGenreSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Genres',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Badge hiển thị số lượng thể loại đang chọn (Bonus)
            if (selectedGenres.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedGenres.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Sử dụng Wrap để tự động xuống dòng linh hoạt
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: allGenres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedGenres.add(genre);
                  } else {
                    selectedGenres.remove(genre);
                  }
                });
              },
              selectedColor: theme.colorScheme.primaryContainer,
              checkmarkColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortAndResultBar(ThemeData theme, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count movie${count == 1 ? '' : 's'} found',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.outline,
          ),
        ),
        Row(
          children: [
            const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            DropdownButton<String>(
              value: selectedSort,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'A-Z', child: Text('A–Z')),
                DropdownMenuItem(value: 'Z-A', child: Text('Z–A')),
                DropdownMenuItem(value: 'Year', child: Text('Year')),
                DropdownMenuItem(value: 'Rating', child: Text('Rating')),
              ],
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSort = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- COMPONENT LAB 6.3 ---
  Widget _buildResponsiveMovieList(List<Movie> movies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Điểm ngắt Responsive: 800px
        if (constraints.maxWidth >= 800) {
          // Màn hình rộng (Tablet/Web): Hiển thị Grid 2 cột
          return GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index], isGrid: true);
            },
          );
        } else {
          // Màn hình hẹp (Điện thoại): Hiển thị List 1 cột
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: MovieCard(movie: movies[index], isGrid: false),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_filter_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            'No movies found matching your criteria.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. MOVIE CARD WIDGET (Hiển thị thông tin từng bộ phim)
// -----------------------------------------------------------------------------
class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isGrid;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Ảnh Poster Phim
          SizedBox(
            width: isGrid ? 100 : 90,
            height: double.infinity,
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
          // Chi tiết Phim
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.year}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${movie.rating}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Thẻ thể loại nhỏ bên trong card
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: movie.genres.map((g) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}