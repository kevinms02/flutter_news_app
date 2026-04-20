import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/post.dart';

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: Column(
        children: [
          // ── Fixed Header ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 14,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                // Back button – kiri tengah
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 18),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Title – centered
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.newspaper_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Detail Berita',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Spacer to balance the back button width
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Scrollable Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge ID
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'BERITA #${post.id}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1565C0),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Judul
                  Text(
                    post.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B4B),
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Divider
                  Divider(
                    color: Colors.blue.shade100,
                    thickness: 1.5,
                  ),

                  const SizedBox(height: 12),

                  // Label isi
                  Row(
                    children: [
                      const Icon(Icons.format_quote_rounded,
                          color: Color(0xFF64B5F6), size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Isi Berita',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64B5F6),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Isi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      post.body,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: const Color(0xFF37474F),
                        height: 1.75,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
