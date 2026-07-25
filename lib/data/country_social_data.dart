// Country social data - regions, food, places, safety info
// Starting with Turkey's neighbors

class CountrySocialInfo {
  final String safetyLevel;
  final double humanFriendliness;
  final double happinessIndex;
  final List<String> famousFoods;
  final List<String> places;
  final List<String> interestingFacts;
  final String socialInfo;
  final String capital;
  final String currency;
  final String language;
  final String population;
  final List<String> regions; // States/provinces/regions

  const CountrySocialInfo({
    required this.safetyLevel,
    required this.humanFriendliness,
    required this.happinessIndex,
    required this.famousFoods,
    required this.places,
    required this.interestingFacts,
    required this.socialInfo,
    required this.capital,
    required this.currency,
    required this.language,
    required this.population,
    this.regions = const [],
  });
}

class RegionSocialInfo {
  final String safetyLevel;
  final double humanFriendliness;
  final double happinessIndex;
  final List<String> famousFoods;
  final List<String> places;
  final List<String> interestingFacts;
  final String socialInfo;

  const RegionSocialInfo({
    required this.safetyLevel,
    required this.humanFriendliness,
    required this.happinessIndex,
    required this.famousFoods,
    required this.places,
    required this.interestingFacts,
    required this.socialInfo,
  });
}

CountrySocialInfo getCountrySocialInfo(String countryCode) {
  return _countrySocialData[countryCode] ?? _defaultCountryInfo;
}

RegionSocialInfo getRegionSocialInfo(String countryCode, String regionName) {
  final regionMap = _regionSocialData[countryCode];
  if (regionMap != null && regionMap.containsKey(regionName)) {
    return regionMap[regionName]!;
  }
  final country = getCountrySocialInfo(countryCode);
  return RegionSocialInfo(
    safetyLevel: country.safetyLevel,
    humanFriendliness: country.humanFriendliness,
    happinessIndex: country.happinessIndex,
    famousFoods: country.famousFoods,
    places: country.places,
    interestingFacts: country.interestingFacts,
    socialInfo: country.socialInfo,
  );
}

const _defaultCountryInfo = CountrySocialInfo(
  safetyLevel: 'Ortalama',
  humanFriendliness: 6.0,
  happinessIndex: 5.5,
  famousFoods: ['Yöresel mutfak'],
  places: ['Şehir merkezi'],
  interestingFacts: ['Keşfedilmeyi bekleyen bir ülke'],
  socialInfo: 'Genel bilgi mevcut değil.',
  capital: '-',
  currency: '-',
  language: '-',
  population: '-',
);

// Country code -> social data
const Map<String, CountrySocialInfo> _countrySocialData = {
  // Yunanistan
  'GR': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 6.5,
    famousFoods: [
      'Moussaka',
      'Souvlaki',
      'Gyros',
      'Feta peyniri',
      'Baklava',
      'Tzatziki',
    ],
    places: [
      'Atina Akropolisi',
      'Santorini',
      'Mykonos',
      'Meteora Manastırları',
      'Olimpos',
    ],
    interestingFacts: [
      'Demokrasinin doğduğu yer',
      '6000+ ada',
      'Avrupa\'nın en eski medeniyetlerinden',
      'Olimpiyat oyunlarının doğum yeri',
    ],
    socialInfo:
        'Akdeniz kültürü, rahat yaşam tarzı. Turizm ekonominin bel kemiği. İnsanlar sıcakkanlı ve misafirperver.',
    capital: 'Atina',
    currency: 'Euro (€)',
    language: 'Yunanca',
    population: '10.4M',
    regions: [
      'Attika',
      'Selanik',
      'Girit',
      'Peloponez',
      'Makedonya',
      'Trakya',
      'Teselya',
      'Epir',
    ],
  ),
  // Bulgaristan
  'BG': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 6.5,
    happinessIndex: 5.5,
    famousFoods: [
      'Shopska Salatası',
      'Banitza',
      'Kebapche',
      'Sirene peyniri',
      'Tarator',
    ],
    places: [
      'Sofya Alexander Nevsky Katedrali',
      'Rila Manastırı',
      'Plovdiv Eski Şehir',
      'Sunny Beach',
      'Veliko Tırnovo',
    ],
    interestingFacts: [
      'AB\'nin en ucuz ülkesi',
      'Gül yağı üretiminde dünya lideri',
      'Kiril alfabesi Bulgaristan\'da icat edildi',
    ],
    socialInfo:
        'Balkan kültürü, muhafazakar ama misafirperver. Yaşam maliyeti çok düşük. Türk azınlık önemli bir topluluk.',
    capital: 'Sofya',
    currency: 'Lev (лв)',
    language: 'Bulgarca',
    population: '6.5M',
    regions: [
      'Sofya',
      'Plovdiv',
      'Varna',
      'Burgaz',
      'Ruse',
      'Stara Zagora',
      'Pleven',
    ],
  ),
  // Gürcistan
  'GE': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 9.0,
    happinessIndex: 6.5,
    famousFoods: [
      'Hinkali',
      'Haçapuri',
      'Lobio',
      'Churchkhela',
      'Gürcü şarabı',
    ],
    places: [
      'Tiflis Eski Şehir',
      'Kazbegi Dağı',
      'Batumi',
      'Svaneti',
      'Mtskheta',
    ],
    interestingFacts: [
      'Şarabın anavatanı (8000 yıl)',
      'Kafkas dağlarının manzaralı ülkesi',
      'Dünyanın en eski katedrallerinden birine sahip',
    ],
    socialInfo:
        'Çok misafirperver, sofra kültürü güçlü. "Tamada" geleneği (sofra başı). Türklerle tarihi bağlar güçlü.',
    capital: 'Tiflis',
    currency: 'Lari (₾)',
    language: 'Gürcüce',
    population: '3.7M',
    regions: [
      'Tiflis',
      'Acara (Batum)',
      'Kakheti',
      'İmereti',
      'Svaneti',
      'Mtskheta-Mtianeti',
    ],
  ),
  // İran
  'IR': CountrySocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 8.5,
    happinessIndex: 5.0,
    famousFoods: [
      'Kebab Koobideh',
      'Ghormeh Sabzi',
      'Tahdig',
      'Fesenjan',
      'Doogh',
      'Şafran pilavı',
    ],
    places: [
      'İsfahan Nakş-ı Cihan Meydanı',
      'Şiraz Nasır al-Molk Camii',
      'Persepolis',
      'Tahran Büyük Çarşı',
      'Yezd Eski Şehir',
    ],
    interestingFacts: [
      'Dünyanın en eski medeniyetlerinden (Pers İmparatorluğu)',
      'Şafran üretiminde dünya lideri',
      'Halı dokumacılığında dünya markası',
    ],
    socialInfo:
        'Çok misafirperver insanlar. Devlet ile halk arasında büyük fark var. Turistlere karşı son derece cana yakın.',
    capital: 'Tahran',
    currency: 'Riyal (﷼)',
    language: 'Farsça',
    population: '88M',
    regions: [
      'Tahran',
      'İsfahan',
      'Şiraz',
      'Tebriz',
      'Meşhed',
      'Yezd',
      'Kirman',
    ],
  ),
  // Irak
  'IQ': CountrySocialInfo(
    safetyLevel: 'Tehlikeli',
    humanFriendliness: 7.5,
    happinessIndex: 4.0,
    famousFoods: [
      'Masgouf (ızgara balık)',
      'Dolma',
      'Kubba',
      'Tirit',
      'Irak çayı',
    ],
    places: [
      'Erbil Kalesi',
      'Bağdat Mutanabbı Caddesi',
      'Kerbela',
      'Necef',
      'Kürt bölgesi dağları',
    ],
    interestingFacts: [
      'Mezopotamya medeniyetinin beşiği',
      'Babil Asma Bahçeleri buradaydı',
      'Kürt bölgesi nispeten güvenli',
    ],
    socialInfo:
        'İnsanlar çok misafirperver. Güney ve merkez kısımlar riskli. Kürt bölgesi (Erbil, Süleymaniye) daha güvenli ve turistik.',
    capital: 'Bağdat',
    currency: 'Dinar (د.ع)',
    language: 'Arapça, Kürtçe',
    population: '44M',
    regions: [
      'Bağdat',
      'Erbil',
      'Süleymaniye',
      'Basra',
      'Kerkük',
      'Necef',
      'Musul',
    ],
  ),
  // Suriye
  'SY': CountrySocialInfo(
    safetyLevel: 'Çok Tehlikeli',
    humanFriendliness: 8.0,
    happinessIndex: 3.0,
    famousFoods: [
      'Şam Kebabı',
      'Kibbeh',
      'Fatouş',
      'Hummus',
      'Baklava (Halep usulü)',
    ],
    places: [
      'Şam Eski Şehir (savaş öncesi)',
      'Palmira Antik Kenti',
      'Halep Kalesi',
      'Krak de Chevaliers',
    ],
    interestingFacts: [
      'Dünyanın en eski sürekli yerleşim yeri (Şam)',
      'İç savaştan büyük zarar gördü',
      'Zengin tarih ve kültür mirası',
    ],
    socialInfo:
        'İç savaş nedeniyle seyahat tavsiye edilmez. Halk son derece misafirperver ama güvenlik riski çok yüksek.',
    capital: 'Şam',
    currency: 'Lira (£S)',
    language: 'Arapça',
    population: '22M',
    regions: ['Şam', 'Halep', 'Humus', 'Hama', 'Lazkiye', 'Tartus'],
  ),
  // Azerbaycan
  'AZ': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.0,
    happinessIndex: 6.0,
    famousFoods: [
      'Plov (pilav)',
      'Dolma',
      'Kebap',
      'Piti',
      'Şah plov',
      'Baklava',
    ],
    places: [
      'Bakü İç Şehir (İçeri Şeher)',
      'Ateş Kuleleri',
      'Haydar Aliyev Merkezi',
      'Gobustan Kaya Resimleri',
      'Şeki Han Sarayı',
    ],
    interestingFacts: [
      '"Ateşler Ülkesi" lakabı',
      'Dünya\'nın ilk petrol kuyusu burada açıldı',
      'Türk dili konuşuluyor, kültürel yakınlık',
    ],
    socialInfo:
        'Türkiye ile kardeş ülke. İnsanlar çok sıcakkanlı, Türkçe ile anlaşmak mümkün. Modern ve geleneksel karışımı.',
    capital: 'Bakü',
    currency: 'Manat (₼)',
    language: 'Azerice',
    population: '10.1M',
    regions: [
      'Bakü',
      'Gence',
      'Şeki',
      'Lenkeran',
      'Nahçıvan',
      'Mingaçevir',
      'Sumgayıt',
    ],
  ),
  // Ermenistan
  'AM': CountrySocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 5.5,
    happinessIndex: 5.0,
    famousFoods: [
      'Lahmacun',
      'Khorovats (barbekü)',
      'Lavash ekmeği',
      'Dolma',
      'Gata tatlısı',
    ],
    places: [
      'Erivan Cumhuriyet Meydanı',
      'Garni Tapınağı',
      'Geghard Manastırı',
      'Sevan Gölü',
      'Tatev Manastırı',
    ],
    interestingFacts: [
      'Dünyanın ilk Hristiyanlığı kabul eden ülkesi (301)',
      'Ararat Dağı\'nın manzarası (Türkiye sınırında)',
      'Eski Sovyet cumhuriyeti',
    ],
    socialInfo:
        'Türk pasaportuyla giriş mümkün ama diplomatik ilişkiler gergin. Halk turizme açık.',
    capital: 'Erivan',
    currency: 'Dram (֏)',
    language: 'Ermenice',
    population: '2.8M',
    regions: [
      'Erivan',
      'Ararat',
      'Aragatsotn',
      'Gegharkunik',
      'Lori',
      'Syunik',
    ],
  ),
  // Kıbrıs (KKTC ayrı, Güney Kıbrıs)
  'CY': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.0,
    happinessIndex: 7.0,
    famousFoods: [
      'Hellim peyniri',
      'Şeftali kebabı',
      'Meze',
      'Kleftiko',
      'Kıbrıs kahvesi',
    ],
    places: [
      'Lefkoşa bölünmüş başkent',
      'Girne Kalesi',
      'Salamis Antik Kenti',
      'Karpaz Yarımadası',
      'Baf Mozaikleri',
    ],
    interestingFacts: [
      'Bölünmüş ada (KKTC ve Güney Kıbrıs)',
      'Afrodit\'in doğduğu yer efsanesi',
      'AB üyesi ama kuzey tanınmıyor',
    ],
    socialInfo:
        'Kuzeyi Türk, güneyi Rum. İki toplum farklı kültürler. KKTC\'ye Türk kimliği ile giriş mümkün.',
    capital: 'Lefkoşa',
    currency: 'Euro (€) / TL (KKTC)',
    language: 'Türkçe (KKTC), Yunanca (Güney)',
    population: '1.2M',
    regions: ['Lefkoşa', 'Girne', 'Gazimağusa', 'Baf', 'Limasol', 'Larnaka'],
  ),
  // Almanya
  'DE': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 6.0,
    happinessIndex: 7.5,
    famousFoods: [
      'Currywurst',
      'Bratwurst',
      'Pretzels',
      'Schnitzel',
      'Schwarzwälder Kirschtorte',
    ],
    places: [
      'Berlin Duvarı',
      'Neuschwanstein Kalesi',
      'Köln Katedrali',
      'Brandenburg Kapısı',
      'Kara Orman',
    ],
    interestingFacts: [
      'Avrupa\'nın en büyük ekonomisi',
      'Otobanlarında hız sınırı yok (bazı yerlerde)',
      '1000\'den fazla sosis çeşidi var',
    ],
    socialInfo:
        'Disiplinli ve kurallara bağlı bir toplum. Türkiye kökenli büyük bir nüfus var, bu yüzden yabancılık çekilmez.',
    capital: 'Berlin',
    currency: 'Euro (€)',
    language: 'Almanca',
    population: '84M',
    regions: [
      'Bavyera',
      'Berlin',
      'Hessen',
      'Kuzey Ren-Vestfalya',
      'Saksonya',
      'Hamburg',
    ],
  ),
  // Fransa
  'FR': CountrySocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 5.5,
    happinessIndex: 6.5,
    famousFoods: [
      'Baget',
      'Kruvasan',
      'Makaron',
      'Ratatouille',
      'Soğan Çorbası',
      'Peynir çeşitleri',
    ],
    places: [
      'Eyfel Kulesi',
      'Louvre Müzesi',
      'Versay Sarayı',
      'Mont Saint-Michel',
      'Fransız Rivierası',
    ],
    interestingFacts: [
      'Dünyanın en çok turist çeken ülkesi',
      'Modanın başkenti',
      'Gastronomi kültürü UNESCO mirasındadır',
    ],
    socialInfo:
        'Kültürüne ve diline çok bağlı bir halk. Büyük şehirlerde kozmopolit, taşrada daha geleneksel bir yaşam var.',
    capital: 'Paris',
    currency: 'Euro (€)',
    language: 'Fransızca',
    population: '68M',
    regions: [
      'Île-de-France (Paris)',
      'Provence-Alpes-Côte d\'Azur',
      'Normandiya',
      'Bretonya',
      'Nouvelle-Aquitaine',
    ],
  ),
  // İtalya
  'IT': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.0,
    happinessIndex: 6.5,
    famousFoods: [
      'Pizza',
      'Makarna',
      'Gelato',
      'Risotto',
      'Tiramisu',
      'Espresso',
    ],
    places: [
      'Kolezyum (Roma)',
      'Venedik Kanalları',
      'Floransa (Duomo)',
      'Pisa Kulesi',
      'Amalfi Kıyıları',
    ],
    interestingFacts: [
      'En fazla UNESCO Dünya Mirası alanına sahip ülke',
      'Roma İmparatorluğu ve Rönesans\'ın merkezi',
    ],
    socialInfo:
        'Akdeniz insanı, çok sıcakkanlı ve konuşkan. Yeme içme ve aile kültürü hayatın merkezindedir.',
    capital: 'Roma',
    currency: 'Euro (€)',
    language: 'İtalyanca',
    population: '59M',
    regions: [
      'Lazio (Roma)',
      'Lombardiya',
      'Toskana',
      'Veneto (Venedik)',
      'Sicilya',
      'Campania (Napoli)',
    ],
  ),
  // Birleşik Krallık (İngiltere)
  'GB': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 6.5,
    happinessIndex: 7.0,
    famousFoods: [
      'Fish and Chips',
      'English Breakfast',
      'Sunday Roast',
      'Yorkshire Pudding',
      'Çay kültürü',
    ],
    places: [
      'Big Ben',
      'Londra Kulesi',
      'Stonehenge',
      'Edinburgh Kalesi',
      'Britanya Müzesi',
    ],
    interestingFacts: [
      'Çay tüketimi çok yüksek',
      'Sanayi Devrimi\'nin başladığı yer',
      'Ada ülkesi',
    ],
    socialInfo:
        'Nezaket ve kurallara uyum çok önemlidir. Çok kültürlü bir yapıya sahiptir. Hava genelde kapalı ve yağmurludur.',
    capital: 'Londra',
    currency: 'İngiliz Sterlini (£)',
    language: 'İngilizce',
    population: '67M',
    regions: ['İngiltere', 'İskoçya', 'Galler', 'Kuzey İrlanda'],
  ),
  // ABD
  'US': CountrySocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 7.5,
    happinessIndex: 7.0,
    famousFoods: [
      'Burger',
      'Hot Dog',
      'Apple Pie',
      'Barbekü',
      'Clam Chowder',
      'Donut',
    ],
    places: [
      'Özgürlük Anıtı',
      'Büyük Kanyon',
      'Times Meydanı',
      'Yellowstone',
      'Golden Gate Köprüsü',
    ],
    interestingFacts: [
      '50 eyaletten oluşur',
      'Eğlence sektörü (Hollywood) ve teknoloji (Silikon Vadisi) devidir',
    ],
    socialInfo:
        'Bireysellik ön plandadır. Çok çeşitli kültürlerin eridiği bir pota (melting pot). İnsanlar dışa dönük ve rahat.',
    capital: 'Washington, D.C.',
    currency: 'ABD Doları (\$)',
    language: 'İngilizce',
    population: '335M',
    regions: [
      'Kaliforniya',
      'New York',
      'Texas',
      'Florida',
      'Illinois',
      'Nevada',
    ],
  ),
  // Rusya
  'RU': CountrySocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 5.5,
    happinessIndex: 5.5,
    famousFoods: [
      'Borş Çorbası',
      'Pelmeni',
      'Blini',
      'Beef Stroganoff',
      'Havyar',
    ],
    places: [
      'Kızıl Meydan',
      'St. Petersburg (Hermitage)',
      'Baykal Gölü',
      'Kremlin Sarayı',
    ],
    interestingFacts: [
      'Yüzölçümü bakımından dünyanın en büyük ülkesi',
      '11 farklı saat dilimine sahip',
      'Vizesiz seyahat imkanı var',
    ],
    socialInfo:
        'Dışarıdan soğuk görünürler ancak dostlukları derindir. Edebiyat ve sanat hayatın önemli parçasıdır.',
    capital: 'Moskova',
    currency: 'Rus Rublesi (₽)',
    language: 'Rusça',
    population: '144M',
    regions: [
      'Moskova',
      'St. Petersburg',
      'Tataristan (Kazan)',
      'Sibirya',
      'Ural',
      'Kafkasya',
    ],
  ),
  // Ukrayna
  'UA': CountrySocialInfo(
    safetyLevel: 'Tehlikeli',
    humanFriendliness: 7.0,
    happinessIndex: 4.0,
    famousFoods: [
      'Borsch (Ukrayna usulü)',
      'Varenyky',
      'Chicken Kyiv',
      'Salo',
      'Syrniki',
    ],
    places: [
      'Kiev Pechersk Lavra',
      'Lviv Eski Şehir',
      'Karpat Dağları',
      'Odesa Opera Binası',
    ],
    interestingFacts: [
      'Avrupa\'nın en geniş topraklarına sahip ülkelerinden',
      'Zengin tarım arazileri ("Avrupa\'nın ekmek sepeti")',
    ],
    socialInfo:
        'Devam eden çatışmalar nedeniyle turizm durma noktasındadır. Halk dirençli, vatansever ve misafirperverdir.',
    capital: 'Kiev',
    currency: 'Grivna (₴)',
    language: 'Ukraynaca',
    population: '38M',
    regions: ['Kiev', 'Lviv', 'Odesa', 'Harkiv', 'Dnipro'],
  ),
  // Japonya
  'JP': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.0,
    happinessIndex: 6.0,
    famousFoods: [
      'Sushi',
      'Ramen',
      'Tempura',
      'Takoyaki',
      'Matcha Tatlıları',
      'Wagyu',
    ],
    places: [
      'Fuji Dağı',
      'Kyoto Tapınakları',
      'Tokyo (Shibuya)',
      'Osaka Kalesi',
      'Hiroşima Barış Anıtı',
    ],
    interestingFacts: [
      'Dünyanın en eski süregelen monarşisi',
      'Trenler saniyelerle ölçülecek kadar dakiktir',
      '6800 civarı adadan oluşur',
    ],
    socialInfo:
        'Aşırı kibar, saygılı ve kurallara uyan bir toplum. Temizliğe çok önem verirler. İş etiği çok yüksektir.',
    capital: 'Tokyo',
    currency: 'Japon Yeni (¥)',
    language: 'Japonca',
    population: '125M',
    regions: [
      'Kanto (Tokyo)',
      'Kansai (Osaka/Kyoto)',
      'Hokkaido',
      'Kyushu',
      'Tohoku',
    ],
  ),
  // Mısır
  'EG': CountrySocialInfo(
    safetyLevel: 'Az Tehlikeli',
    humanFriendliness: 7.5,
    happinessIndex: 4.5,
    famousFoods: ['Koshary', 'Falafel', 'Ful Medames', 'Shawarma', 'Om Ali'],
    places: [
      'Giza Piramitleri',
      'Karnak Tapınağı (Luksor)',
      'Krallar Vadisi',
      'Nil Nehri',
      'Şarm El-Şeyh',
    ],
    interestingFacts: [
      'Dünyanın en eski medeniyetlerinden biri',
      'Antik Dünyanın 7 Harikasından ayakta kalan tek eser (Keops) burada',
    ],
    socialInfo:
        'Kalabalık, gürültülü ama sıcakkanlı insanlar. Turizm önemli gelir kaynağı; satıcılar bazen fazla ısrarcı olabilir.',
    capital: 'Kahire',
    currency: 'Mısır Lirası (E£)',
    language: 'Arapça',
    population: '112M',
    regions: [
      'Kahire',
      'İskenderiye',
      'Luksor',
      'Aswan',
      'Güney Sina',
      'Kızıldeniz',
    ],
  ),
  // İspanya
  'ES': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 7.0,
    famousFoods: ['Paella', 'Tapas', 'Gazpacho', 'Churros', 'Jamón Ibérico'],
    places: [
      'Sagrada Familia',
      'El Hamra Sarayı',
      'Prado Müzesi',
      'Park Güell',
      'İbiza',
    ],
    interestingFacts: [
      'Zeytinyağı üretiminde dünya lideridir',
      'Eşsiz siesta (öğle uykusu) kültürü vardır',
    ],
    socialInfo:
        'Akdeniz kültürünün en canlı örneği. Eğlenmeyi, gece hayatını ve sosyalleşmeyi çok seven neşeli bir halktır.',
    capital: 'Madrid',
    currency: 'Euro (€)',
    language: 'İspanyolca',
    population: '48M',
    regions: [
      'Katalonya (Barselona)',
      'Madrid',
      'Endülüs',
      'Valensiya',
      'Galiçya',
      'Bask Bölgesi',
    ],
  ),
  // Hollanda
  'NL': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 8.0,
    famousFoods: [
      'Stroopwafel',
      'Gouda Peyniri',
      'Bitterballen',
      'Haring',
      'Poffertjes',
    ],
    places: [
      'Amsterdam Kanalları',
      'Keukenhof',
      'Van Gogh Müzesi',
      'Zaanse Schans (Yel değirmenleri)',
    ],
    interestingFacts: [
      'Nüfusundan fazla bisiklet vardır',
      'Topraklarının büyük kısmı deniz seviyesinin altındadır',
    ],
    socialInfo:
        'Çok açık fikirli, hoşgörülü ve direkt konuşan insanlar. Ulaşımda bisiklet hayatın merkezindedir.',
    capital: 'Amsterdam',
    currency: 'Euro (€)',
    language: 'Felemenkçe',
    population: '18M',
    regions: [
      'Kuzey Hollanda',
      'Güney Hollanda',
      'Utrecht',
      'Kuzey Brabant',
      'Gelderland',
    ],
  ),
  // İsviçre
  'CH': CountrySocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 6.5,
    happinessIndex: 8.5,
    famousFoods: [
      'Fondü',
      'Raclette',
      'İsviçre Çikolatası',
      'Rösti',
      'Macaroni Pastası',
    ],
    places: [
      'Matterhorn Dağı',
      'Cenevre Gölü',
      'Luzern Köprüsü',
      'Jungfraujoch',
      'Zürih Eski Şehir',
    ],
    interestingFacts: [
      '4 resmi dili vardır',
      'Dünyanın en uzun tüneli (Gotthard) buradadır',
      'Tarafsızlık politikası ile bilinir',
    ],
    socialInfo:
        'Son derece düzenli, yüksek yaşam standartlarına sahip, dakik ama biraz içine kapanık bir toplum.',
    capital: 'Bern',
    currency: 'İsviçre Frangı (CHF)',
    language: 'Almanca, Fransızca, İtalyanca, Romanşça',
    population: '9M',
    regions: ['Zürih', 'Cenevre', 'Vaud', 'Bern', 'Ticino'],
  ),
  // Kanada
  'CA': CountrySocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 9.0,
    happinessIndex: 7.5,
    famousFoods: [
      'Poutine',
      'Akçaağaç Şurubu (Maple Syrup)',
      'Nanaimo Bar',
      'Montreal Usulü Bagel',
    ],
    places: [
      'Niagara Şelalesi',
      'Banff Ulusal Parkı',
      'CN Kulesi',
      'Eski Quebec',
      'Stanley Park',
    ],
    interestingFacts: [
      'Dünyanın en uzun kıyı şeridine sahiptir',
      'Tatlı suların %20\'si buradadır',
    ],
    socialInfo:
        'Dünyanın en kibar insanları olarak bilinirler. Çok kültürlülük, göçmen dostu ve doğayla iç içe yaşam öne çıkar.',
    capital: 'Ottawa',
    currency: 'Kanada Doları (CAD)',
    language: 'İngilizce, Fransızca',
    population: '40M',
    regions: [
      'Ontario',
      'Quebec',
      'Britanya Kolumbiyası (B.C.)',
      'Alberta',
      'Nova Scotia',
    ],
  ),
  // Avustralya
  'AU': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 7.5,
    famousFoods: [
      'Vegemite',
      'Tim Tam',
      'Meat Pie',
      'Barbekü (Barbie)',
      'Lamington',
    ],
    places: [
      'Sidney Opera Binası',
      'Büyük Set Resifi',
      'Uluru (Ayers Rock)',
      'Bondi Plajı',
      'Melbourne Sokakları',
    ],
    interestingFacts: [
      'Hem kıta hem ülkedir',
      'Kanguru ve koalaların anavatanıdır',
      'Nüfusun çoğu kıyılarda Yaşar',
    ],
    socialInfo:
        '"No worries" (Dert etme) felsefesiyle yaşayan, çok rahat, sörf ve açık hava tutkunu sıcakkanlı insanlar.',
    capital: 'Canberra',
    currency: 'Avustralya Doları (AUD)',
    language: 'İngilizce',
    population: '26M',
    regions: [
      'Yeni Güney Galler',
      'Victoria',
      'Queensland',
      'Batı Avustralya',
      'Güney Avustralya',
      'Tazmanya',
    ],
  ),
  // Çin
  'CN': CountrySocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 6.5,
    happinessIndex: 5.5,
    famousFoods: [
      'Pekin Ördeği',
      'Dim Sum',
      'Dumpling (Mantı)',
      'Sichuan Hot Pot',
      'Mapo Tofu',
    ],
    places: [
      'Çin Seddi',
      'Yasak Şehir',
      'Terracotta Ordusu',
      'Huangshan Dağları',
      'Şanghay Bund',
    ],
    interestingFacts: [
      'Dünyanın en büyük nüfuslarından biri',
      'Panda ayılarına ev sahipliği yapar',
      'En büyük hızlı tren ağına sahiptir',
    ],
    socialInfo:
        'Teknoloji ile geleneğin bir iç içe olduğu, çalışkan ve kolektivist bir toplum. Yabancılara meraklı ama dil bariyeri yüksektir.',
    capital: 'Pekin',
    currency: 'Yuan (CNY)',
    language: 'Mandarince (Çince)',
    population: '1.4 Milyar',
    regions: [
      'Pekin',
      'Şanghay',
      'Guangdong',
      'Sichuan',
      'Zhejiang',
      'Hong Kong',
      'Makao',
    ],
  ),
  // Hindistan
  'IN': CountrySocialInfo(
    safetyLevel: 'Az Tehlikeli',
    humanFriendliness: 7.5,
    happinessIndex: 4.5,
    famousFoods: [
      'Tikka Masala',
      'Biryani',
      'Samosa',
      'Dosa',
      'Naan',
      'Masala Çayı',
    ],
    places: [
      'Tac Mahal',
      'Ganj Nehri (Varanasi)',
      'Amber Kalesi',
      'Altın Tapınak',
      'Kerala Kanalları',
    ],
    interestingFacts: [
      'Dünyanın en kalabalık ülkesi',
      'Binlerce farklı dil ve lehçe konuşulur',
      'Baharatların anavatanı',
    ],
    socialInfo:
        'Muazzam bir kültürel çeşitlilik, kalabalık ve hayat dolu sokaklar. İnsanları çok cana yakın ama kültür şoku yaşanabilir.',
    capital: 'Yeni Delhi',
    currency: 'Hint Rupisi (INR)',
    language: 'Hintçe, İngilizce ve 20+ bölgesel dil',
    population: '1.4 Milyar',
    regions: [
      'Delhi',
      'Maharashtra (Mumbai)',
      'Utar Pradeş',
      'Kerala',
      'Pencap',
      'Goa',
      'Racastan',
    ],
  ),
  // Meksika
  'MX': CountrySocialInfo(
    safetyLevel: 'Tehlikeli',
    humanFriendliness: 8.5,
    happinessIndex: 6.5,
    famousFoods: [
      'Taco',
      'Guacamole',
      'Enchilada',
      'Quesadilla',
      'Churros',
      'Tamales',
    ],
    places: [
      'Chichen Itza (Maya Piramidi)',
      'Cancun',
      'Teotihuacan',
      'Frida Kahlo Müzesi',
      'Tulum',
    ],
    interestingFacts: [
      'Çikolatanın dünyaya yayıldığı yer',
      '68 farklı yerli dil kabul edilir',
    ],
    socialInfo:
        'Çok sıcakkanlı, müzik (Mariachi) ve dansla iç içe yaşayan renkli bir halk. Bazı bölgelerde güvenlik riski yüksektir.',
    capital: 'Meksika Şehri (CDMX)',
    currency: 'Meksika Pesosu (MXN)',
    language: 'İspanyolca',
    population: '128M',
    regions: [
      'Meksika Şehri',
      'Quintana Roo (Cancun)',
      'Yucatan',
      'Jalisco (Guadalajara)',
      'Oaxaca',
      'Baja California',
    ],
  ),
  // Güney Kore
  'KR': CountrySocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 7.0,
    happinessIndex: 6.0,
    famousFoods: [
      'Kimchi',
      'Bibimbap',
      'Kore Barbeküsü',
      'Tteokbokki',
      'Kimbap',
    ],
    places: [
      'Gyeongbokgung Sarayı',
      'N Seul Kulesi',
      'Jeju Adası',
      'Bukchon Hanok Köyü',
      'Gangnam',
    ],
    interestingFacts: [
      'K-Pop ve K-Drama dünyayı kasıp kavuruyor',
      'İnternet hızında dünya birincisi',
    ],
    socialInfo:
        'İnanılmaz teknolojik ve güvenli bir ülke. Saygı, hiyerarşi ve hızlı yaşam (Pali-pali kültürü) esastır.',
    capital: 'Seul',
    currency: 'Güney Kore Wonu (KRW)',
    language: 'Korece',
    population: '51M',
    regions: ['Seul', 'Busan', 'Jeju', 'Incheon', 'Daegu', 'Gyeonggi'],
  ),
};

// Region-level social data
const Map<String, Map<String, RegionSocialInfo>> _regionSocialData = {
  'GR': {
    'Attika': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 6.5,
      happinessIndex: 6.0,
      famousFoods: ['Souvlaki', 'Gyros', 'Yunan salatası'],
      places: [
        'Akropolis',
        'Parthenon',
        'Plaka mahallesi',
        'Monastiraki Çarşısı',
      ],
      interestingFacts: [
        'Atina 3400 yıllık şehir',
        'Dünyanın ilk demokrasisi burada kuruldu',
      ],
      socialInfo: 'Kalabalık metropol, turist dostu ama yankesicilere dikkat.',
    ),
    'Girit': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: ['Dakos', 'Kalitsounia', 'Zeytinyağlı yemekler'],
      places: ['Knossos Sarayı', 'Elafonisi plajı', 'Samaria Kanyonu'],
      interestingFacts: [
        'Minos uygarlığının merkezi',
        'Akdeniz\'in en büyük Yunan adası',
      ],
      socialInfo: 'Sıcakkanlı ada insanı, rahat yaşam tempolu.',
    ),
  },
  'GE': {
    'Tiflis': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 7.0,
      famousFoods: ['Haçapuri', 'Hinkali', 'Gürcü şarabı'],
      places: [
        'Narikala Kalesi',
        'Kükürt Hamamları',
        'Özgürlük Meydanı',
        'Mtatsminda Parkı',
      ],
      interestingFacts: [
        'Eski ve yeni mimarinin buluştuğu şehir',
        'Gece hayatı canlı',
      ],
      socialInfo: 'Kozmopolit, festival dolu, sanat ve müzik merkezi.',
    ),
    'Acara (Batum)': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 7.0,
      famousFoods: ['Acaruli Haçapuri', 'Balık yemekleri'],
      places: ['Batum Bulvarı', 'Ali ve Nino Heykeli', 'Botanik Bahçesi'],
      interestingFacts: [
        'Karadeniz kıyı kenti',
        'Türk sınırına çok yakın, kumarhane turizmi',
      ],
      socialInfo: 'Turist dostu, canlı gece hayatı, Türk turistlerin gözdesi.',
    ),
  },
  'AZ': {
    'Bakü': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 6.5,
      famousFoods: ['Plov', 'Dönər', 'Pakhlava'],
      places: [
        'İçeri Şeher',
        'Ateş Kuleleri',
        'Haydar Aliyev Merkezi',
        'Fıskiye Meydanı',
      ],
      interestingFacts: [
        'Hazar Denizi kıyısında modern metropol',
        'Petrol zengini başkent',
      ],
      socialInfo:
          'Modern, kozmopolit. Türkiye ile güçlü kültürel bağ, dil benzerliği yüksek.',
    ),
  },
  'IR': {
    'İsfahan': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 6.0,
      famousFoods: ['Beryani', 'Gaz tatlısı', 'İsfahan pilavı'],
      places: ['Nakş-ı Cihan Meydanı', 'Si-o-se Pol Köprüsü', 'İmam Camii'],
      interestingFacts: [
        '"Dünyanın yarısı" lakabı',
        'İslam mimarisinin şaheseri',
      ],
      socialInfo: 'İran\'ın en turistik şehri, çok misafirperver halk.',
    ),
    'Şiraz': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 6.5,
      famousFoods: ['Kalam Polo', 'Faloodeh (dondurma)'],
      places: [
        'Nasır al-Molk Camii (Pembe Cami)',
        'Persepolis',
        'Hafız Türbesi',
      ],
      interestingFacts: ['Şiir ve gül şehri', 'Hafız ve Sadi\'nin vatanı'],
      socialInfo: 'Kültür ve sanat şehri, rahat atmosfer.',
    ),
  },
  'IQ': {
    'Erbil': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 8.0,
      happinessIndex: 5.5,
      famousFoods: ['Kebap', 'Dolma', 'Nane çayı'],
      places: [
        'Erbil Kalesi (UNESCO)',
        'Sami Abdulrahman Parkı',
        'Şanlıurfa Çarşısı',
      ],
      interestingFacts: [
        'Dünyanın en eski sürekli yerleşim yerlerinden',
        'Kürdistan bölgesi başkenti',
      ],
      socialInfo:
          'Irak\'ın en güvenli bölgesi. Türk iş insanları çok, Türkçe konuşanlar var.',
    ),
  },
  'DE': {
    'Berlin': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 6.5,
      happinessIndex: 7.0,
      famousFoods: ['Currywurst', 'Döner Kebab (Berlin usulü)'],
      places: [
        'Brandenburg Kapısı',
        'Alexanderplatz',
        'Reichstag',
        'Müzeler Adası',
      ],
      interestingFacts: [
        'Avrupa\'nın sanat ve kültür başkentlerinden',
        'Çok kültürlü yapı, Türk nüfusu çok yoğun',
      ],
      socialInfo:
          'Alternatif ve özgürlükçü bir atmosfere sahip, sanatçılar ve gençler için cazibe merkezi.',
    ),
    'Bavyera': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 6.0,
      happinessIndex: 8.0,
      famousFoods: ['Weißwurst', 'Pretzel', 'Bira kültürü'],
      places: ['Münih', 'Neuschwanstein Kalesi', 'Alpler'],
      interestingFacts: [
        'Oktoberfest\'in doğduğu yer',
        'Almanya\'nın en zengin eyaleti',
      ],
      socialInfo:
          'Geleneksel Alman kültürünün en yoğun yaşandığı, muhafazakar ama refah düzeyi yüksek bölge.',
    ),
  },
  'FR': {
    'Île-de-France (Paris)': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 5.0,
      happinessIndex: 6.5,
      famousFoods: ['Baget', 'Kruvasan', 'Makaron'],
      places: ['Eyfel Kulesi', 'Louvre', 'Ressamlar Tepesi (Montmartre)'],
      interestingFacts: [
        'Dünyanın en romantik şehri olarak bilinir',
        'Sanat ve modanın kalbi',
      ],
      socialInfo:
          'Çok turistik olduğu için yerel halk bazen mesafeli olabilir, büyük kozmopolit metropol yaşantısı.',
    ),
  },
  'IT': {
    'Lazio (Roma)': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.5,
      happinessIndex: 6.5,
      famousFoods: ['Carbonara', 'Cacio e Pepe', 'Pizza al Taglio'],
      places: ['Kolezyum', 'Vatikan', 'Trevi Çeşmesi', 'İspanyol Merdivenleri'],
      interestingFacts: [
        'İçinde bağımsız bir devlet (Vatikan) barındırır',
        'Açık hava müzesi gibidir',
      ],
      socialInfo:
          'Sıcakkanlı insanlar, yoğun turist kalabalığı ve hareketli sokaklar.',
    ),
  },
  'GB': {
    'İngiltere': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 6.5,
      happinessIndex: 7.0,
      famousFoods: ['Fish and Chips', 'Sunday Roast', 'English Breakfast'],
      places: ['Londra Kulesi', 'Big Ben', 'Oxford', 'Cambridge'],
      interestingFacts: [
        'Monarşi geleneği devam ediyor',
        'Dünyanın finans ve eğitim merkezlerinden',
      ],
      socialInfo: 'Kibar ve mesafeli İngiliz kültürü, pub kültürü çok yaygın.',
    ),
  },

  'RU': {
    'Moskova': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 5.0,
      happinessIndex: 5.5,
      famousFoods: ['Borş Çorbası', 'Pelmeni', 'Blini'],
      places: ['Kızıl Meydan', 'Kremlin Suru', 'Aziz Vasil Katedrali'],
      interestingFacts: [
        'Dünyanın en çok milyarder barındıran şehirlerinden',
        'Moskova metrosu sanat galerisi gibidir',
      ],
      socialInfo:
          'Soğuk iklim, resmi ve mesafeli ama sanat ve kültüre çok değer veren bir toplum.',
    ),
  },
  'UA': {
    'Kiev': RegionSocialInfo(
      safetyLevel: 'Çok Tehlikeli',
      humanFriendliness: 7.0,
      happinessIndex: 3.5,
      famousFoods: ['Chicken Kyiv', 'Borsch', 'Varenyky'],
      places: ['Maidan Nezalezhnosti', 'St. Sophia Katedrali', 'Altın Kapı'],
      interestingFacts: [
        'Doğu Avrupa\'nın en eski şehirlerinden',
        'Savaş öncesi canlı bir teknoloji ve kültür merkeziydi',
      ],
      socialInfo:
          'Savaş şartları altında, milliyetçi ve dayanışma içinde olan kahraman bir başkent.',
    ),
  },
  'JP': {
    'Kanto (Tokyo)': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 6.0,
      famousFoods: ['Sushi', 'Ramen', 'Soba'],
      places: [
        'Shibuya Kavşağı',
        'Senso-ji Tapınağı',
        'Akihabara',
        'Tokyo Kulesi',
      ],
      interestingFacts: [
        'Dünyanın en kalabalık metropol bölgesi',
        'Teknoloji ve popüler kültürün (anime/manga) kalbi',
      ],
      socialInfo:
          'Kusursuz işleyen bir sistem, aşırı saygılı insanlar ama yoğun stresli iş hayatı.',
    ),
  },
  'EG': {
    'Kahire': RegionSocialInfo(
      safetyLevel: 'Az Tehlikeli',
      humanFriendliness: 7.5,
      happinessIndex: 4.5,
      famousFoods: ['Koshary', 'Falafel', 'Ta\'meya'],
      places: [
        'Giza Piramitleri',
        'Kahire Mısır Müzesi',
        'Han el-Halili Çarşısı',
      ],
      interestingFacts: [
        'Afrika\'nın ve Orta Doğu\'nun en büyük ve en kalabalık şehirlerinden',
        'Nil Nehri etrafında şekillenmiştir',
      ],
      socialInfo:
          'Trafik karmaşası, sürekli kornalar ve canlılık. İnsanlar cana yakın ancak turistik bölgelerde satıcılar ısrarcı olabilir.',
    ),
  },
  'ES': {
    'Madrid': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.0,
      famousFoods: ['Cocido Madrileño', 'Bocadillo de Calamares'],
      places: ['Prado Müzesi', 'Retiro Parkı', 'Plaza Mayor'],
      interestingFacts: [
        'Avrupa\'nın rakım olarak en yüksek başkentlerinden',
        'Kraliyet Sarayı Avrupa\'nın en büyüğüdür',
      ],
      socialInfo:
          'Hareketli gece hayatı, müzeler ve sanat dolu geniş caddeler.',
    ),
    'Katalonya (Barselona)': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.5,
      happinessIndex: 7.5,
      famousFoods: ['Botifarra', 'Crema Catalana', 'Pa amb tomàquet'],
      places: ['Sagrada Familia', 'Park Güell', 'La Rambla', 'Camp Nou'],
      interestingFacts: [
        'Gaudí\'nin mimari harikalarıyla doludur',
        'Kendi dili (Katalanca) ve kültürü vardır',
      ],
      socialInfo:
          'Çok turistik olduğu için yankesicilere dikkat edilmelidir. Plaj kültürü ve modern mimari iç içedir.',
    ),
  },
  'NL': {
    'Kuzey Hollanda': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.0,
      happinessIndex: 8.0,
      famousFoods: ['Herring (Çiğ ringa balığı)', 'Stroopwafel'],
      places: ['Amsterdam Kanalları', 'Zaanse Schans', 'Anne Frank Evi'],
      interestingFacts: [
        'Şehir ahşap kazıklar üzerine inşa edilmiştir',
        'Bisiklet trafiği araba trafiğinden fazladır',
      ],
      socialInfo: 'Dünyanın en özgürlükçü ve kozmopolit noktalarından biri.',
    ),
  },
  'CH': {
    'Zürih': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 6.0,
      happinessIndex: 8.5,
      famousFoods: ['Zürcher Geschnetzeltes', 'Luxemburgerli'],
      places: ['Zürih Gölü', 'Bahnhofstrasse', 'Grossmünster'],
      interestingFacts: [
        'Dünyanın en yaşanabilir ve pahalı şehirlerinden',
        'Banka ve finans merkezidir',
      ],
      socialInfo:
          'Çok temiz, inanılmaz düzenli, dakik ama biraz soğuk bir atmosfer.',
    ),
  },
  'US': {
    'New York': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 6.0,
      happinessIndex: 6.5,
      famousFoods: ['NY tarzı Pizza', 'Bagel', 'Pastrami Sandwich'],
      places: ['Times Meydanı', 'Central Park', 'Özgürlük Anıtı', 'Broadway'],
      interestingFacts: [
        'Uyumayan şehir',
        'Dünyanın kültürel ve finansal başkentlerinden',
      ],
      socialInfo:
          'Çok hızlı bir yaşam temposu, dünyanın her yerinden insanın buluştuğu yüksek enerjili metropol.',
    ),
    'Kaliforniya': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.5,
      happinessIndex: 7.5,
      famousFoods: [
        'Avokado Tost',
        'Meksika-Kaliforniya füzyon (Tex-Mex)',
        'Bölgesel Şaraplar',
      ],
      places: ['Hollywood', 'Golden Gate Köprüsü', 'Yosemite Ulusal Parkı'],
      interestingFacts: [
        'Teknoloji (Silikon Vadisi) ve sinema (Hollywood) merkezi',
        'Amerika\'nın en zengin eyaleti',
      ],
      socialInfo:
          'Güneşli, rahat yaşam tarzı, surf kültürü ve doğa sporlarına düşkünlük.',
    ),
    'Florida': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 8.0,
      happinessIndex: 7.0,
      famousFoods: ['Key Lime Pie', 'Cuban Sandwich', 'Portakal Suyu'],
      places: [
        'Miami Beach',
        'Walt Disney World',
        'Everglades',
        'Kennedy Uzay Merkezi',
      ],
      interestingFacts: [
        '"Güneş Işığı Eyaleti" olarak bilinir',
        'Amerika\'daki Latin kültürünün merkezidir',
      ],
      socialInfo:
          'Sıcak iklimi nedeniyle çok sayıda emeklinin yaşadığı, eğlence ve sahil odaklı rahat bir yaşam.',
    ),
    'Texas': RegionSocialInfo(
      safetyLevel: 'Az Tehlikeli',
      humanFriendliness: 8.5,
      happinessIndex: 6.5,
      famousFoods: ['Texas Barbekü (Brisket)', 'Chili', 'Pecan Pie'],
      places: ['Alamo', 'Space Center Houston', 'River Walk (San Antonio)'],
      interestingFacts: [
        'Eskiden bağımsız bir cumhuriyetti',
        '"Her şey Texas\'ta daha büyüktür" mottosuna sahiptir',
      ],
      socialInfo:
          'Geleneksel Amerikan ve Kovboy kültürünün kalesi. Çok vatansever, sıcakkanlı ve muhafazakar bir halk.',
    ),
    'Illinois': RegionSocialInfo(
      safetyLevel: 'Tehlikeli',
      humanFriendliness: 7.0,
      happinessIndex: 6.5,
      famousFoods: [
        'Deep Dish Pizza',
        'Chicago Style Hot Dog',
        'Italian Beef Sandwich',
      ],
      places: [
        'Cloud Gate (The Bean)',
        'Willis Kulesi',
        'Navy Pier',
        'Route 66 Başlangıcı',
      ],
      interestingFacts: [
        'Chicago bölgenin ve ulusun en önemli demiryolu ağlarından biridir',
        'Rüzgarlı Şehir (Windy City) unvanı vardır',
      ],
      socialInfo:
          'Sert kışları olan, caz ve blues müziğine düşkün, bazı bölgelerinde çok yüksek suç oranları olan endüstriyel metropol.',
    ),
    'Nevada': RegionSocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.0,
      happinessIndex: 6.0,
      famousFoods: ['Buffet Yemekleri', 'Shrimp Cocktail', 'Prime Rib'],
      places: [
        'Las Vegas Strip',
        'Hoover Barajı',
        'Red Rock Canyon',
        'Ölüm Vadisi (Sınırda)',
      ],
      interestingFacts: [
        'Kumardan elde edilen devasa gelirlere sahiptir',
        'Topraklarının çoğu çöldür',
      ],
      socialInfo:
          'Las Vegas etrafında şekillenen "Günah Şehri" kültürü; eğlence, gösteriş ve turizm üzerine kurulu 24 saat açık yaşam.',
    ),
  },
  'CA': {
    'Ontario': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 7.5,
      famousFoods: ['Peameal Bacon', 'Maple Syrup', 'Butter Tart'],
      places: [
        'Niagara Şelalesi',
        'CN Kulesi',
        'Royal Ontario Müzesi (Toronto)',
      ],
      interestingFacts: [
        'Toronto dünyanın en çok kültürlü şehirlerinden biridir',
        'Göllerle çevrili devasa doğa alanları var',
      ],
      socialInfo:
          'Her milletten insanın uyum içinde yaşadığı, aşırı kibar ve yardımsever bir toplum.',
    ),
    'Quebec': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: [
        'Poutine',
        'Tourtière (Etli Turta)',
        'Smoked Meat Sandwich',
      ],
      places: [
        'Old Quebec (Eski Şehir)',
        'Mont-Royal Dağı',
        'Château Frontenac',
      ],
      interestingFacts: [
        'Kuzey Amerika\'da Fransız kültürünün tek temsilcisidir',
        'Ana dili Fransızcadır',
      ],
      socialInfo:
          'Kanada ve Fransa sentezi bir kültür. Festivalleri, sanat etkinlikleri ve eşsiz mutfağı ile çok renkli bir bölge.',
    ),
    'Britanya Kolumbiyası (B.C.)': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Pasifik Somonu',
        'B.C. Roll (Sushi)',
        'Okanagan Şarapları',
      ],
      places: [
        'Stanley Park (Vancouver)',
        'Whistler Kayak Merkezi',
        'Victoria İç Liman',
      ],
      interestingFacts: [
        'Kanada\'nın en ılıman iklimine sahiptir',
        'Film ve dizi sektörünün "Kuzey Hollywood"udur',
      ],
      socialInfo:
          'Doğa sporlarına aşık, çevre dostu, yoga ve organik yaşam kültürünün ABD\'deki Kaliforniya vari temsilcisi.',
    ),
    'Alberta': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 7.5,
      famousFoods: ['Alberta Dana Eti (Steak)', 'Ginger Beef', 'Bison Eti'],
      places: [
        'Banff Ulusal Parkı',
        'Lake Louise',
        'Jasper',
        'Calgary Stampede',
      ],
      interestingFacts: [
        'Kanada\'nın enerji (petrol) kalbidir',
        'Muazzam güzellikteki Rocky Dağlarına ev sahipliği yapar',
      ],
      socialInfo:
          'Kanada\'nın "Texas"ı olarak anılır. Kovboy kültürü, doğa sporları ve kırsal refah iç içedir.',
    ),
    'Nova Scotia': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.5,
      happinessIndex: 8.0,
      famousFoods: ['Istakoz (Lobster)', 'Deniz Tarakları', 'Donair'],
      places: ['Peggy\'s Cove Feneri', 'Cabot Trail', 'Halifax Citadel'],
      interestingFacts: [
        '"Yeni İskoçya" anlamına gelir',
        'Sürekli hissedilen denizcilik kültürüne ve yüksek gelgitlere (Fundy Körfezi) sahiptir',
      ],
      socialInfo:
          'İnanılmaz samimi ve yardımsever ada halkı. Müzik, denizcilik ve pub kültürü hayatın merkezindedir.',
    ),
  },
  'CN': {
    'Pekin': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 6.0,
      happinessIndex: 5.5,
      famousFoods: ['Pekin Ördeği', 'Zhajiangmian'],
      places: [
        'Yasak Şehir',
        'Çin Seddi (Mutianyu/Badaling)',
        'Cennet Tapınağı',
      ],
      interestingFacts: [
        'Binlerce yıllık imparatorluk başkenti',
        'Devasa ve çok yoğun bir metropol',
      ],
      socialInfo:
          'Tarihi dokunun gökdelenlerle iç içe olduğu, hızlı ve kurallı komünist/kapitalist sentezi yaşam.',
    ),
    'Şanghay': RegionSocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 6.5,
      happinessIndex: 6.0,
      famousFoods: ['Xiaolongbao (Çorbalı Mantı)', 'Shengjianbao'],
      places: ['The Bund', 'Yu Bahçesi', 'Pudong Gökdelenleri'],
      interestingFacts: [
        'Çin\'in finans ve ticaret kalbi',
        'Geleceğin şehri görünümündedir',
      ],
      socialInfo:
          'Çok modern, batıya daha açık ve inanılmaz canlı bir gece/gündüz hayatı.',
    ),
  },
  'IN': {
    'Delhi': RegionSocialInfo(
      safetyLevel: 'Az Tehlikeli',
      humanFriendliness: 7.0,
      happinessIndex: 4.5,
      famousFoods: ['Butter Chicken', 'Chole Bhature', 'Street Chaat'],
      places: ['Red Fort', 'India Gate', 'Lotus Tapınağı', 'Jama Mescidi'],
      interestingFacts: [
        'Kaos ve tarihin birleştiği devasa başkent',
        'Hindistan\'ın en büyük baharat pazarına sahip',
      ],
      socialInfo:
          'Aşırı kalabalık, trafik karmaşası, sokak yemekleri kültürü; inanılmaz bir kültür şoku yaşatır.',
    ),
  },
  'MX': {
    'Meksika Şehri': RegionSocialInfo(
      safetyLevel: 'Tehlikeli',
      humanFriendliness: 8.5,
      happinessIndex: 6.0,
      famousFoods: ['Tacos al Pastor', 'Chilaquiles', 'Tamales'],
      places: [
        'Zocalo Meydanı',
        'Antropoloji Müzesi',
        'Chapultepec Kalesi',
        'Frida Kahlo Evi',
      ],
      interestingFacts: [
        'Eski Aztek başkenti Tenochtitlan üzerine kuruludur',
        'Her yıl birkaç cm batmaktadır',
      ],
      socialInfo:
          'Çok renkli, müzik ve sanat dolu sokaklar. Bazı mahallelerde yüksek güvenlik riski.',
    ),
  },
  'KR': {
    'Seul': RegionSocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 7.0,
      happinessIndex: 6.0,
      famousFoods: [
        'Kore Barbeküsü',
        'Chimaek (Tavuk-Bira)',
        'Street Food (Hongdae)',
      ],
      places: [
        'Gyeongbokgung Sarayı',
        'Bukchon Hanok',
        'Gangnam',
        'Myeongdong',
      ],
      interestingFacts: [
        'Geleneksel saraylar ile gökdelenler yan yanadır',
        'Gece 3\'te bile kafeler doludur',
      ],
      socialInfo:
          'Teknoloji ile iç içe, çok hızlı tempoda yaşayan, cilt bakımına ve modaya çok düşkün toplum.',
    ),
  },
};

// Map country codes to their SMap class names (for countries_world_map package)
const Map<String, String> countryCodeToSMapName = {
  'GR': 'SMapGreece',
  'BG': 'SMapBulgaria',
  'GE': 'SMapGeorgia',
  'IR': 'SMapIran',
  'IQ': 'SMapIraq',
  'SY': 'SMapSyria',
  'AZ': 'SMapAzerbaijan',
  'AM': 'SMapArmenia',
  'CY': 'SMapCyprus',
  'RU': 'SMapRussia',
  'UA': 'SMapUkraine',
  'EG': 'SMapEgypt',
  'SA': 'SMapSaudiArabia',
  'DE': 'SMapGermany',
  'FR': 'SMapFrance',
  'IT': 'SMapItaly',
  'GB': 'SMapUnitedKingdom',
  'US': 'SMapUnitedStates',
  'JP': 'SMapJapan',
  'BR': 'SMapBrazil',
  'ES': 'SMapSpain',
  'NL': 'SMapNetherlands',
  'CH': 'SMapSwitzerland',
  'CA': 'SMapCanada',
  'AU': 'SMapAustralia',
  'CN': 'SMapChina',
  'IN': 'SMapIndia',
  'MX': 'SMapMexico',
  'KR': 'SMapSouthKorea',
};
