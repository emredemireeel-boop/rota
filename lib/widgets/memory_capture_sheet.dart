import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../models/travel_memory.dart';
import '../models/memory_location.dart';
import '../screens/media_composer_screen.dart';
import '../services/interstitial_ad_service.dart';
import '../services/memory_store.dart';

export '../models/memory_location.dart';

Future<bool> showMemoryCaptureSheet(
  BuildContext context, {
  required MemoryLocation location,
  required Color accentColor,
}) async {
  final saved = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => MediaComposerScreen(
        initialLocation: location,
        accentColor: accentColor,
      ),
    ),
  );
  if (saved == true) {
    await RotaInterstitialAdService.instance.registerSuccessfulMediaSave();
  }
  return saved ?? false;
}

class _MemoryCaptureSheet extends StatefulWidget {
  final MemoryLocation location;
  final Color accentColor;

  const _MemoryCaptureSheet({
    required this.location,
    required this.accentColor,
  });

  @override
  State<_MemoryCaptureSheet> createState() => _MemoryCaptureSheetState();
}

class _MemoryCaptureSheetState extends State<_MemoryCaptureSheet> {
  final _picker = ImagePicker();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  Uint8List? _imageBytes;
  DateTime _date = DateTime.now();
  String _mood = 'Mutlu';
  bool _saving = false;

  static const _moods = <(String, String)>[
    ('Mutlu', '😊'),
    ('Huzurlu', '🌿'),
    ('Heyecanlı', '✨'),
    ('Macera', '🧭'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 72,
        requestFullMetadata: false,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      if (bytes.lengthInBytes > 4 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf çok büyük. Daha küçük bir fotoğraf seç.'),
          ),
        );
        return;
      }
      setState(() => _imageBytes = bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Kamera açılamadı. Galeriden seçim yapabilirsin.'
                : 'Fotoğraf seçilemedi. Lütfen tekrar dene.',
          ),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Anının tarihi',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _save() async {
    if (_imageBytes == null || _saving) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final location = widget.location;
    final memory = TravelMemory(
      id: '${now.microsecondsSinceEpoch}',
      scope: location.scope,
      title: _titleController.text.trim().isEmpty
          ? 'Güzel bir an'
          : _titleController.text.trim(),
      note: _noteController.text.trim(),
      capturedAt: DateTime(
        _date.year,
        _date.month,
        _date.day,
        now.hour,
        now.minute,
      ),
      imageBase64: base64Encode(_imageBytes!),
      mood: _mood,
      provincePlate: location.provincePlate,
      provinceName: location.provinceName,
      districtName: location.districtName,
      countryCode: location.countryCode,
      countryName: location.countryName,
      regionName: location.regionName,
    );
    await MemoryStore.instance.add(memory);
    if (mounted) Navigator.pop(context, true);
  }

  String get _dateLabel =>
      '${_date.day.toString().padLeft(2, '0')}.${_date.month.toString().padLeft(2, '0')}.${_date.year}';

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      constraints: const BoxConstraints(maxWidth: 620),
      padding: EdgeInsets.fromLTRB(20, 10, 20, bottomInset + 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: widget.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bu anı sakla',
                        style: GoogleFonts.outfit(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF172033),
                        ),
                      ),
                      Text(
                        widget.location.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_imageBytes == null)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_a_photo_rounded,
                      size: 42,
                      color: widget.accentColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Anın bir fotoğrafla başlasın',
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _PhotoButton(
                            icon: Icons.camera_alt_rounded,
                            label: 'Fotoğraf çek',
                            color: widget.accentColor,
                            filled: true,
                            onTap: () => _pick(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PhotoButton(
                            icon: Icons.photo_library_rounded,
                            label: 'Galeriden seç',
                            color: widget.accentColor,
                            onTap: () => _pick(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.memory(
                      _imageBytes!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.55),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => _imageBytes = null),
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Fotoğrafı değiştir',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Anının başlığı',
                hintText: 'Örn. Alaçatı’da gün batımı',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Kısa bir not',
                hintText: 'Bugünden aklında ne kalsın?',
                prefixIcon: Icon(Icons.edit_note_rounded),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Nasıl hissettin?',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((item) {
                final selected = item.$1 == _mood;
                return ChoiceChip(
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: widget.accentColor.withValues(alpha: 0.15),
                  side: BorderSide(
                    color: selected
                        ? widget.accentColor
                        : const Color(0xFFE2E8F0),
                  ),
                  label: Text('${item.$2} ${item.$1}'),
                  onSelected: (_) => setState(() => _mood = item.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: widget.accentColor,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Anının tarihi')),
                    Text(
                      _dateLabel,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                onPressed: _imageBytes == null || _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.bookmark_added_rounded),
                label: Text(
                  _saving ? 'Kaydediliyor...' : 'Anılarıma kaydet',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _PhotoButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return filled
        ? FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: onTap,
            icon: Icon(icon, size: 19),
            label: Text(label),
          )
        : OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color.withValues(alpha: 0.5)),
            ),
            onPressed: onTap,
            icon: Icon(icon, size: 19),
            label: Text(label),
          );
  }
}
