import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/travel_memory.dart';

class MemoryMediaThumbnail extends StatelessWidget {
  final TravelMemory memory;
  final double? width;
  final double? height;
  final BoxFit fit;

  const MemoryMediaThumbnail({
    super.key,
    required this.memory,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (memory.isVideo) {
      return _VideoFrameThumbnail(
        mediaPath: memory.mediaPath,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (memory.mediaPath.isNotEmpty) {
      return Image.file(
        File(memory.mediaPath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: _errorBuilder,
      );
    }

    if (memory.imageBase64.isNotEmpty) {
      return Image.memory(
        memory.imageBytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: _errorBuilder,
      );
    }

    return _errorBuilder(context, StateError('Medya yok'), null);
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE2E8F0),
      child: const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}

class _VideoFrameThumbnail extends StatefulWidget {
  final String mediaPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _VideoFrameThumbnail({
    required this.mediaPath,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  State<_VideoFrameThumbnail> createState() => _VideoFrameThumbnailState();
}

class _VideoFrameThumbnailState extends State<_VideoFrameThumbnail> {
  static const _cacheLimit = 120;
  static final Map<String, Future<Uint8List?>> _thumbnailCache = {};

  late Future<Uint8List?> _thumbnail;

  @override
  void initState() {
    super.initState();
    _thumbnail = _loadFrame();
  }

  @override
  void didUpdateWidget(covariant _VideoFrameThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaPath != widget.mediaPath) {
      _thumbnail = _loadFrame();
    }
  }

  Future<Uint8List?> _loadFrame() {
    if (widget.mediaPath.isEmpty || !File(widget.mediaPath).existsSync()) {
      return Future.value();
    }

    final cached = _thumbnailCache[widget.mediaPath];
    if (cached != null) return cached;

    if (_thumbnailCache.length >= _cacheLimit) {
      _thumbnailCache.remove(_thumbnailCache.keys.first);
    }
    final future = VideoThumbnail.thumbnailData(
      video: widget.mediaPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 720,
      timeMs: 500,
      quality: 82,
    ).catchError((Object _) => null);
    _thumbnailCache[widget.mediaPath] = future;
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _thumbnail,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(
            bytes,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            gaplessPlayback: true,
          );
        }
        return _fallback(
          loading: snapshot.connectionState != ConnectionState.done,
        );
      },
    );
  }

  Widget _fallback({required bool loading}) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C2F3A), Color(0xFF315767)],
        ),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.videocam_off_outlined,
                size: 34,
                color: Colors.white,
              ),
      ),
    );
  }
}

Future<void> showMemoryMediaViewer(BuildContext context, TravelMemory memory) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _MemoryMediaViewer(memory: memory),
    ),
  );
}

class _MemoryMediaViewer extends StatefulWidget {
  final TravelMemory memory;

  const _MemoryMediaViewer({required this.memory});

  @override
  State<_MemoryMediaViewer> createState() => _MemoryMediaViewerState();
}

class _MemoryMediaViewerState extends State<_MemoryMediaViewer> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    if (widget.memory.isVideo && widget.memory.mediaPath.isNotEmpty) {
      _controller = VideoPlayerController.file(File(widget.memory.mediaPath));
      _initialization = _controller!.initialize().then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.memory.title),
      ),
      body: Center(
        child: widget.memory.isVideo
            ? _buildVideo()
            : InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: MemoryMediaThumbnail(
                  memory: widget.memory,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
      ),
      floatingActionButton:
          widget.memory.isVideo && _controller?.value.isInitialized == true
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller!.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            )
          : null,
    );
  }

  Widget _buildVideo() {
    if (_controller == null || _initialization == null) {
      return const Text(
        'Video dosyası bulunamadı.',
        style: TextStyle(color: Colors.white),
      );
    }
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        return AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        );
      },
    );
  }
}
