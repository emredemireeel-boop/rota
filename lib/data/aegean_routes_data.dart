class AegeanRoute {
  final String title;
  final String subtitle;
  final String duration;
  final String bestSeason;
  final List<String> districts;
  final List<String> highlights;

  const AegeanRoute({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.bestSeason,
    required this.districts,
    required this.highlights,
  });
}

const Map<int, List<AegeanRoute>> aegeanRoutes = {
  3: [
    AegeanRoute(
      title: 'Frig Vadisi Rotası',
      subtitle: 'Kaya anıtları, tüf vadiler ve sessiz köyler',
      duration: '1–2 gün',
      bestSeason: 'İlkbahar',
      districts: ['İhsaniye', 'Bayat'],
      highlights: ['Ayazini', 'Emre Gölü', 'Aslantaş', 'Frig yürüyüş yolu'],
    ),
    AegeanRoute(
      title: 'Termal Ege',
      subtitle: 'Şifalı sular ve sakin kasaba molaları',
      duration: '2 gün',
      bestSeason: 'Sonbahar–Kış',
      districts: ['Merkez', 'Sandıklı', 'Bolvadin'],
      highlights: ['Gazlıgöl', 'Hüdai Kaplıcaları', 'Afyon Kalesi'],
    ),
  ],
  9: [
    AegeanRoute(
      title: 'Antik Menderes',
      subtitle: 'Vadinin hafızasını antik kentlerle takip et',
      duration: '2 gün',
      bestSeason: 'İlkbahar',
      districts: ['Sultanhisar', 'Karacasu', 'Söke'],
      highlights: ['Nysa', 'Aphrodisias', 'Priene', 'Bafa Gölü'],
    ),
    AegeanRoute(
      title: 'Kıyı ve Gün Batımı',
      subtitle: 'Sahil, marina ve uzun akşam sofraları',
      duration: '2–3 gün',
      bestSeason: 'Mayıs–Ekim',
      districts: ['Kuşadası', 'Didim'],
      highlights: ['Güvercinada', 'Dilek Yarımadası', 'Altınkum', 'Apollon'],
    ),
  ],
  20: [
    AegeanRoute(
      title: 'Beyaz Traverten Rotası',
      subtitle: 'Antik havuzlardan gün batımına',
      duration: '1 gün',
      bestSeason: 'Dört mevsim',
      districts: ['Pamukkale'],
      highlights: [
        'Travertenler',
        'Hierapolis',
        'Kleopatra Havuzu',
        'Laodikeia',
      ],
    ),
    AegeanRoute(
      title: 'Bağlar ve Dokuma',
      subtitle: 'Üzüm bağları, taş evler ve Buldan bezleri',
      duration: '2 gün',
      bestSeason: 'Eylül–Ekim',
      districts: ['Buldan', 'Çal', 'Bekilli'],
      highlights: ['Buldan evleri', 'Tripolis', 'Çal bağ yolu', 'Şarap tadımı'],
    ),
  ],
  35: [
    AegeanRoute(
      title: 'Yarımada Lezzet Hattı',
      subtitle: 'Bağ yolu, enginar, sakız ve rüzgâr',
      duration: '3 gün',
      bestSeason: 'Nisan–Haziran',
      districts: ['Urla', 'Çeşme', 'Karaburun'],
      highlights: ['Urla Bağ Yolu', 'Alaçatı', 'Ildırı', 'Sarpıncık Feneri'],
    ),
    AegeanRoute(
      title: 'Kuzey İzmir',
      subtitle: 'Antik taşlar ve dingin kıyı kasabaları',
      duration: '2 gün',
      bestSeason: 'Mayıs–Eylül',
      districts: ['Bergama', 'Dikili', 'Foça'],
      highlights: ['Pergamon', 'Bademli koyları', 'Eski Foça', 'Kozak Yaylası'],
    ),
    AegeanRoute(
      title: 'Küçük Menderes',
      subtitle: 'Efes’ten Birgi’nin ahşap konaklarına',
      duration: '2 gün',
      bestSeason: 'İlkbahar',
      districts: ['Selçuk', 'Tire', 'Ödemiş'],
      highlights: ['Efes', 'Şirince', 'Tire pazarı', 'Birgi'],
    ),
  ],
  43: [
    AegeanRoute(
      title: 'Antik ve Termal Kütahya',
      subtitle: 'Roma kalıntıları ile sıcak su kaynakları',
      duration: '2 gün',
      bestSeason: 'Sonbahar',
      districts: ['Çavdarhisar', 'Emet'],
      highlights: ['Aizanoi', 'Zeus Tapınağı', 'Emet kaplıcaları'],
    ),
    AegeanRoute(
      title: 'İç Ege Doğa Rotası',
      subtitle: 'Göller, yaylalar ve çini ustalarının izleri',
      duration: '2 gün',
      bestSeason: 'İlkbahar–Yaz',
      districts: ['Simav', 'Gediz', 'Merkez'],
      highlights: ['Simav Gölü', 'Murat Dağı', 'Çini atölyeleri'],
    ),
  ],
  45: [
    AegeanRoute(
      title: 'Lidya’dan Yanık Ülke’ye',
      subtitle: 'Paranın doğduğu topraklardan volkanik jeoparka',
      duration: '2 gün',
      bestSeason: 'İlkbahar–Sonbahar',
      districts: ['Salihli', 'Alaşehir', 'Kula'],
      highlights: ['Sardes', 'Bintepeler', 'Philadelphia', 'Kula Jeoparkı'],
    ),
    AegeanRoute(
      title: 'Zeytin ve Kuzey Manisa',
      subtitle: 'Zeytin ovaları, köfte ve tarihi kasabalar',
      duration: '1–2 gün',
      bestSeason: 'Ekim–Kasım',
      districts: ['Akhisar', 'Kırkağaç', 'Soma'],
      highlights: ['Thyateira', 'Zeytin hasadı', 'Darkale Köyü'],
    ),
  ],
  48: [
    AegeanRoute(
      title: 'Mavi Yarımada',
      subtitle: 'Beyaz evler, saklı koylar ve antik limanlar',
      duration: '4 gün',
      bestSeason: 'Mayıs–Ekim',
      districts: ['Bodrum', 'Datça', 'Marmaris'],
      highlights: ['Bodrum Kalesi', 'Knidos', 'Selimiye', 'Bozburun'],
    ),
    AegeanRoute(
      title: 'Likya’nın Ucunda',
      subtitle: 'Kanyonlardan lagünlere uzanan macera',
      duration: '3 gün',
      bestSeason: 'Nisan–Haziran',
      districts: ['Fethiye', 'Seydikemer'],
      highlights: ['Ölüdeniz', 'Kayaköy', 'Saklıkent', 'Kabak Koyu'],
    ),
    AegeanRoute(
      title: 'Göller ve Deltalar',
      subtitle: 'Sığla ormanları, sazlıklar ve caretta izleri',
      duration: '2 gün',
      bestSeason: 'Nisan–Ekim',
      districts: ['Köyceğiz', 'Ortaca', 'Dalaman'],
      highlights: ['Köyceğiz Gölü', 'İztuzu', 'Kaunos', 'Sarsala Koyu'],
    ),
  ],
  64: [
    AegeanRoute(
      title: 'Kanyon ve Tarih',
      subtitle: 'Cam terastan antik Blaundos’a',
      duration: '1 gün',
      bestSeason: 'İlkbahar–Sonbahar',
      districts: ['Ulubey', 'Merkez'],
      highlights: ['Ulubey Kanyonu', 'Blaundos', 'Uşak Arkeoloji Müzesi'],
    ),
    AegeanRoute(
      title: 'İç Ege Dokusu',
      subtitle: 'Kilim, taş ev ve yayla manzaraları',
      duration: '1–2 gün',
      bestSeason: 'Yaz–Sonbahar',
      districts: ['Eşme', 'Banaz', 'Sivaslı'],
      highlights: ['Eşme kilimleri', 'Hamamboğazı', 'Sebaste'],
    ),
  ],
};
