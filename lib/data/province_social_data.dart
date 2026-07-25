// Province & District social info data

class SocialInfo {
  final String
  safetyLevel; // Güvenli, Ortalama, Az Tehlikeli, Tehlikeli, Çok Tehlikeli
  final double humanFriendliness; // 0-10
  final double happinessIndex; // 0-10
  final List<String> famousFoods;
  final List<String> foodPlaces;
  final List<String> interestingFacts;
  final String socialPopulation;

  const SocialInfo({
    required this.safetyLevel,
    required this.humanFriendliness,
    required this.happinessIndex,
    required this.famousFoods,
    required this.foodPlaces,
    required this.interestingFacts,
    required this.socialPopulation,
  });
}

// Get social info for a province (by plate code)
SocialInfo getProvinceSocialInfo(int plateCode) {
  return _provinceSocialData[plateCode] ?? _defaultInfo;
}

// Get social info for a district
SocialInfo getDistrictSocialInfo(int plateCode, String districtName) {
  final districtMap = _districtSocialData[plateCode];
  if (districtMap != null && districtMap.containsKey(districtName)) {
    return districtMap[districtName]!;
  }
  // Fallback to province-level data
  return getProvinceSocialInfo(plateCode);
}

const _defaultInfo = SocialInfo(
  safetyLevel: 'Ortalama',
  humanFriendliness: 6.0,
  happinessIndex: 5.5,
  famousFoods: ['Yöresel kebap', 'Ev yapımı mantı'],
  foodPlaces: ['Şehir merkezi lokantaları'],
  interestingFacts: ['Anadolu\'nun kadim toprakları'],
  socialPopulation: 'Geleneksel Anadolu yaşam tarzı hâkim.',
);

const Map<int, SocialInfo> _provinceSocialData = {
  // 1 - Adana
  1: SocialInfo(
    safetyLevel: 'Az Tehlikeli',
    humanFriendliness: 7.5,
    happinessIndex: 6.0,
    famousFoods: [
      'Adana Kebap',
      'Şalgam',
      'Bici bici',
      'Analı kızlı çorba',
      'Taş kadayıf',
    ],
    foodPlaces: ['Kebapçı Hasan Usta', 'Yüzevler Kebap', 'Ciğerci Mahmut'],
    interestingFacts: [
      'Türkiye\'nin en sıcak şehirlerinden biri',
      'Dünya\'nın en eski köprülerinden Taşköprü burada',
      'Portakal üretiminde lider',
    ],
    socialPopulation:
        'Sıcakkanlı, yardımsever ama mahallelerde dikkatli olunmalı.',
  ),
  // 2 - Adıyaman
  2: SocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 7.0,
    happinessIndex: 5.5,
    famousFoods: ['Çiğ köfte', 'Besni cevizi', 'Küncülü ekmek'],
    foodPlaces: ['Nemrut Sofrası', 'Çiğ köfteci Ömer'],
    interestingFacts: [
      'Nemrut Dağı UNESCO Dünya Mirası',
      '2023 depreminden büyük hasar gördü',
    ],
    socialPopulation: 'Misafirperver ve geleneksel yapı.',
  ),
  // 3 - Afyonkarahisar
  3: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 6.5,
    famousFoods: ['Sucuk', 'Kaymak', 'Lokum', 'Manti'],
    foodPlaces: ['İkbal Lokantası', 'Afyon Sucuk Evi'],
    interestingFacts: [
      'Türkiye\'nin sucuk başkenti',
      'Termal turizm merkezi',
      'Afyon Kalesi 226m yükseklikte',
    ],
    socialPopulation: 'Sakin, huzurlu ve güler yüzlü insanlar.',
  ),
  // 4 - Ağrı
  4: SocialInfo(
    safetyLevel: 'Az Tehlikeli',
    humanFriendliness: 6.5,
    happinessIndex: 4.5,
    famousFoods: ['Abdigör köftesi', 'Kesme aşı çorbası'],
    foodPlaces: ['Ağrı Sofrası'],
    interestingFacts: [
      'Türkiye\'nin en yüksek dağı Ağrı Dağı (5137m)',
      'Nuh\'un Gemisi efsanesi',
    ],
    socialPopulation: 'Misafirperver ama zor coğrafi koşullar.',
  ),
  // 5 - Amasya
  5: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.0,
    happinessIndex: 7.0,
    famousFoods: ['Amasya elması', 'Keşkek', 'Toyga çorbası'],
    foodPlaces: ['Şehzadeler Sofrası'],
    interestingFacts: [
      'Şehzadeler şehri',
      'Kral Kaya Mezarları 2000 yıldan eski',
    ],
    socialPopulation: 'Kültürlü, sakin ve tarih bilincine sahip toplum.',
  ),
  // 6 - Ankara
  6: SocialInfo(
    safetyLevel:
        'Çok Güvenli (Merkez/Kamu Alanları) / Dikkatli (Kenar Mahalleler)',
    humanFriendliness: 7.0,
    happinessIndex: 7.0,
    famousFoods: [
      'Ankara Döneri',
      'Ankara Simidi (Pekmezli)',
      'AOÇ Dondurması',
      'Çubuk Turşusu',
      'Beypazarı Kurusu',
      'Ankara Tava',
      'Kokoreç (AOÇ, Ulus)',
    ],
    foodPlaces: [
      'Tarihi Uludağ Kebapçısı (Ulus)',
      'Süha Döner',
      'Mutlu Döner (Ayrancı)',
      'AOÇ Satış Mağazaları ve Piknik Alanı',
      'Tarihi Çubuk Turşucuları',
      'Beypazarı Tarihi Fırınları',
      'Kardelen (Dondurma)',
    ],
    interestingFacts: [
      'Türkiye Cumhuriyeti\'nin kalbi ve başkentidir. Kurtuluş Savaşı buradan yönetilmiştir.',
      'Mustafa Kemal Atatürk\'ün anıt mezarı olan Anıtkabir buradadır ve her yıl milyonlarca insan ziyaret eder.',
      'Türkiye\'nin en fazla üniversite öğrencisine ve memur/bürokrat nüfusuna ev sahipliği yapar.',
      'Denize kıyısı olmamasına rağmen Eymir, Mogan ve Göksu gibi büyük göllere/göletlere sahiptir.',
      'Anadolu Medeniyetleri Müzesi, Avrupa\'da Yılın Müzesi seçilmiş eşsiz bir koleksiyona sahiptir.',
    ],
    socialPopulation:
        'Son derece düzenli, kuralcı ve disiplinli; Türkiye\'nin en yüksek eğitim, bürokrasi ve memur seviyesine sahip, soğuk havasına inat samimi kültürü.',
  ),
  // 7 - Antalya
  7: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.0,
    happinessIndex: 7.5,
    famousFoods: ['Piyaz', 'Tandır kebabı', 'Şiş köfte', 'Portakal reçeli'],
    foodPlaces: ['Seraser Fine Dining', '7 Mehmet', 'Can Can Pide'],
    interestingFacts: [
      'Yılda 15M+ turist',
      'Dünya\'nın en çok mavi bayraklı plajlarına sahip illerden',
      'Düden Şelalesi denize dökülür',
    ],
    socialPopulation: 'Kozmopolit, turist dostu, rahat yaşam tarzı.',
  ),
  // 8 - Artvin
  8: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 7.0,
    famousFoods: ['Kuymak', 'Laz böreği', 'Mısır ekmeği'],
    foodPlaces: ['Artvin Sofrası'],
    interestingFacts: [
      'Türkiye\'nin en yeşil ili',
      'Borçka Karagöl doğa harikası',
    ],
    socialPopulation: 'Samimi, doğa ile iç içe yaşayan insanlar.',
  ),
  // 9 - Aydın
  9: SocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 9.0,
    happinessIndex: 8.5,
    famousFoods: [
      'Aydın İnciri (Avrupa Birliği tescilli coğrafi işaret)',
      'Çine Köftesi',
      'Yenipazar Pidesi',
      'Bozdoğan Pidesi',
      'Keşkek (Özellikle düğünlerin vazgeçilmezi)',
      'Zeytinyağlı Kereviz ve Ege Otları',
      'Paşa Böreği',
      'Kabak Tatlısı (Tahinli ve cevizli)',
      'Yuvarlama (Aydın usulü)',
      'Sıkma',
      'Dalama Tandırı',
    ],
    foodPlaces: [
      'Tarihi Sarıoğlu Lokantası (Esnaf Lokantası kültürü için)',
      'Köse Usta Çine Köftecisi (Meşhur Çine köftesinin adresi)',
      'Sümer Pide Yenipazar (Bölgenin en iyi pidelerinden)',
      'Mikado Pide (Bozdoğan Pidesi için efsanevi durak)',
      'Değirmen Restoran Kuşadası (Doğa ve organik lezzetler)',
      'Kazım Usta Balık Evi Kuşadası (Efsanevi deniz ürünleri)',
      'Garaj Kebap Çöp Şiş Söke (Şiş ve etin muhteşem birleşimi)',
      'Zeytinli Konak Restoran (Ege otları ve zeytinyağlılar)',
      'Dalama Tandır Salonu (Tarihi ve yöresel tandır)',
      'Şokella (Meşhur Aydın dondurmacısı)',
      'Dönerci Hacı Beli (Efeler)',
      'Macar Kardeşler Lokantası (Geleneksel tatlar)',
      'Aşçı Yusuf Lokantası (Efeler merkez esnaf lokantası)',
      'Gültekin Pide (Köşk/Efeler yolu eşsiz lezzet)',
      'AYTO Restoran (Aydın Ticaret Odası)',
      'Kalyon Çöp Şiş (Meşhur şiş duraklarından)',
    ],
    interestingFacts: [
      'Türkiye\'nin ilk demiryolu hattı İzmir-Aydın arasında kurulmuştur.',
      'Dünya incir üretiminde kesin bir dünya lideridir.',
      'Antik dönemde "Gökyüzünün altındaki en güzel yeryüzü" olarak tasvir edilmiştir (Herodot).',
      'Kestane üretiminde de Türkiye birincisidir (Bozdağ etekleri).',
      'Eski adı Tralleis olup, dünyaca ünlü Seikilos Epitafı (bilinen en eski müzik eseri) burada bulunmuştur.',
      'Zeybek kültürünün ve Efe geleneğinin başkentidir.',
      'Antik dünyanın felsefe, sanat ve bilim merkezlerinden Milet ve Aphrodisias buradadır.',
    ],
    socialPopulation:
        'Ege\'nin sıcakkanlı, misafirperver, yöresel kültürüne bağlı (Zeybek kültürü) ve çok hoşgörülü insanlarından oluşur. Tarihle ve doğayla iç içe, huzurlu bir yaşam tarzı hakimdir.',
  ),
  // 10 - Balıkesir
  10: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 8.0,
    famousFoods: [
      'Höşmerim Tatlısı',
      'Ayvalık Tostu',
      'Susurluk Ayranı',
      'Edremit Zeytinyağı',
      'Balıkesir Kaymaklısı',
      'Manyas Kelle Peyniri',
      'Bigadiç Helvası',
    ],
    foodPlaces: [
      'Cumhuriyet Lokantası (Merkez Efsanesi)',
      'Susurluk Yasa Tesisleri (Tost ve Ayran)',
      'Edremit Güre Balıkçıları',
      'Cunda Taş Kahve (Ayvalık)',
      'Mesut Usta Ayvalık Tostçusu',
      'Hacı Eşref Efendi (Höşmerimcisi)',
    ],
    interestingFacts: [
      'Hem Marmara hem Ege Denizi\'ne kıyısı olan nadir bir Türkiye şehridir.',
      'Kazdağları (İda Dağı) ile dünyanın en önemli oksijen rezervlerinden birine ev sahipliği yapar.',
      'İlk kurşunun atıldığı kahraman Kuvâ-yi Milliye şehridir.',
      'Sofraların vazgeçilmezi zeytin ve zeytinyağında (özellikle Edremit) dünya çapında bir markadır.',
      'İki denize sahili olması hasebiyle inanılmaz bir biyoçeşitlilik sunar.',
    ],
    socialPopulation:
        'Ege\'nin rahatlığı ile Marmara\'nın ciddiyetini harmanlamış, toprak anaya ve zeytine aşık, inanılmaz misafirperver (Yörük ve Manav) bir halk.',
  ),
  // 16 - Bursa
  16: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.0,
    happinessIndex: 7.0,
    famousFoods: [
      'İskender kebap',
      'Kestane şekeri',
      'İnegöl köfte',
      'Pideli köfte',
      'Cantık',
    ],
    foodPlaces: ['Kebapçı İskender', 'İnegöl Köftecisi Osman'],
    interestingFacts: [
      'İlk Osmanlı başkenti',
      'Uludağ kayak merkezi',
      'İpek ve havlu üretiminde lider',
    ],
    socialPopulation: 'Büyükşehir dinamiği, sanayisi güçlü, kültürlü.',
  ),
  // 21 - Diyarbakır
  21: SocialInfo(
    safetyLevel: 'Az Tehlikeli',
    humanFriendliness: 8.0,
    happinessIndex: 5.0,
    famousFoods: [
      'Kaburga dolması',
      'Ciğer kebabı',
      'Kadayıf dolması',
      'Meftune',
    ],
    foodPlaces: ['Hasan Paşa Hanı restoranları', 'Ciğerci Fırat'],
    interestingFacts: [
      'Surları UNESCO listesinde',
      'Dünyanın en uzun ikinci surları',
      'On Gözlü Köprü tarihi eser',
    ],
    socialPopulation:
        'Çok misafirperver ama bazı bölgelerde dikkatli olunmalı.',
  ),
  // 27 - Gaziantep
  27: SocialInfo(
    safetyLevel: 'Ortalama',
    humanFriendliness: 8.5,
    happinessIndex: 6.5,
    famousFoods: [
      'Antep baklavası',
      'Lahmacun',
      'Antep fıstığı',
      'Katmer',
      'Beyran',
      'Ali Nazik',
    ],
    foodPlaces: ['İmam Çağdaş', 'Bayazhan', 'Metanet Lokantası'],
    interestingFacts: [
      'UNESCO Gastronomi Şehri',
      'Zeugma Mozaik Müzesi dünyanın en büyüğü',
      'Baklavada 40 kat yufka kullanılır',
    ],
    socialPopulation: 'Yemek kültürü çok güçlü, girişimci ve çalışkan.',
  ),
  // 34 - İstanbul
  // 34 - İstanbul
  34: SocialInfo(
    safetyLevel: 'Güvenli (Turistik Alanlar) / Dikkatli (Banliyöler)',
    humanFriendliness: 7.0,
    happinessIndex: 6.5,
    famousFoods: [
      'Sultanahmet Köftesi',
      'Eminönü Balık Ekmek',
      'Ortaköy Kumpiri',
      'Vefa Bozası',
      'Süleymaniye Kuru Fasulyesi',
      'Kanlıca Yoğurdu',
      'Sarıyer Böreği',
      'Beyoğlu Çikolatası',
      'Islak Hamburger',
    ],
    foodPlaces: [
      'Tarihi Sultanahmet Köftecisi',
      'Karaköy Güllüoğlu',
      'Hafız Mustafa 1864',
      'Vefa Bozacısı',
      'Kızılkayalar (İstiklal)',
      'Tarihi Kanlıca Yoğurtçusu',
      'Hamdi Restoran (Eminönü)',
    ],
    interestingFacts: [
      'Tarih boyunca Roma, Bizans ve Osmanlı olmak üzere 3 büyük imparatorluğa başkentlik yapmıştır.',
      'Asya ve Avrupa kıtalarını birbirine bağlayan, ortasından deniz (Boğaziçi) geçen dünyadaki tek metropoldür.',
      '1500 yıllık Ayasofya ve devasa yer altı sarnıçları (Yerebatan) gibi dünya harikalarını barındırır.',
      'Güncel nüfusu, aralarında Belçika ve Yunanistan\'ın da bulunduğu 130\'dan fazla ülkenin nüfusundan fazladır.',
      'Kapalıçarşı, dünyada inşa edilen en eski ve en büyük alışveriş merkezidir.',
    ],
    socialPopulation:
        'Dünyanın her yerinden, her kültürden, inançtan ve statüden insanın bir arada yaşadığı, 24 saat uyumayan inanılmaz kozmopolit, devasa ve hızlı akan bir metropol.',
  ),
  // 35 - İzmir
  35: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 7.5,
    famousFoods: [
      'Boyoz',
      'Kumru',
      'İzmir Köfte',
      'Lokma',
      'Söğüş',
      'Şambali Tatlısı',
      'Tulum Peyniri',
      'Bomba',
      'Midye Dolma',
    ],
    foodPlaces: [
      'Deniz Restoran (Kordon VIP deniz ürünleri)',
      'Dostlar Fırını (Alsancak meşhur Boyoz)',
      'Kumrucu Şevki (Bostanlı/Çeşme)',
      'Reyhan Pastanesi (Alsancak)',
      'Meşhur Hisarönü Şambalicisi (Kemeraltı)',
      'Tarihi Asansör Restoran (Karataş)',
      'Yengeç Restaurant (Urla)',
      'Söğüşçü Cemo (Kemeraltı)',
    ],
    interestingFacts: [
      'Türkiye\'nin en özgürlükçü ve kültür/sanata en düşkün şehri olarak bilinir.',
      'Kemeraltı Meydanı\'ndaki Saat Kulesi şehrin mutlak sembolüdür.',
      '8500 yıllık bir yerleşim geçmişine (Yeşilova Höyüğü) sahiptir.',
      'Kordon boyu çimlerinde gün batımında oturmak bir İzmir ritüelidir.',
      'Efes, Pergamon (Bergama) gibi dünyaca ünlü UNESCO miraslarını barındırır.',
    ],
    socialPopulation:
        'Son derece modern, açık fikirli, aceleci olmayan ve stresten uzak "Ege rahatlığına" sahip, denize aşık insanlar.',
  ),
  // 42 - Konya
  42: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.0,
    happinessIndex: 6.5,
    famousFoods: [
      'Etli ekmek',
      'Fırın kebabı',
      'Bamya çorbası',
      'Mevlana şekeri',
    ],
    foodPlaces: ['Tiritçi Hüsrev', 'Bolu Kebapçısı'],
    interestingFacts: [
      'Mevlana\'nın şehri',
      'Türkiye\'nin en büyük yüzölçümüne sahip ili',
      'Çatalhöyük 9000 yıllık yerleşim',
    ],
    socialPopulation: 'Muhafazakar ama misafirperver, sakin yaşam.',
  ),
  // 43 - Kütahya
  43: SocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 8.0,
    famousFoods: [
      'Cimcik',
      'Sıkıcık Çorbası',
      'Kütahya Göveci',
      'Tosunum',
      'Kürtül',
    ],
    foodPlaces: [
      'Tarihi Germiyan Konağı Restoranı',
      'Mülayim Usta (Merkez)',
      'Tavşanlı Leblebicileri',
      'Emet Termal Restoranları',
      'Gediz Göveççileri',
    ],
    interestingFacts: [
      'Türkiye\'nin en köklü ve dünyaca ünlü çini sanatı merkezidir.',
      'Dünyanın tam anlamıyla ilk borsasına (Aizanoi) ev sahipliği yapar.',
      'Kurtuluş Savaşı\'nın kazanıldığı Dumlupınar Meydan Muharebesi bu topraklarda gerçekleşmiştir.',
      'Yer altı kaynakları, kaplıcaları ve Murat Dağı ile Ege\'nin en önemli termal cennetidir.',
    ],
    socialPopulation:
        'Şanlı tarihi ve kültürüyle (çini, porselen) aşırı gurur duyan, geleneksel Türk örf adetlerine sıkı sıkıya bağlı misafirperver bir halk.',
  ),
  // 45 - Manisa
  45: SocialInfo(
    safetyLevel: 'Çok Güvenli',
    humanFriendliness: 8.5,
    happinessIndex: 8.0,
    famousFoods: [
      'Manisa Kebabı',
      'Mesir Macunu',
      'Akhisar Köftesi',
      'Salihli Odun Köftesi',
      'Sultaniye Üzümü',
      'Cilveli Kahve',
      'Kula Leblebisi',
      'Şevketi Bostan',
    ],
    foodPlaces: [
      'Tarihi Gülcemal Manisa Kebapçısı',
      'Ramiz Köfte (Akhisar Merkez)',
      'Odun Köfteci Şentürk (Salihli)',
      'Yeni Han Cilveli Kahvecisi',
      'Kula Tarihi Leblebicileri',
    ],
    interestingFacts: [
      'Osmanlı İmparatorluğu\'nda tahta çıkacak Padişahların (Kanuni, Fatih) devlet yönetimini öğrendiği Şehzadeler Şehridir.',
      'Uluslararası Mesir Macunu Festivali 500 yılı aşkın süredir kesintisiz kutlanmaktadır ve UNESCO somut olmayan kültür mirasıdır.',
      'Parayı icat eden Lidya Krallığı\'nın başkenti (Sardes Antik Kenti) buradadır.',
      'Türkiye\'nin en büyük Avrupa tarım ihracatçısı (Sultaniye üzümü ve zeytin) unvanını taşır ve Vestel City gibi devasa elektronk sanayisine sahiptir.',
    ],
    socialPopulation:
        'Tarım ve sanayi devrimini inanılmaz bir uyumla harmanlamış, tarihine son derece bağlı, misafirperver ve samimi bir Ege-Yörük toplumu.',
  ),
  // 48 - Muğla
  48: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 8.0,
    famousFoods: ['Bodrum mandalinası', 'Çökertme kebabı', 'Ot yemekleri'],
    foodPlaces: ['Bodrum Balıkçısı', 'Fethiye Fish Market'],
    interestingFacts: [
      'Bodrum-Marmaris turizm cennetleri',
      'Kaunos antik kenti',
      'Dalyan caretta caretta üreme alanı',
    ],
    socialPopulation: 'Turistik, rahat ve huzurlu yazlık yaşam.',
  ),
  // 55 - Samsun
  55: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.0,
    happinessIndex: 6.5,
    famousFoods: ['Pide', 'Bafra nokulu', 'Karalahana sarması'],
    foodPlaces: ['Pideci Osman'],
    interestingFacts: [
      '19 Mayıs 1919 Kurtuluş Savaşı başlangıcı',
      'Bandırma Vapuru burada',
    ],
    socialPopulation: 'Karadeniz kültürü, samimi ve sıcakkanlı.',
  ),
  // 61 - Trabzon
  61: SocialInfo(
    safetyLevel: 'Güvenli',
    humanFriendliness: 7.5,
    happinessIndex: 7.0,
    famousFoods: [
      'Akçaabat köfte',
      'Kuymak',
      'Karalahana çorbası',
      'Laz böreği',
      'Hamsi tava',
    ],
    foodPlaces: ['Cemilusta', 'Nihat Usta'],
    interestingFacts: [
      'Sümela Manastırı kayalara oyulmuş',
      'Uzungöl doğa harikası',
      'Hamsi kültürü çok güçlü',
    ],
    socialPopulation:
        'Enerjik, futbol tutkunu, misafirperver Karadeniz insanı.',
  ),
  // 30 - Hakkari
  30: SocialInfo(
    safetyLevel: 'Tehlikeli',
    humanFriendliness: 7.0,
    happinessIndex: 4.0,
    famousFoods: ['Hakkari kebabı', 'Tandır ekmeği'],
    foodPlaces: ['Yerel lokantalar'],
    interestingFacts: ['Cilo Dağları 4000m+', 'Sınır bölgesi'],
    socialPopulation: 'Misafirperver ama güvenlik durumu hassas.',
  ),
  // 73 - Şırnak
  73: SocialInfo(
    safetyLevel: 'Tehlikeli',
    humanFriendliness: 6.5,
    happinessIndex: 4.0,
    famousFoods: ['Tandır ekmeği', 'Yöresel peynir'],
    foodPlaces: ['Yerel lokantalar'],
    interestingFacts: ['Cizre tarihi kent', 'Habur Sınır Kapısı'],
    socialPopulation: 'Sınır ili, güvenlik hassasiyeti var.',
  ),
};

// District-level social data (major cities only)
const Map<int, Map<String, SocialInfo>> _districtSocialData = {
  // 6 - Ankara ilçeleri
  6: {
    'Çankaya': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 8.5,
      famousFoods: [
        'Tunalı Vitamin (Meyve Suyu/Tost)',
        'Ayrancı Ankara Döneri',
        'Kıtır (Kumpir/Kokoreç)',
      ],
      foodPlaces: [
        'Mutlu Döner (Ayrancı)',
        'Kıtır (Tunalı)',
        'Arjantin Caddesi Kafeleri',
        'GOP Restoranları',
      ],
      interestingFacts: [
        'TBMM, tüm devasa bakanlıklar, Cumhurbaşkanlığı Köşkü ve büyükelçilikler bu sınırların içindedir.',
        'Tunalı Hilmi Caddesi, Kuğulu Park ve Seğmenler Parkı gibi başkentin tüm elit sosyalleşme alanları buradadır.',
        'Türkiye\'nin eğitim düzeyi ve gelir seviyesi en yüksek ilçelerinin başında gelir.',
      ],
      socialPopulation:
          'Bürokratlar, diplomatlar, akademisyenler ve köklü Ankara yerlilerinin bir arada yaşadığı son derece elit ve kuralcı Avrupa standartlarında bir başkent merkezi.',
    ),
    'Yenimahalle': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.0,
      happinessIndex: 7.5,
      famousFoods: ['AOÇ Dondurması ve Sütü', 'Kokoreç', 'Midye'],
      foodPlaces: [
        'Atatürk Orman Çiftliği Kokoreççileri',
        'Merkez Lokantası (AOÇ)',
        'Ostim Sanayi Esnaf Lokantaları',
      ],
      interestingFacts: [
        'Atatürk\'ün emriyle bataklıkların kurutulmasıyla kurulan devasa Atatürk Orman Çiftliği (AOÇ) buradadır.',
        'Türkiye\'nin en büyük sanayi merkezlerinden biri olan OSTİM ve İvedik organize sanayisi buradadır.',
        'MİT ve devlete ait stratejik kampüslerin bir bölümü Yenimahalle\'dedir.',
      ],
      socialPopulation:
          'Geniş bulvarlarda yaşayan köklü memur aileleri ile sanayi bölgesinde çalışan farklı sınıfların buluştuğu sakin bir mozaik.',
    ),
    'Altındağ': SocialInfo(
      safetyLevel: 'Dikkatli Olunmalı (Dış Mahalleler) / Güvenli (Müzeler)',
      humanFriendliness: 6.5,
      happinessIndex: 6.0,
      famousFoods: ['Ulus Döneri', 'Ankara Simidi', 'Pide'],
      foodPlaces: [
        'Tarihi Uludağ Dönercisi',
        'Ulus Hali İçi Esnaf Lokantaları',
        'Hamamönü Kahvecileri',
      ],
      interestingFacts: [
        'Ankara\'nın asıl eski ve tarihi merkezidir; I. ve II. meclis, Ankara Kalesi ve Anadolu Medeniyetleri Müzesi buradadır.',
        'Cumhuriyetin ilk yıllarındaki görkemli taş binaların hepsine ev sahipliği yapar.',
        'Mehmet Akif Ersoy, İstiklal Marşı\'nı Altındağ sınırları içindeki Tacettin Dergahı\'nda (Hamamönü) yazmıştır.',
      ],
      socialPopulation:
          'Merkezinde yüksek bir turist/müze yoğunluğu varken; gecekondu mahallelerinde göçle gelmiş, geleneksel bağlarına sıkı tutunan muhafazakar ve hareketli bir demografik yapı.',
    ),
    'Keçiören': SocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.0,
      happinessIndex: 6.5,
      famousFoods: ['Teleferik Kafe Et Döner', 'Pide', 'Gözleme'],
      foodPlaces: [
        'Estergon Kalesi Restoranları',
        'Ihlamur Vadisi Kafeleri',
        'Tepebaşı Restoranları',
      ],
      interestingFacts: [
        'Nüfus yoğunluğu açısından Türkiye\'nin en kalabalık ilçelerinden biridir.',
        'Avrupa başkentlerine nam salmış ünlü devasa bir Teleferiğe ve Tuna Nehri kıyısındakinin aynısı olan Estergon Türk Kültür Merkezi (Kalesi) kopyasına sahiptir.',
        'İlçenin her yerinden yapay şelaleler ve gösterişli aydınlatmalar fışkırır.',
      ],
      socialPopulation:
          'Türkiye\'nin dört bir yanından göç edip memuriyet veya ticaretle tutunmuş; oldukça yoğun, yoğun muhafazakar ve aile odaklı bir yapı.',
    ),
    'Gölbaşı': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: ['Mogan Gölü Balığı', 'Sac Kavurma', 'Köy Kahvaltısı'],
      foodPlaces: [
        'Eymir Gölü Tesisleri',
        'Mogan Sahili Restoranları',
        'İncek Et Mangal Tesisleri',
      ],
      interestingFacts: [
        'Ankara\'nın denizi görevini üstlenen Mogan ve Eymir gölleri bu ilçededir.',
        'Ankara elitlerinin inşa ettirdiği devasa özel okullar ve lüks villa kentleri (İncek) sınırları içerisinde yükselir.',
        'Özel Harekat Daire Başkanlığı ve dev savunma kampüsleri buradadır.',
      ],
      socialPopulation:
          'Hafta sonları tüm Ankara\'nın nefes almak için akın ettiği bir rekreasyon alanı. İncek tarafında ultra lüks zengin bir nüfus yaşarken, göl kenarında yerel işletmeciler bulunur.',
    ),
    'Etimesgut': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: [
        'Eryaman Dönercileri',
        'Kumpir',
        'Aşure (Geleneksel Festivallerde)',
      ],
      foodPlaces: [
        'Göksu Parkı Restoranları ve İskele Kafeleri',
        'Eryaman Meydan Lokantaları',
      ],
      interestingFacts: [
        'Göksu devasa gölet parkı ile Ankara\'nın büyük bir sosyalleşme alanıdır.',
        'Türkiye\'nin en büyük askeri zırhlı birlikleri ve hava üsleri burada konumlanmıştır.',
        'Yeni nesil yatay/dikey dev site ve uydu kent (Eryaman, Bağlıca) kurulumlarının en hızlı olduğu merkezdir.',
      ],
      socialPopulation:
          'Devasa sitelerde yaşayan asker aileleri, yeni atanmış genç memurlar ve özel sektör profesyonellerinden oluşan güvenli bir "Uydu Kent" kültürü.',
    ),
    'Beypazarı': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.5,
      famousFoods: [
        'Beypazarı Kurusu',
        'Beypazarı Güveci',
        'Havuç Lokumu',
        'Havuç Suyu',
        'Tarhana',
      ],
      foodPlaces: [
        'Tarihi Taş Mektep Restoranı',
        'Bağözü Vadisi Alabalık Tesisleri',
        'Tarihi Çarşı Fırınları',
      ],
      interestingFacts: [
        'Osmanlı ahşap sivil mimarisini Türkiye\'de Safranbolu ile birlikte en iyi koruyan tarihi evler (Konaklar) merkezidir.',
        'Türkiye\'nin havuç üretiminin yaklaşık %60\'ını tek başına karşılar, şehrin merkezinde devasa bir havuç heykeli vardır.',
        'Gümüş telkari sanatında Türkiye\'deki en usta ellerin merkezidir.',
      ],
      socialPopulation:
          'Tarihine ve atalarına aşırı bağlı, geleneksel Türk/Anadolu el sanatlarını (telkari, bakırcılık) babadan oğula sürdüren mükemmel esnaf ve misafirperver halk.',
    ),
  },
  // 9 - Aydın ilçeleri
  9: {
    'Efeler': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: [
        'İncir',
        'Zeytinyağlılar',
        'Paşa Böreği',
        'Çine Köftesi',
        'Tahinli Pide',
        'Aydın Kebabı',
        'Kırlı Tencere',
      ],
      foodPlaces: [
        'Tarihi Sarıoğlu Lokantası (Esnaf Lokantası)',
        'Zincirlihan (Nostaljik kahvaltı)',
        'Aşçı Yusuf Lokantası (Geleneksel Türk Mutfağı)',
        'Dönerci Hacı Beli',
        'Kebapçı Enver Usta',
        'Develi Pide Serçeköy',
        'Fibooo Şırdan ve Kokoreç',
      ],
      interestingFacts: [
        'Aydın\'ın merkez ilçesidir.',
        'Eski adı Güzelhisar ve Tralleis\'tir. Tralleis Antik Kenti tam şehrin üzerindedir.',
        'Zeybek kültürünün atan kalbidir, düğünlerde mutlaka zeybek oynanır.',
        'Tarihi Aydın Evleri (Kozdibi ve Hasanefendi) koruma altındadır.',
      ],
      socialPopulation:
          'Memur, öğrenci ve yerel esnafın ağırlıkta olduğu, her hafta sonu yaylalara veya denize inen; geleneksel Ege şehir yaşamına çok sıkı bağlı sıcakkanlı halk.',
    ),
    'Kuşadası': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: ['Deniz ürünleri', 'Ege otları', 'Şeftali'],
      foodPlaces: [
        'Değirmen Restoran (Organik köy kahvaltısı)',
        'Kazım Usta Okyanus Balık Evi',
        'Macit Restoran (Deniz Ürünleri)',
        'Marvista Restaurant',
        'Erzincan Restoran (Geleneksel Ege Otları)',
        'Kaleiçi Deniz Ürünleri Balıkçıları',
      ],
      interestingFacts: [
        'Türkiye\'de turizmin ilk başladığı yerlerdendir.',
        'Güvercinada ve Kadınlar Denizi plajı çok ünlüdür.',
        'Kruvaziyer gemilerinin ana durağıdır.',
      ],
      socialPopulation:
          'Çok kültürlü, turist dostu, yaz aylarında nüfusu 1 milyonu aşan kozmopolit yapı.',
    ),
    'Söke': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: ['Söke Pidesi', 'Tahinli Pide', 'Tatlı Maya Ekmeği'],
      foodPlaces: [
        'Şafak Pide (Söke Pidesi ustası)',
        'Garaj Kebap Çöp Şiş (Meşhur çöp şiş)',
        'Kemalpaşa Tatlıcısı Söke',
        'Söke İstasyon Caddesi Pidecileri',
      ],
      interestingFacts: [
        'Pamuk üretiminde Türkiye birincisidir.',
        'Priene Antik Kenti ve Bafa Gölü sınırları içindedir.',
        'İlk alışveriş caddelerinden birine sahiptir.',
      ],
      socialPopulation:
          'Tarıma ve sanayiye dayalı güçlü bir ekonomi; zeybek kültürüne çok bağlı yerel halk.',
    ),
    'Didim': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.5,
      famousFoods: ['Balık ve Meze', 'Zeytinyağlı Yemekler', 'İncir'],
      foodPlaces: [
        'Vista Restaurant (Marina manzaralı)',
        'Kamacı Restoran (Didim deniz ürünleri turu)',
        'Alo24 Didim',
        'Topkapı Restoran',
        'Akbük Balıkçıları',
        'Altınkum Sahil Restoranları',
      ],
      interestingFacts: [
        'Dünyaca ünlü Apollon Tapınağı buradadır.',
        'Türkiye\'nin Küçük Britanya\'sı: Büyük bir İngiliz göçmen (expat) nüfusu yaşar.',
        'Altınkum, sığ deniziyle çok ünlüdür.',
      ],
      socialPopulation:
          'İngiliz yerleşik nüfusu ve yazlıkçılarla renkli, oldukça rahat ve özgürlükçü sahil yaşamı.',
    ),
    'Nazilli': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: [
        'Nazilli Pidesi',
        'Kar Helvası',
        'Zeytinyağlı Kereviz',
        'Kestane Şekeri',
      ],
      foodPlaces: [
        'Uğur Pide (Yarım asırlık efsane)',
        'Kısmet Pide',
        'Gülüçoğlu Pide',
        'Uzun Çarşı Lezzet Durakları',
      ],
      interestingFacts: [
        'Uzun Yaşam Şehri olarak tescillidir. 100 yaş üstü insan sayısı çok fazladır.',
        'Atatürk\'ün açtığı Nazilli Sümerbank Basma Fabrikası ile Cumhuriyetin ilk sanayi kentlerindendir.',
        'İncir üretiminde Aydın\'ın kalbidir.',
      ],
      socialPopulation:
          'Uzun yaşamın sırrını veren stresten uzak, Akdeniz diyetine sıkı sıkıya bağlı köklü ve huzurlu yerel halk.',
    ),
    'Bozdoğan': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 7.5,
      famousFoods: ['Bozdoğan Pidesi', 'Bozdoğan Sucuğu', 'Kuyu Tandır'],
      foodPlaces: [
        'Mikado Pide (Türkiye\'nin en iyi pidecilerinden)',
        'Kemer Barajı Balıkçıları',
      ],
      interestingFacts: [
        'Madran Su kaynağı ve Madran dağı eteklerindedir.',
        'Arapapıştı Kanyonu dünyanın en ilginç doğal oluşumlarındandır.',
        'Kemer Barajı ilçede göl iklimi yaratır.',
      ],
      socialPopulation:
          'Geleneksel değerlerine çok bağlı, misafirperver, hayvancılık ve ziraatla uğraşan yörük kültürü.',
    ),
    'Buharkent': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.0,
      famousFoods: ['Taze İncir', 'Zeytin'],
      foodPlaces: ['İlçe merkezindeki esnaf lokantaları'],
      interestingFacts: [
        'Türkiye\'nin ilk jeotermal enerji santrali buradadır.',
        'İlçe topraklarının altından kaynar sular çıkar.',
        'İklimi nedeniyle incirin en erken yetiştiği yerdir.',
      ],
      socialPopulation:
          'Küçük, sakin ve herkesin birbirini tanıdığı tipik sıcak Ege kasabası.',
    ),
    'Çine': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 7.0,
      famousFoods: ['Çine Köftesi (Efsanevi)', 'Çöp Şiş', 'Kavurma'],
      foodPlaces: [
        'Köse Usta Köftecisi',
        'Hasikioğlu Şişçi',
        'Enver Usta Çöp Şiş',
        'Tarihi Çınaraltı Köftecisi',
      ],
      interestingFacts: [
        'Devasa granit kayalıklarıyla sıra dışı bir coğrafyası vardır.',
        'Alabanda Antik Kenti buradadır.',
        'Türkiye\'nin feldispat ve kuvars madeni başkentidir.',
      ],
      socialPopulation:
          'Geleneksel, tarım ve hayvancılıkla ilgilenen, yeme-içmeye (özellikle et ve köfte) çok düşkün efe ruhlu insanlar.',
    ),
    'Germencik': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: ['Ortaklar Çöp Şiş', 'İncir', 'Zeytin'],
      foodPlaces: ['Ortaklar Çöp Şiş Tesisleri'],
      interestingFacts: [
        'Dünyanın en kaliteli sarılop incirleri burada yetişir.',
        'Magnesia Antik Kenti buradadır.',
        'Sayısız jeotermal kaynağa sahiptir.',
      ],
      socialPopulation:
          'Tarım zengini, düğün ve cemiyet kültürünün çok canlı yaşandığı, hareketli sosyo-ekonomik yapı.',
    ),
    'İncirliova': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: ['Deve Sucuğu', 'İncir Döneri', 'Zeytinyağlılar'],
      foodPlaces: ['Tarihi Deve Sucukçuları', 'Merkez Kahvehaneleri'],
      interestingFacts: [
        'Türkiye\'nin develerle en çok özdeşleşen, Deve Güreşleri kültürünün başkentidir.',
        'Tarım ovasının kalbindedir.',
        'Adını incir bahçelerinden alır.',
      ],
      socialPopulation:
          'Deve güreşi festivallerini yaşam tarzı haline getirmiş, efe ruhlu, eğlenceli ve sıcakkanlı Ege halkı.',
    ),
    'Karacasu': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.0,
      famousFoods: [
        'Karacasu Pidesi (Çok ince çamda pişer)',
        'Testi Kebabı',
        'Elma',
      ],
      foodPlaces: [
        'Kısmet Pide Karacasu',
        'Babadağ Pide',
        'Karacasu Pidecileri (Şenlikleri yapılır)',
      ],
      interestingFacts: [
        'UNESCO Dünya Mirası ünlü Aphrodisias Antik Kenti buradadır.',
        'Kırmızı topraklarıyla Türkiye\'nin en önemli çömlekçilik merkezlerinden biridir.',
        'Dedebağ Keşkek Hayrı 700 yılı aşkındır binlerce kişiye yemek dağıtılarak yapılır.',
      ],
      socialPopulation:
          'Sanata (çömlekçilik), felsefeye (Afrodisias etkisi) ve ustalık gerektiren işlere yatkın, son derece naif, çalışkan dağ insanları.',
    ),
    'Karpuzlu': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 7.0,
      famousFoods: ['Ege Ot Kavurması', 'Organik Zeytinyağı', 'Köy Ekmeği'],
      foodPlaces: ['Merkez Lokantası'],
      interestingFacts: [
        'Aydın\'ın nüfusça en küçük ve en sakin ilçelerinden biridir.',
        'Tarihi Alinda Antik Kenti ile aynı toprakları paylaşır.',
        'Karpuzlu ovası tamamen organik tarım kokar.',
      ],
      socialPopulation:
          'Geleneksel yörük kültürü hakimdir. Suç oranının neredeyse hiç olmadığı huzur dolu bir yaşam.',
    ),
    'Koçarlı': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: ['Çam Fıstığı (Künar)', 'Ceviz', 'Özel Koçarlı Pidesi'],
      foodPlaces: [
        'Cihanoğlu Parkı İşletmeleri (Serinletici kır bahçesi)',
        'Sarıdere Pide Salonu',
        'Günebakan Tesisleri',
      ],
      interestingFacts: [
        'Türkiye\'nin en kaliteli çam fıstıkları (Künar) Koçarlı dağlarında yetişir.',
        'Tarihi Cihanoğlu Kulesi ilçenin tam ortasındadır.',
        'Adnan Menderes Kent Ormanı ile doğa harikasıdır.',
      ],
      socialPopulation:
          'Orman köylüsü ve ova çiftçisinin kültürel karması; milliyetçi ve misafirperver yörük kökleri.',
    ),
    'Köşk': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.0,
      famousFoods: ['Kestane', 'Zeytin', 'Kuru İncir'],
      foodPlaces: ['İlçe Pazarı Esnaf Lokantaları'],
      interestingFacts: [
        'Kestane üretiminin en yoğun olduğu ilçelerdendir.',
        'Dağ köyleri inanılmaz bir oksijene sahiptir.',
        'Kurtuluş Savaşı\'nda büyük direniş göstermiş Karatepe Köyü buradadır.',
      ],
      socialPopulation:
          'Tarım ve doğaya sıkı sıkıya bağlı, geleneklerine sadık ve çok sakin ege köylüleri ve kasabalısı.',
    ),
    'Kuyucak': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 7.5,
      famousFoods: ['Narenciye (Portakal/Mandalina)', 'Şeftali', 'Zeytinyağı'],
      foodPlaces: ['Şafak Pide Kuyucak Şubesi', 'Kuyucak Dörtyol Restoranları'],
      interestingFacts: [
        'Sürekli esen serin rüzgarıyla bilinir.',
        'Nysa Antik Kenti\'nin kalıntıları ilçeye çok yakındır.',
        'Çok geniş şeftali bahçeleri vardır.',
      ],
      socialPopulation:
          'Huzur ve uzun yaşamın bir diğer adresi. Eğitim seviyesi yüksek, tarımla uğraşan bilinçli halk.',
    ),
    'Sultanhisar': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: ['Çilek (Türkiye\'nin en iyilerinden)', 'Zeytin', 'İncir'],
      foodPlaces: ['Atça Çarşısı Lokantaları', 'Nysa Yolu Gözlemecileri'],
      interestingFacts: [
        'Türkiye\'nin Paris planlı tek yerleşkesi olan Atça mahallesi buradadır.',
        'Nysa Antik Kenti sınırları içerisindedir.',
        'Malgaç Baskını ile Milli Mücadelenin kıvılcımı burada yakılmıştır.',
        'Dünyaca ünlü Çilek Festivali yapılır.',
      ],
      socialPopulation:
          'Avrupai bir şehir planına sahip Atça gibi mahalleleri sayesinde entelektüel, çağdaş, festivalleri seven çok renkli bir toplum.',
    ),
    'Yenipazar': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.5,
      happinessIndex: 9.0,
      famousFoods: ['Yenipazar Pidesi', 'Sıkma', 'Karnıyarık Tatlısı'],
      foodPlaces: ['Sümer Pide', 'Menderes Pide', 'Hedef Pide'],
      interestingFacts: [
        'Türkiye\'nin Cittaslow (Sakin Şehir) unvanlı 18 ilçesinden biridir.',
        'Milli Kahraman Yörük Ali Efe\'nin doğduğu ve müzesinin olduğu yerdir.',
        'Fırıncılık ve pidecilik sanata dönüşmüştür.',
      ],
      socialPopulation:
          'Son derece yavaş, stresten arınmış, bisiklet kullanan, sıcakkanlı ve güler yüzlü insanların yaşadığı tam bir huzur yuvası.',
    ),
  },
  // 10 - Balıkesir İlçeleri
  10: {
    'Edremit': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 9.0,
      famousFoods: [
        'Edremit Zeytinyağlıları',
        'Höşmerim',
        'Kazdağı Balı',
        'Körfez Balıkları',
      ],
      foodPlaces: [
        'Güre Sahil Balıkçıları',
        'Akçay Kordon Çay Bahçeleri',
        'Kazdağları Zirve Tesisleri',
        'Altınoluk Dondurmacıları',
      ],
      interestingFacts: [
        'Kazdağları efsanelerinin, mitolojinin ve Sarıkız destanının doğduğu topraklardır.',
        'Altınoluk mahallesi dünyanın en yoğun oksijen çadırlarından biri kabul edilir.',
        'Dünyanın en kaliteli zeytinyağlarını üretmektedir.',
      ],
      socialPopulation:
          'Ağırlıklı olarak yazlıkçı tayfa, emekli bürokratlar/öğretmenler ile yerli halkın oluşturduğu çok nezih, stresten uzak doğa aşıkları.',
    ),
    'Ayvalık': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: [
        'Ayvalık Tostu',
        'Papalina Balığı',
        'Zeytinyağı',
        'Sarımsaklı Dondurması',
      ],
      foodPlaces: [
        'Tostçular Çarşısı (Mesut Usta)',
        'Cunda Taş Kahve',
        'Bay Nihat Restaurant (Cunda)',
        'Şeytan Sofrası Tesisleri',
      ],
      interestingFacts: [
        'Cunda, Lale gibi irili ufaklı 22 adaya sahip muazzam bir takımadadır.',
        'Taş evleri, Rum mimarisi ve dar sokaklarıyla tam bir açık hava müzesidir.',
        'Şeytan Sofrasında gün batımı tüm Türkiye\'nin en ünlü aktivitelerindendir.',
      ],
      socialPopulation:
          'Geçmişin Levanten kültürü ile turizmin harmanlandığı, deniz kültürü ve balıkçılığa sıkı sıkıya bağlı gurme insanlar.',
    ),
    'Susurluk': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: [
        'Susurluk Tostu (Mihaliç Peynirli)',
        'Köpüklü Susurluk Ayranı',
        'Susurluk Çorbası',
      ],
      foodPlaces: [
        'Yasa Dinlenme Tesisleri',
        'Yörsan Tesisleri',
        'Susurluk Merkez Lokantaları',
      ],
      interestingFacts: [
        'Bursa-İzmir yolu üzerinde olması hasebiyle Türkiye\'nin en meşhur duraklama/dinlenme noktasıdır.',
        'Bol köpüklü ayranının sırrının bir tulumbadan çektirilmesinde olduğu söylenir.',
        'Eski Çerkes yerleşimlerinden biridir.',
      ],
      socialPopulation:
          'Geçiş güzergahı üzerinde sürekli bir insan sirkülasyonuna adapte olmuş, tarım ve hayvancılıkla (özellikle süt ürünleri) uğraşan hızlı çalışkan halk.',
    ),
    'Bandırma': SocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.5,
      happinessIndex: 7.5,
      famousFoods: ['Edincik Su Böreği', 'Balık Ürünleri', 'Peynir Tatlısı'],
      foodPlaces: [
        'Sahil Boyu Balıkçıları',
        'Bandırma Feribot İskelesi Mekanları',
        'Kuşcenneti Köy Kahvaltıları',
      ],
      interestingFacts: [
        'Balıkesir\'in nüfus ve ekonomi olarak en büyük ilçelerinden biridir.',
        'Manyas Kuşcenneti Milli Parkı\'nın ana giriş kapısıdır.',
        'Marmara denizi için çok önemli bir liman ve feribot merkezidir.',
      ],
      socialPopulation:
          'Liman kenti olmanın verdiği ticari dinamizm ile sanayi işçilerinin ve balıkçıların bir arada yaşadığı metropol hissiyatlı bir toplum.',
    ),
    'Burhaniye': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: ['Çizik Zeytin', 'Zeytinyağı', 'Ören Gözlemesi'],
      foodPlaces: [
        'Ören Sahili Kafeleri',
        'Pelitköy Üretici Pazarı',
        'Tarihi Adramytteion Yakını Lokantalar',
      ],
      interestingFacts: [
        'Ören plajı, asırlık palamut meşe ağaçlarıyla iç içe olduğu için kendine has çok özel bir atmosfere sahiptir.',
        'Antik Adramytteion (Edremit Körfezi adını buradan alır) kenti buradadır.',
        'Türkiye\'nin ilk tiyatrolu köyü Pelitköy buradadır.',
      ],
      socialPopulation:
          'Zeytincilik kültürünün damarlarına işlediği, yazlıkçı kalabalığı ile yerel aydın kesimin uyum içinde yaşadığı kültür-sanatsever ilçe.',
    ),
    'Erdek': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: [
        'Kırmızı Soğan',
        'Zeytin',
        'Kapıdağ Kestanesi',
        'Deniz Ürünleri',
      ],
      foodPlaces: [
        'Erdek Sahil Çay Bahçeleri',
        'Kyzikos Antik Kenti Girişi',
        'Ocaklar Sahil Lokantaları',
      ],
      interestingFacts: [
        'Türkiye\'nin turizmde ilk parlayan sayfiye yerlerinden biridir.',
        'Kapıdağ Yarımadası eteklerine kurulmuş olup, arka tarafı kapkaranlık devasa ormanlardır.',
        'Kyzikos gibi şahane bir antik kente komşudur.',
      ],
      socialPopulation:
          'Yeşil Bursa ve İstanbul\'dan kaçanların ana uğrak noktası olup, eski tatilcilik ruhunu halen koruyan nostaljik ege insanları.',
    ),
    'Gömeç': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: ['Zeytin ve Zeytinyağı', 'Ege Otları', 'Tulum Peyniri'],
      foodPlaces: ['Gömeç Sahil Balıkçıları', 'Karaağaç Meydanı Kahvehaneleri'],
      interestingFacts: [
        'İzmir-Çanakkale yolu üzerindeki Atatürk Kayalıkları direkt olarak göze çarpar.',
        'Zeytin ağacı sayısı nüfusundan çok daha fazladır.',
        'Burhaniye ile Ayvalık arasında gizli kalmış sakin bir cennettir.',
      ],
      socialPopulation:
          'Körfezin karmaşasından oldukça uzak, tam bir zeytin sevdalısı ve toprağa bağlı geleneksel Türkmen/Yörük karışımı sevecen halk.',
    ),
  },
  // 43 - Kütahya İlçeleri
  43: {
    'Merkez': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Cimcik',
        'Kütahya Göveci',
        'Ispanaklı Şibit',
        'Sıkıcık Çorbası',
      ],
      foodPlaces: [
        'Tarihi Germiyan Konağı',
        'Mülayim Usta',
        'Yoncalı Kaplıca Restoranları',
        'Sevgi Yolu Kafeleri',
      ],
      interestingFacts: [
        'Tarihi çini zanaatının ve porselen üretiminin Dünya\'daki en önemli merkezlerinden biridir.',
        'Evliya Çelebi\'nin doğduğu ve büyüdüğü topraklardır.',
        'Kütahya Kalesi şehrin her yerinden görünen ikonik bir yapıdır.',
      ],
      socialPopulation:
          'Geleneklerine, tarihine ve zanaatkârlığa (çinicilik) son derece bağlı, sakin ve misafirperver merkez ehalisi.',
    ),
    'Tavşanlı': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: [
        'Tavşanlı Leblebisi',
        'Göbel Kaplıca Yemekleri',
        'Kızılcık Turşusu',
      ],
      foodPlaces: [
        'Tarihi Tavşanlı Leblebicileri',
        'Göbel Termal Tesisleri',
        'Tavşanlı Meydan Kahvehaneleri',
      ],
      interestingFacts: [
        'Türkiye\'nin en meşhur leblebi üretim merkezlerinden biridir (Tavşanlı leblebisi).',
        'TKİ (Türkiye Kömür İşletmeleri) Linyit madenleriyle ülke ekonomisinin bel kemiklerinden biridir.',
        'Göbel kaplıcalarına ev sahipliği yapar.',
      ],
      socialPopulation:
          'Maden sanayisinin getirdiği işçi kültürü ile tarım/leblebi üretiminin harmanlandığı, çalışkan ve dayanıklı Yörük/Manav toplumu.',
    ),
    'Gediz': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: ['Gediz Göveci', 'Tarhana (Gediz Usulü)', 'Haşhaşlı Pide'],
      foodPlaces: [
        'Gediz Murat Dağı Tesisleri',
        'Ilıca Termal Restoranları',
        'Tarihi Gediz Göveççileri',
      ],
      interestingFacts: [
        'Türkiye\'nin termal kayak merkezi olan efsanevi Murat Dağı buradadır.',
        '1970 Gediz Depremi sonrası şehir tamamen başka bir yere, Yeni Gediz olarak yeniden kurulmuştur.',
        'Sıcak su ile kışın kayak yapma imkanı aynı dağdadır.',
      ],
      socialPopulation:
          'Deprem acılarını atlatarak yeni baştan doğmuş, dağ ve kaplıca kültürüne aşina sıcakkanlı insanlar.',
    ),
    'Simav': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.5,
      famousFoods: ['Simav Kestanesi', 'Simav Fasulyesi', 'Güveç', 'Cimcik'],
      foodPlaces: [
        'Eynal Kaplıcaları Tesisleri',
        'Gölcük Yaylası Piknik Alanları',
        'Simav Çarşısı Lokantaları',
      ],
      interestingFacts: [
        'Dünyaca meşhur, kebaplık iri İtalyan kestanelerine rakip Simav Kestanesi buralıdır.',
        'Eynal kaplıcalarının jeotermal enerjisiyle tüm ilçe ve seraları devasa bir sistemle ısıtılmaktadır.',
        'Gölcük krater gölü efsanedir.',
      ],
      socialPopulation:
          'Türkiye\'nin ilk jeotermal ilçe ısınma sistemini kullanan, yeniliklere açık ama geleneklerine de çok bağlı çalışkan dağ ehalisi.',
    ),
    'Emet': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Emet Pidesi',
        'Sarımsaklı Yoğurtlu Mantı',
        'Tahinli Çörek',
      ],
      foodPlaces: ['Emet Termal Resort', 'Tarihi Emet Pidecileri'],
      interestingFacts: [
        'Dünya bor rezervlerinin devasa bir kısmını Emet tek başına barındırır.',
        'Yosunlu kaplıca suyu dünyada sadece iki yerde, biri de Emet\'te bulunur.',
        'Cevizdere kurtuluş destanının yazıldığı yerdir.',
      ],
      socialPopulation:
          'Bor madenlerinde çalışan madenciler ve termal turizmle harmanlanmış geleneksel yapıdaki yörükler.',
    ),
    'Domaniç': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.5,
      happinessIndex: 9.0,
      famousFoods: ['Közde Alabalık', 'Domaniç Tiridi', 'Gözleme'],
      foodPlaces: [
        'Ilıcaksu (Sarıkız) Tesisleri',
        'Orman İçi Alabalık Restoranları',
        'Hayme Ana Türbesi Yakını Gözlemeciler',
      ],
      interestingFacts: [
        '600 yıllık dev Osmanlı İmparatorluğu\'nun tohumlarının atıldığı, Kayı boyunun yaylak yeri olan tarihi başkentidir.',
        'Ertuğrul Gazi\'nin annesi Hayme Ana\'nın türbesi buradadır.',
        'Yüzde 65\'i devasa ormanlarla kaplıdır.',
      ],
      socialPopulation:
          'Osmanlı torunu olmanın haklı gururunu taşıyan, doğayla ve ormanla tamamen bütünleşmiş gerçek Yörük/Türkmen kültürü.',
    ),
  },
  // 34 - İstanbul ilçeleri
  34: {
    'Fatih (Tarihi Yarımada)': SocialInfo(
      safetyLevel: 'Ortalama / Gündüz Güvenli',
      humanFriendliness: 6.5,
      happinessIndex: 6.0,
      famousFoods: [
        'Sultanahmet Köftesi',
        'Süleymaniye Kuru Fasulyesi',
        'Vefa Bozası',
        'Eminönü Balık Ekmek',
      ],
      foodPlaces: [
        'Tarihi Sultanahmet Köftecisi',
        'Vefa Bozacısı',
        'Erzincanlı Ali Baba (Kuru Fasulye)',
        'Hamdi Restoran (Eminönü)',
        'Hafız Mustafa 1864',
      ],
      interestingFacts: [
        'İstanbul\'un 7 tepeli asıl "Tarihi Yarımada"sı burasıdır. (Sur içi).',
        'Ayasofya, Topkapı Sarayı, Yerebatan Sarnıcı ve Kapalıçarşı gibi tüm ikonik yapılar bu ilçededir.',
        'Dünyadaki en mistik atmosfere sahip (Balat, Fener Rum Lisesi) sokakları barındırır.',
      ],
      socialPopulation:
          'Tarihin tam kalbinde, yoğun turist akınıyla esnaf kültürünün ve çok eski İstanbul yerlilerinin muhafazakar bir yapıda harmanlandığı ilçe.',
    ),
    'Beyoğlu': SocialInfo(
      safetyLevel: 'Dikkatli Olunmalı',
      humanFriendliness: 6.0,
      happinessIndex: 6.0,
      famousFoods: [
        'Islak Hamburger',
        'Beyoğlu Çikolatası',
        'İnci Profiterol',
        'Karaköy Güllüoğlu Baklavası',
        'Balık Ekmek (Karaköy)',
      ],
      foodPlaces: [
        'Kızılkayalar',
        'Tarihi Karaköy Fırını',
        'Karaköy Güllüoğlu',
        'Çiçek Pasajı Lokantaları',
        'Hacı Abdullah Lokantası',
      ],
      interestingFacts: [
        'İstiklal Caddesi, tarihi kırmızı tramvayı ve pasajlarıyla İstanbul\'un vitrinidir.',
        'Galata Kulesi bu ilçede yer alır ve Cenevizlilerden izler taşır.',
        'Geçmişte Pera adıyla anılan, elçiliklerin ve levantenlerin yaşadığı Avrupa kültürünün kalbiydi.',
      ],
      socialPopulation:
          'Sanatçıların, aydınların, turistlerin ve eğlence sektörünün 24 saat uyumayan tam bir karmaşa ve cazibe merkezi.',
    ),
    'Beşiktaş': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Ortaköy Kumpiri',
        'Waffle',
        'Kuru Fasulye (Barış Manço\'nun mekanı)',
        'Midye Dolma',
      ],
      foodPlaces: [
        'Ortaköy Kumpirciler Çarşısı',
        'Karadeniz Pidecisi (Döneri dev)',
        'Tarihi Ali Baba Kuru Fasulyecisi',
        'Vogue Restaurant',
      ],
      interestingFacts: [
        'Osmanlı\'nın son dönemdeki devasa saraylarına (Dolmabahçe, Yıldız, Çırağan) ev sahipliği yapar.',
        'İlçe, Beşiktaş Jimnastik Kulübü (BJK) ve Çarşı grubu ile kenetlenmiş eşsiz bir semt kültürüne sahiptir.',
        'Boğaziçi Köprüsü\'nün (15 Temmuz Şehitler) Avrupa yakasındaki ayağı Ortaköy\'dedir.',
      ],
      socialPopulation:
          'Eğitim düzeyi ve geliri yüksek, sürekli dışarıda vakit geçiren, spora ve sanata düşkün aşırı dinamik, genç ve Avrupa standartlarında bir nüfus.',
    ),
    'Kadıköy': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: [
        'Moda Dondurması',
        'Çiya Sofrası Yemekleri',
        'Gözleme',
        'Midye ve Bira',
      ],
      foodPlaces: [
        'Çiya Sofrası (Tarihi Çarşı)',
        'Moda Tarihi Ali Usta Dondurmacısı',
        'Barlar Sokağı Midyecileri',
        'Baylan Pastanesi',
      ],
      interestingFacts: [
        'İstanbul\'un Asya (Anadolu) yakasının kültür, sanat ve buluşma merkezidir.',
        'Boğa Heykeli, tüm Asya yakasının en meşhur toplanma ve randevulaşma noktasıdır.',
        'Moda sahili, özellikle Kadıköylülerin çimlerde oturup güneşin batışını izlediği ikonik bir yerdir.',
      ],
      socialPopulation:
          'Türkiye\'nin entelektüel ve sosyokültürel seviyesi en yüksek, sivil toplumun en güçlü olduğu, herkesin birbirine saygı duyduğu hippi ruhlu Asya metropolü.',
    ),
    'Üsküdar': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: [
        'Kanaat Lokantası Özbek Pilavı',
        'Kandilli Simidi',
        'Çengelköy Salatalığı',
        'Kuzguncuk Kurabiyesi',
      ],
      foodPlaces: [
        'Tarihi Kanaat Lokantası',
        'Çengelköy Tarihi Çınaraltı Çay Bahçesi',
        'Tarihi Kuzguncuk Fırını',
        'Kız Kulesi Restoranı',
      ],
      interestingFacts: [
        'Kız Kulesi ve devasa yeni Çamlıca Camii bu ilçenin sınırları içerisindedir.',
        'Boğaziçi turları, Salacak sahilinden Kız Kulesi\'ne karşı çay içmek ve martılara simit atmak buranın klasik ritüelidir.',
        'Kuzguncuk semti, cami, kilise ve sinagogun yan yana barış içinde yaşadığı nadir yerlerdendir.',
      ],
      socialPopulation:
          'Daha muhafazakar bir yapıyla derin tarihi ve manevi değerleri benimsemiş, Boğaziçi\'nin yalı kültürünü yansıtan sakin ve huzurlu Anadolulu eski İstanbullular.',
    ),
    'Sarıyer': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Sarıyer Böreği',
        'Rumeli Kavağı İnciri',
        'Boğaz Balığı',
        'Midye Tava',
      ],
      foodPlaces: [
        'Tarihi Sarıyer Börekçisi',
        'Rumeli Hisarı İskele Restoran',
        'Yeniköy Kahvesi',
        'Garipçe Köyü Kahvaltı Mekanları',
      ],
      interestingFacts: [
        'İstanbul Boğazı\'nın Karadeniz\'e açıldığı devasa yeşil yakasıdır.',
        'Emirgan Korusu (Lale Festivali), Belgrad Ormanı ve Atatürk Arboretumu gibi İstanbul\'un dev akciğerleri buradadır.',
        'Rumeli Hisarı ve Aşiyan gibi tarihi efsaneleri barındırır.',
      ],
      socialPopulation:
          'İstanbul\'un en varlıklı kesiminin trilyonluk yalı ve köşklerde yaşadığı, ayrıca boğaz/orman sınırında doğayla iç içe huzur arayan elit bir demografi.',
    ),
    'Şişli': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.0,
      happinessIndex: 7.5,
      famousFoods: [
        'Nişantaşı Lüks Dünya Mutfağı',
        'Tatavla Mezesi (Kurtuluş)',
      ],
      foodPlaces: [
        'Nusr-Et (Nişantaşı)',
        'Spago Istanbul',
        'Bomontiada Mekanları',
        'Kurtuluş Mezeleri',
      ],
      interestingFacts: [
        'Abdi İpekçi Caddesi (Nişantaşı), dünyanın en pahalı markalarının ve lüks restoranların dizildiği merkezdir.',
        'Bomonti semti, İstanbul\'un en önemli gastro-eğlence ve kültür/konser kümelenmelerinden biridir.',
        'Türkiye\'nin ilk devasa gökdelenleri (Cevahir, Trump vb.) Şişli-Levent hattında yükselmiştir.',
      ],
      socialPopulation:
          'Üst düzey beyaz yakalıların, iş adamlarının, expat\'ların ve burjuva kesimin ikamet ettiği; alışveriş ve ticaretin mega kalbi.',
    ),
    'Eyüpsultan': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: [
        'Pierre Loti Türk Kahvesi',
        'Eyüp Oyuncakçısı Lokumları',
        'Kemerburgaz Turşusu',
      ],
      foodPlaces: [
        'Tarihi Pierre Loti Kahvesi',
        'Eyüp Sultan Külliyesi Etrafı Esnaf Lokantaları',
      ],
      interestingFacts: [
        'İslam dünyasında Mekke, Medine ve Kudüs\'ten sonra 4. önemli ziyaret merkezi olarak kabul edilir.',
        'Fransız yazar Pierre Loti\'nin adını taşıyan, Haliç\'e tepeden bakan efsanevi teleferikli tepe buradadır.',
        'Haliç kıyısındaki tarihi yapısını korurken okyanus kıyılarına kadar (Göktürk/Kemerburgaz) uzanan dev sınırları vardır.',
      ],
      socialPopulation:
          'Tarihi merkezinde yüksek dini/manevi değerlere ve türbe kültürüne sahip yoğun bir muhafazakar kitle yaşarken, dış kesimlerinde (Göktürk) üst düzey zengin siteler mevcuttur.',
    ),
    'Beykoz': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: [
        'Kanlıca Yoğurdu (Pudra Şekerli)',
        'Beykoz Kebabı',
        'Kalkan Balığı',
        'Ceviz',
      ],
      foodPlaces: [
        'İsmailağa Kahvesi (Kanlıca Yoğurdu)',
        'Anadolu Kavağı Balıkçıları',
        'Kıyı Emniyeti Tesisleri',
        'Polonezköy Tabiat Parkı Kahvaltı Mekanları',
      ],
      interestingFacts: [
        'Yüzde 80\'i devasa ormanlarla kaplıdır ve İstanbul Asya yakasının akciğeridir.',
        'Tarihi Kanlıca Yoğurdu, üzerine pudra şekeri dökülerek deniz kenarında eski yalılar önünde yenir.',
        'Anadolu Hisarı ve Karadeniz\'e açılan Yoros Kalesi bu yakadadır. Polonezköy gibi 1800\'lerde kurulan köyler barındırır.',
      ],
      socialPopulation:
          'İstanbul\'un kaosundan tamamen sıyrılmış, yalılarda ve orman içi villalarda yaşayan ultra elit kesim ile kendi sebzesini yetiştiren eski yerel köylü halkın ilginç karması.',
    ),
    'Adalar': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: [
        'Büyükada Dondurması',
        'Ada Lokması',
        'Taze Prens Adaları Balığı',
        'Milföy Pasta',
      ],
      foodPlaces: [
        'Prinkipo Restoran',
        'Eskibağ Teras',
        'Tarihi Taş Fırın',
        'Büyükada Sahil Balıkçıları',
      ],
      interestingFacts: [
        'Marmara Denizi\'nde yer alan, motorlu taşıtların (Prens Adaları vb.) tamamen yasak olduğu, ulaşımın elektrikli araçlar/bisiklet ile sağlandığı huzur üssü.',
        'Büyükada, Heybeliada, Burgazada ve Kınalıada olarak en meşhurlarıdır. Heybeliada Ruhban Okulu devasa ormanlar içindedir.',
        'Tarihi devasa ahşap Levanten ve Rum köşkleri buradadır.',
      ],
      socialPopulation:
          'Geçmişten günümüze Rum, Ermeni ve Yahudi nüfusunun yoğun olarak yazlık kullandığı, kışın sadece yerlilerin kaldığı; inanılmaz kibar, sessizliği seven ve martı sesine aşık elit toplum.',
    ),
  },
  // 35 - İzmir ilçeleri
  35: {
    'Konak': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.5,
      famousFoods: ['Boyoz', 'Gevrek', 'Şambali', 'Hisarönü Söğüş'],
      foodPlaces: [
        'Kemeraltı Çarşısı Esnaf Lokantaları',
        'Dostlar Fırını',
        'Söğüşçü Niğdeli Muammer Usta',
        'Reyhan Pastanesi',
      ],
      interestingFacts: [
        'İzmir\'in kalbi, merkezi ve yönetim binası buradadır.',
        'Saat Kulesi, Konak Yalı Camii ve Tarihi Asansör bu ilçededir.',
        '400 yıllık devasa Kemeraltı Çarşısı içinden çıkılamaz bir labirent gibidir.',
      ],
      socialPopulation:
          'İzmir\'in en yoğun ticaret ve ulaşım merkezi. Her şehirden insanın buluştuğu yüksek tempolu kültür.',
    ),
    'Bornova': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: ['Bornova Misketi (Şarap)', 'Kumru', 'Kokoreç'],
      foodPlaces: [
        'Küçükpark Kafeleri',
        'Ege Üniversitesi Kampüs İçi',
        'Tarihi Bornova Dönercisi',
      ],
      interestingFacts: [
        'Levanten köşkleriyle (Homeros Vadisi) ünlüdür.',
        'Ege Üniversitesi Türkiye\'nin en büyük kampüslerinden biridir.',
        'Türkiye\'de ilk futbol maçının oynandığı yerdir.',
      ],
      socialPopulation:
          'Levanten kültürü kalıntıları, genç ve dinamik öğrenci nüfusu ile iç içe huzurlu bir ilçe.',
    ),
    'Çeşme': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 8.5,
      famousFoods: [
        'Sakızlı Dondurma',
        'Çeşme Kumrusu',
        'Deniz Ürünleri',
        'Alaçatı Kurabiyesi',
      ],
      foodPlaces: [
        'Kumrucu Şevki',
        'Alaçatı İmren Pastanesi',
        'Ferdi Baba Restaurant',
        'Dalyan Balıkçıları',
      ],
      interestingFacts: [
        'Dünyanın en iyi Rüzgar Sörfü merkezlerinden biridir (Alaçatı).',
        'Termal suların doğrudan denize karıştığı Ilıca plajı çok meşhurdur.',
        'Ünlü Çeşme Kalesine ev sahipliği yapar.',
      ],
      socialPopulation:
          'Yazlıkçılar ve expat\'ların bir araya geldiği, tatil ve lüks yaşantının zirvesi.',
    ),
    'Karşıyaka': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: ['Karşıyaka Kumrusu', 'Bomba', 'Midye'],
      foodPlaces: [
        'Bostanlı Yasemin Kafe',
        'Karşıyaka Çarşısı',
        'Serkan Hamza Midye',
      ],
      interestingFacts: [
        'Kendini İzmir\'den bile ayrı ve özel tutan 35.5 (Otuz Beş Buçuk) kültürüne sahiptir.',
        'Karşıyaka Spor Kulübü ilçenin her şeyidir.',
        'Bostanlı Seyir Terası gün batımı için efsanedir.',
      ],
      socialPopulation:
          'Son derece elit, eğitimli, spora ve Atatürk ilkelerine mutlak bağlı çok nezih bir sosyal yapı.',
    ),
    'Urla': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 9.0,
      famousFoods: ['Katmer', 'Enginar', 'Urla Şarabı', 'Barbun'],
      foodPlaces: [
        'Yengeç Restaurant',
        'Urla İskele Balıkçıları',
        'Beğendik Abi (Esnaf Lokantası)',
        'Fırın Vourla',
      ],
      interestingFacts: [
        'Ege gastronomisinin Türkiye\'deki tartışmasız başkentidir.',
        'Urla Bağ Yolu dünyaca ünlüdür.',
        'Uluslararası Enginar Festivali yapılır.',
      ],
      socialPopulation:
          'Sanatçıların, gurmelerin ve İzmirli entelektüellerin emeklilikte yerleştiği doğa ve lezzet tutkunu nezih halk.',
    ),
    'Selçuk': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: ['Çöp Şiş', 'Şeftali', 'Şirince Şarabı'],
      foodPlaces: [
        'Selçuk Çöp Şişçileri',
        'Şirince Şarap Evleri',
        'Tarihi Ayasuluk Restoran',
      ],
      interestingFacts: [
        'Efes Antik Kenti ve Meryem Ana Evi ile Hristiyanlar için hac merkezidir.',
        'Dünyanın 7 Harikası\'ndan Artemis Tapınağı buradadır.',
        'Tarihi Şirince Köyü matematik köyü ile dünyaca ünlüdür.',
      ],
      socialPopulation:
          'Tarih, turizm ve tarım ile beslenen, vizyonu geniş ve misafirperver halk.',
    ),
    'Foça': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.5,
      famousFoods: [
        'Ege Balıkları (Çipura/Levrek)',
        'Zeytinyağlılar',
        'Yoğurtlu Taş Barbun',
      ],
      foodPlaces: [
        'Eski Foça Sahil Balıkçıları',
        'Fokai Restoran',
        'Kavala Kafe (Dibek Kahvesi)',
      ],
      interestingFacts: [
        'Nesli tükenmekte olan Akdeniz Foklarının (Monachus monachus) yaşam alanıdır.',
        'Taş evleri ve dar sokaklarıyla tarihi dokusunu Eski Foça\'da mükemmel korumuştur.',
      ],
      socialPopulation:
          'Masmavi denizle bütünleşmiş, Ege samimiyetini sonuna kadar hissettiren sahil kasabası insanları.',
    ),
    'Seferihisar': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.5,
      famousFoods: ['Mandalina', 'Armola Peyniri', 'Girit Ezmesi'],
      foodPlaces: [
        'Sığacık Kaleiçi Üretici Pazarı',
        'Teos Marina Mekanları',
        'Milos Balık',
      ],
      interestingFacts: [
        'Türkiye\'nin ilk sakin şehri (Cittaslow) unvanına sahiptir.',
        'Teos Antik Kenti (Sanatçılar Birliği) tarihin ilk oyuncular sendikasına ev sahipliği yapmıştır.',
        'Sığacık kalesi eşsizdir.',
      ],
      socialPopulation:
          'Karbon ayak izinin düşük olduğu, yerel üreticinin el üstünde tutulduğu inanılmaz yavaş ve huzurlu bir yaşam.',
    ),
    'Bergama': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: ['Bergama Köftesi', 'Bergama Tulumu', 'Patlıcan Çığırtma'],
      foodPlaces: [
        'Tarihi Bergama Köftecileri',
        'Altın Kepçe Lokantası',
        'Akropol Tesisleri',
      ],
      interestingFacts: [
        'UNESCO Dünya Mirası olan Pergamon Antik Kenti buradadır.',
        'Parşömen kağıdı (Pergament) bu topraklarda icat edilmiştir.',
        'Tıbbın atası sayılan Asklepion şifa tapınağı buradadır.',
      ],
      socialPopulation:
          'Geçmişiyle gurur duyan, geleneksel ile modern kültürün harmanlandığı samimi ilçe ehalisi.',
    ),
    'Buca': SocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.0,
      happinessIndex: 6.5,
      famousFoods: ['Gevrek', 'Kokoreç', 'Buca Söğüşü'],
      foodPlaces: [
        'Buca Gölet Etmangalları',
        'Dokuz Eylül Üniversitesi Çevresi Kafeler',
      ],
      interestingFacts: [
        'Dokuz Eylül Üniversitesi\'nin ana yerleşkesini barındırır.',
        'İzmir\'in en kalabalık ilçesidir.',
        'Eski Levanten evleri (Buca Köşkleri) ünlüdür.',
      ],
      socialPopulation:
          'Çok yoğun öğrenci nüfusu ile memur ve sanayi işçilerinin oluşturduğu oldukça karmaşık demografi.',
    ),
    'Dikili': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: ['Deniz Mantısı', 'Bademli Dondurması', 'Koruk Suyu'],
      foodPlaces: [
        'Dikili Sahil Balıkçıları',
        'Bademli Köyü Kahvesi',
        'Güneş Dondurmacısı',
      ],
      interestingFacts: [
        'Bademli, Zindan ve Kalem Adası koylarıyla Ege\'nin oksijen depolarından biridir.',
        'Suyu buz gibidir, deniz rengi adeta turkuazdır.',
        'Doğanbey Termal sularıyla meşhurdur.',
      ],
      socialPopulation:
          'Yazlıkçıların huzur ve denizi aradığı, sakin sahil kasabası insanlarından oluşur.',
    ),
    'Menemen': SocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.5,
      happinessIndex: 7.0,
      famousFoods: ['Menemen', 'Testi Kebabı', 'Menemen Çileği'],
      foodPlaces: [
        'Tarihi Taşhan',
        'Köy Kahvaltıcıları',
        'Menemen Testi Kebapçıları',
      ],
      interestingFacts: [
        'Toprak çömlek işçiliğinde (Testi vb.) Türkiye\'nin bir numaralı merkezidir.',
        'Meşhur Menemen yemeğinin ismini buradan aldığı söylenir.',
        'Karagöl tabiat parkını barındırır.',
      ],
      socialPopulation:
          'Çok köklü bir tarım ovası olması sebebiyle çiftçi/üretici ve çömlek sanatçısı ustalarının uyumlu beraberliği.',
    ),
    'Ödemiş': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: [
        'Ödemiş Köftesi',
        'Töngül Pidesi',
        'Koruk Ekşisi',
        'Kestane',
      ],
      foodPlaces: [
        'Tarihi Ödemiş Köftecisi Hurşit',
        'Töngül Pide Fırını',
        'Birgi Konak Kafeleri',
      ],
      interestingFacts: [
        'Tarihi Birgi köyü ve Aydınoğulları başkenti buradadır.',
        'Türkiye\'de sivil mimarinin (ahşap Osmanlı evi) en güzel örnekleri buradadır.',
        'Gölcük Gölü ve Kayak Tesisleri buradadır.',
      ],
      socialPopulation:
          'Bölgesinin en zengin (tarım sebebiyle) ve misafirperver yörüklerinin yaşadığı dağ ve ova kenti.',
    ),
    'Torbalı': SocialInfo(
      safetyLevel: 'Ortalama',
      humanFriendliness: 7.0,
      happinessIndex: 7.0,
      famousFoods: ['Kuru Domates (İhracat Şampiyonu)', 'Torbalı Gevreği'],
      foodPlaces: ['Metropolis Kazı Evi Yakınları', 'Tepeköy Meydan Tesisleri'],
      interestingFacts: [
        'Ege\'nin kuru domates üretim üssüdür.',
        'Metropolis Antik Kenti ana tanrıça şehrine ev sahipliği yapar.',
        'İzmir sanayisinin kalbidir.',
      ],
      socialPopulation:
          'Büyük çaplı fabrikalar sebebiyle yoğun dış göç almış dinamik bir sanayi toplumu.',
    ),
  },

  // 45 - Manisa ilçeleri
  45: {
    'Şehzadeler': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 7.5,
      famousFoods: ['Manisa Kebabı', 'Mesir Macunu', 'Cilveli Kahve'],
      foodPlaces: [
        'Gülcemal Kebapçısı',
        'Tarihi Yeni Han Kafeleri',
        'Sultan Camii Çevresi Et Lokantaları',
      ],
      interestingFacts: [
        'Manisa\'nın asıl tarihi kalbi ve Osmanlı şehzadelerinin sancakbeyliği yaptığı sancak merkezidir.',
        'Spil Dağı eteklerinde kuruludur; Ağlayan Kaya (Niobe) ve Mimar Sinan\'ın Muradiye Camii buradadır.',
        'Her bahar Mesir Festivali burada (Sultan Camii alanında) başlar.',
      ],
      socialPopulation:
          'Köklü Manisa yerlilerinin yaşadığı, tarihe, esnaflığa ve geleneksel değerlere sımsıkı bağlı, Spil dağının dinginliğine sahip merkez toplumu.',
    ),
    'Yunusemre': SocialInfo(
      safetyLevel: 'Ortalama / Gündüz Güvenli',
      humanFriendliness: 7.0,
      happinessIndex: 7.0,
      famousFoods: [
        'Fabrika Çevresi Pide/Döner',
        'Süreyya Piknik Alanı Kebapları',
      ],
      foodPlaces: [
        'Süreyya Tabiat Parkı Tesisleri',
        'Manisa OSB Et Lokantaları',
      ],
      interestingFacts: [
        'Avrupa\'nın en büyük sanayi merkezlerinden biri olan (Vestel City) Manisa Organize Sanayi Bölgesi\'ni barındırır.',
        'Manisa Celal Bayar Üniversitesi ana kampüsü buradadır.',
        'Gediz ovasına bakan devasa ve çok hızlı gelişen yeni modern ve sanayi ağırlıklı yerleşim yeridir.',
      ],
      socialPopulation:
          'Devasa sanayi fabrikalarında çalışan dev işçi sınıfı ile üniversite öğrencilerinin oluşturduğu oldukça yoğun, hareketli ve göç alan bir metropol dinamiği.',
    ),
    'Akhisar': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: ['Akhisar Köftesi', 'Zeytin ve Zeytinyağı', 'Katmer'],
      foodPlaces: [
        'Köfteci Ramiz (Tarihi Merkez Şube)',
        'Akhisar Şehir Merkezi Köftecileri',
        'Can Köfte',
      ],
      interestingFacts: [
        'Uzun yıllar Süper Lig\'de mücadele etmiş ve Türkiye Kupası kazanmış gururlu bir futbol kültürüne (Akhisarspor) sahiptir.',
        'Türkiye\'nin zeytin başkentidir; milyonlarca zeytin ağacına ve en kaliteli zeytinyağı tesislerine ev sahipliği yapar.',
        'İncil\'de adı geçen 7 (Yedi) Kilisenden biri olan Thyatira buradadır.',
      ],
      socialPopulation:
          'Tarım ve sanayi elitlerinin bulunduğu, spora (özellikle futbola) aşık, gururlu, ekonomik özgürlüğü son derece yüksek olan modern bir Ege halkı.',
    ),
    'Salihli': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.0,
      famousFoods: [
        'Salihli Odun Köftesi',
        'Sultaniye Çekirdeksiz Üzümü',
        'Kurşunlu Kaplıca Suyu',
      ],
      foodPlaces: [
        'Tarihi Odun Köftecisi Şentürk',
        'Bozdağ Etekleri Gözleme/Kahvaltı Merkezleri',
        'Kurşunlu Vadisi Restoranları',
      ],
      interestingFacts: [
        'Tarihte parayı bulan Lidya Krallığı\'nın (Sardes) başkentidir ve Karun\'un hazinelerine ev sahipliği yapmıştır.',
        'Bintepeler olarak bilinen devasa Lidya Kraliyet Tümülüsleri bu ilçededir.',
        'Bozdağ eteklerinde şifa dağıtan Kurşunlu Kaplıcaları dev bir kanyondadır.',
      ],
      socialPopulation:
          'Geçmişiyle büyük bir kültürel bağ kurmuş, inanılmaz derecede kibar, bağcılık ve tarımla yüksek refaha ulaşmış neşeli şeftali/üzüm diyarı insanları.',
    ),
    'Kula': SocialInfo(
      safetyLevel: 'Çok Güvenli',
      humanFriendliness: 9.0,
      happinessIndex: 8.5,
      famousFoods: [
        'Kula Leblebisi',
        'Kula Güveci',
        'Kula Maden Suyu',
        'Şekerli Pide',
      ],
      foodPlaces: [
        'Tarihi Kula Çarşısı Güveççileri',
        'Yanık Ülke (Katakekaumene) Şarapevleri',
      ],
      interestingFacts: [
        'Antik çağda "Yanık Ülke" anlamına gelen Katakekaumene olarak bilinir; Türkiye\'nin en genç volkanlarına ve peri bacalarına (Kuladokya) sahiptir.',
        'Bozulmamış yüzlerce yıllık ahşap Osmanlı Kula evleri ve dar sokaklarıyla tam bir açık hava müzesidir.',
        'Türkiye\'nin ilk ve tek UNESCO tescilli Küresel Jeopark ağı buradadır.',
      ],
      socialPopulation:
          'Tarihi konaklarında yaşatılan ahilik kültürünü, halıcılığı ve meşhur Kula leblebiciliğini sürdüren, inanılmaz samimi ve köklü iç Ege yörükleri.',
    ),
    'Turgutlu': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 7.5,
      famousFoods: ['Toprak Güveç', 'Gediz Ovası Üzümü', 'Turgutlu Köftesi'],
      foodPlaces: [
        'Seyirtepe Sosyal Tesisleri',
        'Turgutlu Şehir İçi Köftecileri',
      ],
      interestingFacts: [
        'Halk arasında çok uzun yıllardır her zaman "Kasaba" lakabıyla anılır.',
        'Türkiye\'nin kiremit ve tuğla tuğla sanayisinin mutlak lideridir, her yer toprak fabrikalarıyla doludur.',
        'Kurtuluş Savaşı sırasında Yunan ordusu tarafından neredeyse tamamına yakını yakılıp kül edilmiştir.',
      ],
      socialPopulation:
          'Çok çalışkan sanayi işçileri ve uçsuz bucaksız Gediz Ovası\'na hükmeden üretken çiftçilerin bir arada omuz omuza yaşadığı dinamik bir ilçe.',
    ),
    'Alaşehir': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: ['Alaşehir Kapaması', 'Sultaniye Üzümü', 'Üzüm Şırası'],
      foodPlaces: [
        'Tarihi Alaşehir Kapamacısı',
        'Üzüm Bağları Rotası Restoranları',
      ],
      interestingFacts: [
        'Antik dünyadaki adı Philadelphia\'dır ve ABD\'deki meşhur Philadelphia kenti ismini ve felsefesini buradan (Kardeş Sevgisi) almıştır.',
        'Tarihi Kurşunlu Han ve Aziz Yuhanna (St. Jean) Kilisesi\'nin devasa ayakları günümüze ulaşmıştır.',
        'Türkiye\'nin ve dünyanın kuru/yaş üzüm ihracatının en büyük kalplerinden biridir.',
      ],
      socialPopulation:
          'Tüm hayatını üzüm bağlarına ve tarıma entegre etmiş, çalışkan, varlıklı ve misafirperver Ege çiftçileri.',
    ),
    'Soma': SocialInfo(
      safetyLevel: 'Dikkatli Olunmalı (Maden Sahaları) / Şehir İçi Güvenli',
      humanFriendliness: 7.5,
      happinessIndex: 6.0,
      famousFoods: ['Soma Kavurması', 'Pide'],
      foodPlaces: ['Madenci Esnaf Lokantaları'],
      interestingFacts: [
        'Türkiye\'nin en büyük linyit madeni havzalarına ve devasa termik santrallere ev sahipliği yapar.',
        'Türkiye tarihindeki en büyük maden faciası 2014 yılında burada yaşanmıştır.',
        'Darkale (Tarhala) isimli çok eski ve mimari açıdan bozulmamış tarihi bir dağ köyü vardır.',
      ],
      socialPopulation:
          'Büyük oranda Karadeniz ve iç kesimlerden göçerek yer altına (madenlere) inen cefakar kahraman işçi sınıfı ve ailelerinden oluşan, acılara kenetlenmiş vefalı bir yerleşim.',
    ),
  },

  // 7 - Antalya ilçeleri
  7: {
    'Alanya': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.0,
      happinessIndex: 8.0,
      famousFoods: ['Alanya muzu', 'Piyaz'],
      foodPlaces: ['Alanya Kalesi restoranları'],
      interestingFacts: [
        'Kleopatra Plajı efsanevi',
        'Alanya Kalesi 250m yükseklikte',
      ],
      socialPopulation: 'Turist dostu, çok uluslu, rahat yaşam.',
    ),
    'Kaş': SocialInfo(
      safetyLevel: 'Güvenli',
      humanFriendliness: 8.5,
      happinessIndex: 8.5,
      famousFoods: ['Balık', 'Ege otları'],
      foodPlaces: ['Kaş marina balıkçıları'],
      interestingFacts: ['Dalış cenneti', 'Kekova batık şehir'],
      socialPopulation: 'Bohemce, sakin, doğa severler.',
    ),
  },
};
