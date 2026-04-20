import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/api_service.dart';
import '../model/post.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;

  TextEditingController controller = TextEditingController();
  List<Post> allPosts = [];
  List<Post> filtered = [];
  bool isSortedAZ = false;

  @override
  void initState() {
    super.initState();
    futurePosts = ApiService.fetchPosts();
    futurePosts.then((data) {
      setState(() {
        allPosts = data;
        _applySearchAndFilter();
      });
    });
  }

  void search(String keyword) {
    _applySearchAndFilter();
  }

  void _applySearchAndFilter() {
    setState(() {
      filtered = allPosts.where((p) {
        return p.title.toLowerCase().contains(controller.text.toLowerCase());
      }).toList();

      if (isSortedAZ) {
        filtered.sort((a, b) => a.title.compareTo(b.title));
      } else {
        filtered.sort((a, b) => b.id.compareTo(a.id));
      }
    });
  }

  void _toggleFilter() {
    setState(() {
      isSortedAZ = !isSortedAZ;
      _applySearchAndFilter();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSortedAZ ? 'Urutkan: A - Z' : 'Urutkan: Terbaru'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _cardAccentColor(int index) {
    const colors = [
      Color(0xFF64B5F6),
      Color(0xFF81C784),
      Color(0xFFFFB74D),
      Color(0xFFF06292),
      Color(0xFF9575CD),
      Color(0xFF4DD0E1),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: Column(
        children: [
          // ── Fixed Header (tidak terlipat saat scroll) ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.newspaper, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Kevin News',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Berita Terkini',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: TextField(
              controller: controller,
              onChanged: search,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF64B5F6),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isSortedAZ ? Icons.sort_by_alpha : Icons.tune,
                    color: isSortedAZ
                        ? const Color(0xFF1E88E5)
                        : Colors.grey.shade400,
                  ),
                  onPressed: _toggleFilter,
                ),
              ),
            ),
          ),

          // ── Jumlah hasil ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} berita ditemukan',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          // ── Grid Berita (scrollable area) ──
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF64B5F6),
                      strokeWidth: 3,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat berita',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive columns based on available width
                      final width = constraints.maxWidth;
                      int crossAxisCount;
                      if (width >= 1200) {
                        crossAxisCount = 6;
                      } else if (width >= 900) {
                        crossAxisCount = 5;
                      } else if (width >= 600) {
                        crossAxisCount = 4;
                      } else if (width >= 400) {
                        crossAxisCount = 3;
                      } else {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final post = filtered[index];
                          final accent = _cardAccentColor(index);

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(post: post),
                              ),
                            ),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Header card berwarna (≈ setengah card) ──
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accent,
                                            accent.withValues(alpha: 0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.article_rounded,
                                          size: 42,
                                          color: Colors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ),
                                  ),


                                  // ── Bottom half: info ──
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Badge nomor
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: accent.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'BERITA #${post.id}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600,
                                                color: accent,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),

                                          // Judul
                                          Expanded(
                                            child: Text(
                                              post.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1A237E),
                                                height: 1.3,
                                              ),
                                            ),
                                          ),

                                          // Footer tombol baca
                                          Row(
                                            children: [
                                              Text(
                                                'Baca selengkapnya',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 9,
                                                  color: accent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 8,
                                                color: accent,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
