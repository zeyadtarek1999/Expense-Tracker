 import 'dart:io';
import 'package:flutter/material.dart';

class ReceiptViewerPage extends StatelessWidget {
  final String imagePath;
  final String? heroTag;

  const ReceiptViewerPage({
    super.key,
    required this.imagePath,
    this.heroTag,
  });

  static Future<void> open(
      BuildContext context, {
        required String imagePath,
        String? heroTag,
      }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ReceiptViewerPage(
          imagePath: imagePath,
          heroTag: heroTag,
        ),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  bool get _exists =>
      imagePath.trim().isNotEmpty && File(imagePath).existsSync();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: SafeArea(
          child: Stack(
            children: [
              Center(child: _exists ? _image() : _missing(context)),
              Positioned(
                left: 8,
                top: 8,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    final img = InteractiveViewer(
      minScale: 0.8,
      maxScale: 5,
      child: Image.file(File(imagePath), fit: BoxFit.contain),
    );
    if (heroTag == null || heroTag!.isEmpty) return img;
    return Hero(tag: heroTag!, child: img);
  }

  Widget _missing(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image_outlined, color: Colors.white70, size: 28),
          const SizedBox(height: 10),
          Text('Receipt not found',
              style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            imagePath.isEmpty ? 'No path provided.' : imagePath,
            style: t.bodySmall?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
