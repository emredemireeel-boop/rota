import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../data/passport_data.dart';
import '../data/turkey_data.dart';
import '../models/memory_location.dart';
import '../models/travel_memory.dart';
import '../services/location_resolver.dart';
import '../services/media_storage.dart';
import '../services/memory_store.dart';

class MediaComposerScreen extends StatefulWidget {
  final MemoryLocation? initialLocation;
  final Color accentColor;

  const MediaComposerScreen({
    super.key,
    this.initialLocation,
    this.accentColor = const Color(0xFF183D3D),
  });

  @override
  State<MediaComposerScreen> createState() => _MediaComposerScreenState();
}

class _MediaComposerScreenState extends State<MediaComposerScreen> {
  final _picker = ImagePicker();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  XFile? _pickedMedia;
  TravelMediaType _mediaType = TravelMediaType.image;
  VideoPlayerController? _videoController;
  int _step = 0;
  bool _saving = false;
  String _countryCode = 'TR';
  int? _provincePlate;
  String? _district;
  String _mood = 'Mutlu';
  DateTime _date = DateTime.now();

  static const _moods = <(String, String)>[
    ('Mutlu', '😊'),
    ('Huzurlu', '🌿'),
    ('Heyecanlı', '✨'),
    ('Macera', '🧭'),
  ];

  @override
  void initState() {
    super.initState();
    final location = widget.initialLocation;
    if (location != null) {
      _countryCode = location.scope == MemoryScope.turkey
          ? 'TR'
          : location.countryCode ?? 'TR';
      _provincePlate = location.provincePlate;
      if (location.districtName != null && location.districtName != 'Genel') {
        _district = location.districtName;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  List<_CountryChoice> get _countries {
    final choices = <String, _CountryChoice>{
      'TR': const _CountryChoice('TR', 'Türkiye', '🇹🇷'),
    };
    for (final country in passportCountries) {
      choices.putIfAbsent(
        country.code,
        () => _CountryChoice(country.code, country.name, country.flag),
      );
    }
    final result = choices.values.toList();
    result.sort((a, b) {
      if (a.code == 'TR') return -1;
      if (b.code == 'TR') return 1;
      return a.name.compareTo(b.name);
    });
    return result;
  }

  _CountryChoice get _selectedCountry => _countries.firstWhere(
    (country) => country.code == _countryCode,
    orElse: () => const _CountryChoice('TR', 'Türkiye', '🇹🇷'),
  );

  Province? get _selectedProvince {
    if (_provincePlate == null) return null;
    final matches = turkeyProvinces.where(
      (province) => province.plateCode == _provincePlate,
    );
    return matches.isEmpty ? null : matches.first;
  }

  Future<void> _pickMedia(TravelMediaType type, ImageSource source) async {
    try {
      final XFile? file;
      if (type == TravelMediaType.video) {
        file = await _picker.pickVideo(
          source: source,
          maxDuration: const Duration(minutes: 3),
        );
      } else {
        file = await _picker.pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 82,
          requestFullMetadata: false,
        );
      }
      if (file == null || !mounted) return;

      await _videoController?.dispose();
      _videoController = null;
      if (type == TravelMediaType.video) {
        final controller = VideoPlayerController.file(File(file.path));
        await controller.initialize();
        _videoController = controller;
      }

      setState(() {
        _pickedMedia = file;
        _mediaType = type;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medya açılamadı. Lütfen tekrar dene.')),
      );
    }
  }

  Future<void> _chooseCountry() async {
    final selected = await showSearch<_CountryChoice?>(
      context: context,
      delegate: _CountrySearchDelegate(_countries),
    );
    if (selected == null) return;
    setState(() {
      _countryCode = selected.code;
      if (_countryCode != 'TR') {
        _provincePlate = null;
        _district = null;
      }
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Anının tarihi',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _save() async {
    if (_pickedMedia == null || _saving) return;
    if (!_formKey.currentState!.validate()) return;
    if (_countryCode == 'TR' && (_provincePlate == null || _district == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Türkiye için il ve ilçe zorunludur.')),
      );
      return;
    }

    setState(() => _saving = true);
    String persistedPath = '';
    try {
      final country = _selectedCountry;
      final province = _selectedProvince;
      final coordinates = await LocationResolver.resolve(
        countryName: country.name,
        provinceName: province?.name,
        districtName: _district,
      );
      persistedPath = await MediaStorage.persist(_pickedMedia!, _mediaType);

      final now = DateTime.now();
      final defaultTitle = _mediaType == TravelMediaType.video
          ? 'Bir rota videosu'
          : 'Güzel bir an';
      final memory = TravelMemory(
        id: '${now.microsecondsSinceEpoch}',
        scope: _countryCode == 'TR' ? MemoryScope.turkey : MemoryScope.world,
        title: _titleController.text.trim().isEmpty
            ? defaultTitle
            : _titleController.text.trim(),
        note: _noteController.text.trim(),
        capturedAt: DateTime(
          _date.year,
          _date.month,
          _date.day,
          now.hour,
          now.minute,
        ),
        mediaPath: persistedPath,
        mediaType: _mediaType,
        mood: _mood,
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        provincePlate: province?.plateCode,
        provinceName: province?.name,
        districtName: _district,
        countryCode: _countryCode,
        countryName: country.name,
        regionName: _countryCode == 'TR' ? null : 'Genel',
      );
      await MemoryStore.instance.add(memory);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      await MediaStorage.remove(persistedPath);
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medya kaydedilemedi. Lütfen tekrar dene.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3EE),
        title: Text(
          _step == 0 ? 'Fotoğraf & Video' : 'Konumu ve anıyı tamamla',
        ),
        leading: IconButton(
          onPressed: () {
            if (_step == 1) {
              setState(() => _step = 0);
            } else {
              Navigator.pop(context, false);
            }
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: _step == 0 ? _buildMediaStep() : _buildLocationStep(),
      ),
    );
  }

  Widget _buildMediaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anını seç',
            style: GoogleFonts.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF183D3D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Yeni bir kare çekebilir veya galerindeki fotoğraf ve videolardan seçebilirsin.',
            style: GoogleFonts.inter(
              height: 1.45,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          if (_pickedMedia == null)
            _MediaSourceGrid(
              accentColor: widget.accentColor,
              onSelected: _pickMedia,
            )
          else ...[
            _buildPickedPreview(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _pickedMedia = null);
                      _videoController?.pause();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Değiştir'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.accentColor,
                    ),
                    onPressed: () {
                      _videoController?.pause();
                      setState(() => _step = 1);
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Bu medyayı kullan'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPickedPreview() {
    if (_mediaType == TravelMediaType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(
          File(_pickedMedia!.path),
          width: double.infinity,
          height: 390,
          fit: BoxFit.cover,
        ),
      );
    }
    final controller = _videoController!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                iconSize: 34,
              ),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
              icon: Icon(
                controller.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    final province = _selectedProvince;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF183D3D),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Icon(
                    _mediaType == TravelMediaType.video
                        ? Icons.videocam_rounded
                        : Icons.photo_camera_rounded,
                    color: const Color(0xFFFFD166),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Medya hazır • şimdi haritadaki yerini seç',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Ülke',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 7),
            InkWell(
              onTap: _chooseCountry,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDE3EA)),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedCountry.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedCountry.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.search_rounded),
                  ],
                ),
              ),
            ),
            if (_countryCode == 'TR') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _provincePlate,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'İl *',
                  prefixIcon: Icon(Icons.location_city_rounded),
                ),
                items: turkeyProvinces
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.plateCode,
                        child: Text('${item.plateCode} • ${item.name}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _provincePlate = value;
                    _district = null;
                  });
                },
                validator: (value) => value == null ? 'İl seçmelisin' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: province?.districts.contains(_district) == true
                    ? _district
                    : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'İlçe *',
                  prefixIcon: Icon(Icons.place_rounded),
                ),
                items: (province?.districts ?? const <String>[])
                    .map(
                      (district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ),
                    )
                    .toList(),
                onChanged: province == null
                    ? null
                    : (value) => setState(() => _district = value),
                validator: (value) => value == null ? 'İlçe seçmelisin' : null,
              ),
            ] else ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D6A)),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Türkiye dışındaki ülkelerde il ve ilçe zorunlu değildir.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Anının başlığı',
                hintText: 'Örn. Datça’da gün batımı',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Kısa bir not',
                hintText: 'Bugünden aklında ne kalsın?',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((item) {
                final selected = _mood == item.$1;
                return ChoiceChip(
                  label: Text('${item.$2} ${item.$1}'),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _mood = item.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: Icon(
                Icons.calendar_month_rounded,
                color: widget.accentColor,
              ),
              title: const Text('Anının tarihi'),
              trailing: Text(
                '${_date.day.toString().padLeft(2, '0')}.'
                '${_date.month.toString().padLeft(2, '0')}.${_date.year}',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: widget.accentColor,
                ),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_location_alt_rounded),
                label: Text(
                  _saving ? 'Haritaya ekleniyor...' : 'Haritaya kaydet',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaSourceGrid extends StatelessWidget {
  final Color accentColor;
  final Future<void> Function(TravelMediaType, ImageSource) onSelected;

  const _MediaSourceGrid({required this.accentColor, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.96,
      children: [
        _SourceCard(
          icon: Icons.camera_alt_rounded,
          title: 'Fotoğraf çek',
          subtitle: 'Kamerayı aç',
          color: accentColor,
          onTap: () => onSelected(TravelMediaType.image, ImageSource.camera),
        ),
        _SourceCard(
          icon: Icons.photo_library_rounded,
          title: 'Fotoğraf seç',
          subtitle: 'Galeriden ekle',
          color: const Color(0xFFB56D40),
          onTap: () => onSelected(TravelMediaType.image, ImageSource.gallery),
        ),
        _SourceCard(
          icon: Icons.videocam_rounded,
          title: 'Video çek',
          subtitle: '3 dakikaya kadar',
          color: const Color(0xFF365E9D),
          onTap: () => onSelected(TravelMediaType.video, ImageSource.camera),
        ),
        _SourceCard(
          icon: Icons.video_library_rounded,
          title: 'Video seç',
          subtitle: 'Galeriden ekle',
          color: const Color(0xFF7A4D8B),
          onTap: () => onSelected(TravelMediaType.video, ImageSource.gallery),
        ),
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, size: 29, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF203332),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF7A8584),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryChoice {
  final String code;
  final String name;
  final String flag;

  const _CountryChoice(this.code, this.name, this.flag);
}

class _CountrySearchDelegate extends SearchDelegate<_CountryChoice?> {
  final List<_CountryChoice> countries;

  _CountrySearchDelegate(this.countries);

  @override
  String get searchFieldLabel => 'Ülke ara';

  List<_CountryChoice> get _filtered {
    final normalized = query.toLowerCase().trim();
    if (normalized.isEmpty) return countries;
    return countries
        .where(
          (country) =>
              country.name.toLowerCase().contains(normalized) ||
              country.code.toLowerCase() == normalized,
        )
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close_rounded),
      ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back_rounded),
  );

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    return ListView.builder(
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final country = _filtered[index];
        return ListTile(
          leading: Text(country.flag, style: const TextStyle(fontSize: 25)),
          title: Text(country.name),
          trailing: Text(country.code),
          onTap: () => close(context, country),
        );
      },
    );
  }
}
