import 'districts_data.dart';

class Province {
  final int plateCode;
  final String name;
  final String region;
  final double lat;
  final double lng;
  final int population;
  final List<Place> places;
  final List<String> districts;

  const Province({
    required this.plateCode,
    required this.name,
    required this.region,
    required this.lat,
    required this.lng,
    required this.population,
    required this.places,
    this.districts = const [],
  });

  Province copyWithDistricts(List<String> newDistricts) {
    return Province(
      plateCode: plateCode,
      name: name,
      region: region,
      lat: lat,
      lng: lng,
      population: population,
      places: places,
      districts: newDistricts,
    );
  }
}

class Place {
  final String name;
  final String description;
  final String category;
  final double rating;
  final List<Review> reviews;
  final double lat;
  final double lng;

  const Place({
    required this.name,
    required this.description,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.lat,
    required this.lng,
  });
}

class Review {
  final String user;
  final String comment;
  final double rating;
  final String date;
  const Review({
    required this.user,
    required this.comment,
    required this.rating,
    required this.date,
  });
}

final List<Province> turkeyProvinces = _rawProvinces.map((p) {
  final districts = turkeyDistricts[p.plateCode] ?? [];
  return p.copyWithDistricts(districts);
}).toList();

const List<Province> _rawProvinces = [
  Province(
    plateCode: 1,
    name: 'Adana',
    region: 'Akdeniz',
    lat: 37.0,
    lng: 35.32,
    population: 2274106,
    places: [
      Place(
        name: 'Taşköprü',
        description: 'Roma döneminden kalma tarihi köprü',
        category: 'Tarihi',
        rating: 4.3,
        lat: 37.0,
        lng: 35.32,
        reviews: [
          Review(
            user: 'Ahmet',
            comment: 'Muhteşem bir tarihi yapı!',
            rating: 5,
            date: '2024-11-01',
          ),
          Review(
            user: 'Elif',
            comment: 'Güzel manzara',
            rating: 4,
            date: '2024-10-15',
          ),
        ],
      ),
      Place(
        name: 'Seyhan Baraj Gölü',
        description: 'Şehrin en güzel piknik alanı',
        category: 'Doğa',
        rating: 4.1,
        lat: 37.05,
        lng: 35.34,
        reviews: [
          Review(
            user: 'Can',
            comment: 'Harika piknik alanı',
            rating: 4,
            date: '2024-09-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 2,
    name: 'Adıyaman',
    region: 'Güneydoğu Anadolu',
    lat: 37.76,
    lng: 38.27,
    population: 635169,
    places: [
      Place(
        name: 'Nemrut Dağı',
        description: 'UNESCO Dünya Mirası - Devasa heykeller',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.98,
        lng: 38.74,
        reviews: [
          Review(
            user: 'Zeynep',
            comment: 'Gün doğumunda muhteşem!',
            rating: 5,
            date: '2024-10-01',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 3,
    name: 'Afyonkarahisar',
    region: 'Ege',
    lat: 38.73,
    lng: 30.54,
    population: 747555,
    places: [
      Place(
        name: 'Afyon Kalesi',
        description: 'Şehre hakim kayalık kale',
        category: 'Tarihi',
        rating: 4.4,
        lat: 38.73,
        lng: 30.54,
        reviews: [
          Review(
            user: 'Berk',
            comment: 'Manzarası harika',
            rating: 4.5,
            date: '2024-08-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 4,
    name: 'Ağrı',
    region: 'Doğu Anadolu',
    lat: 39.72,
    lng: 43.05,
    population: 510626,
    places: [
      Place(
        name: 'Ağrı Dağı',
        description: 'Türkiye\'nin en yüksek dağı - 5137m',
        category: 'Doğa',
        rating: 4.9,
        lat: 39.70,
        lng: 44.30,
        reviews: [
          Review(
            user: 'Dağcı Ali',
            comment: 'Zirve tırmanışı unutulmaz!',
            rating: 5,
            date: '2024-07-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 5,
    name: 'Amasya',
    region: 'Karadeniz',
    lat: 40.65,
    lng: 35.83,
    population: 339000,
    places: [
      Place(
        name: 'Kral Kaya Mezarları',
        description: 'Pontus krallarına ait kaya mezarları',
        category: 'Tarihi',
        rating: 4.6,
        lat: 40.65,
        lng: 35.83,
        reviews: [
          Review(
            user: 'Tarihçi',
            comment: 'Müthiş tarih',
            rating: 5,
            date: '2024-06-10',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 6,
    name: 'Ankara',
    region: 'İç Anadolu',
    lat: 39.93,
    lng: 32.86,
    population: 5782285,
    places: [
      Place(
        name: 'Anıtkabir',
        description:
            'Türkiye Cumhuriyeti\'nin kurucusu Gazi Mustafa Kemal Atatürk\'ün ebedi istirahatgahı, bağımsızlığın kalbi.',
        category: 'Tarihi',
        rating: 5.0,
        lat: 39.925,
        lng: 32.836,
        reviews: [
          Review(
            user: 'Vatandaş',
            comment:
                'Her Türk evladının mutlaka ziyaret etmesi gereken kutsal mekan.',
            rating: 5,
            date: '2024-11-10',
          ),
        ],
      ),
      Place(
        name: 'I. Türkiye Büyük Millet Meclisi (Kurtuluş Savaşı Müzesi)',
        description:
            'Cumhuriyetin ilan edildiği, Kurtuluş Savaşı\'nın yönetildiği tarihi meclis binası.',
        category: 'Müze',
        rating: 4.8,
        lat: 39.941,
        lng: 32.853,
        reviews: [],
      ),
      Place(
        name: 'II. Türkiye Büyük Millet Meclisi (Cumhuriyet Müzesi)',
        description:
            'Atatürk ilke ve inkılaplarının yasalaştığı, modern Türkiye\'nin temellerinin atıldığı ikinci meclis.',
        category: 'Müze',
        rating: 4.8,
        lat: 39.940,
        lng: 32.852,
        reviews: [],
      ),
      Place(
        name: 'Anadolu Medeniyetleri Müzesi',
        description:
            'Paleolitik çağdan Osmanlı\'ya kadar Anadolu\'nun tüm kadim tarihini barındıran, Avrupa\'da "Yılın Müzesi" seçilmiş efsanevi yapı.',
        category: 'Müze',
        rating: 4.9,
        lat: 39.938,
        lng: 32.861,
        reviews: [],
      ),
      Place(
        name: 'Ankara Kalesi',
        description:
            'Şehre tepeden bakan, Arnavut kaldırımlı sokakları ve tarihi Ankara evleri (konakları) ile yaşayan bir tarih müzesi.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 39.940,
        lng: 32.865,
        reviews: [],
      ),
      Place(
        name: 'Hamamönü (Tarihi Sokaklar)',
        description:
            'Restore edilmiş 19. yüzyıl ahşap konakları, sanat sokakları ve Mehmet Akif Ersoy\'un İstiklal Marşı\'nı yazdığı ev.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 39.932,
        lng: 32.866,
        reviews: [],
      ),
      Place(
        name: 'Atakule ve Botanik Parkı',
        description:
            'Ankara silüetinin en ikonik yapısı Atakule ve dibindeki yemyeşil, huzurlu Botanik Parkı manzara keyfi.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.886,
        lng: 32.856,
        reviews: [],
      ),
      Place(
        name: 'Tunalı Hilmi Caddesi ve Kuğulu Park',
        description:
            'Başkentin en popüler buluşma noktası; kuğuları, sokak sanatçıları ve bitmeyen enerjisiyle meşhur Kuğulu Park ortamı.',
        category: 'Gezi',
        rating: 4.8,
        lat: 39.902,
        lng: 32.861,
        reviews: [],
      ),
      Place(
        name: 'Seğmenler Parkı',
        description:
            'Özellikle yaz aylarında çimlerinde oturulan, amfi tiyatrosunda müzik yapılan Çankaya\'nın vaha niteliğindeki dev vadisi.',
        category: 'Doğa',
        rating: 4.8,
        lat: 39.896,
        lng: 32.859,
        reviews: [],
      ),
      Place(
        name: 'Atatürk Orman Çiftliği (AOÇ)',
        description:
            'Atatürk\'ün emriyle kurulan devasa tarım alanı; efsanevi AOÇ dondurması ve piknik alanlarıyla başkentin mirası.',
        category: 'Gezi',
        rating: 4.7,
        lat: 39.936,
        lng: 32.798,
        reviews: [],
      ),
      Place(
        name: 'Eymir Gölü',
        description:
            'ODTÜ ormanı içinde yer alan, Ankaralıların bisiklet sürüp kürek çektiği, araç girişine kısıtlı muhteşem doğa rezervi.',
        category: 'Doğa',
        rating: 4.8,
        lat: 39.824,
        lng: 32.825,
        reviews: [],
      ),
      Place(
        name: 'Mogan Gölü (Gölbaşı)',
        description:
            'Gölbaşı ilçesinde, sahil yürüyüş yolları, kafeleri ve gün batımı manzarasıyla Ankaralıların deniz hasretini giderdiği göl.',
        category: 'Doğa',
        rating: 4.6,
        lat: 39.758,
        lng: 32.793,
        reviews: [],
      ),
      Place(
        name: 'Göksu Parkı',
        description:
            'Eryaman\'da devasa göleti, su bisikletleri, Roller Coaster\'ı ve iskelelerdeki restoranlarıyla muazzam yaşam alanı.',
        category: 'Gezi',
        rating: 4.6,
        lat: 39.986,
        lng: 32.658,
        reviews: [],
      ),
      Place(
        name: 'Rahmi M. Koç Müzesi (Ankara)',
        description:
            'Çengelhan içerisine kurulu, sanayi, teknoloji ve iletişim tarihine dair harika objelerin sergilendiği müze.',
        category: 'Müze',
        rating: 4.7,
        lat: 39.937,
        lng: 32.863,
        reviews: [],
      ),
      Place(
        name: 'Gençlik Parkı',
        description:
            'Ulus\'un ortasında, devasa havuzları, ışık gösterileri ve lunaparkı (Dönme Dolap) ile Ankara\'nın en köklü parkı.',
        category: 'Gezi',
        rating: 4.4,
        lat: 39.938,
        lng: 32.848,
        reviews: [],
      ),
      Place(
        name: 'Estergon Türk Kültür Merkezi',
        description:
            'Keçiören\'de inşa edilen, Tuna nehri kıyısındaki aslına uygun mimarisiyle Ankara manzarasını seyrettiren kale.',
        category: 'Gezi',
        rating: 4.3,
        lat: 39.983,
        lng: 32.864,
        reviews: [],
      ),
      Place(
        name: 'Kocatepe Camii',
        description:
            'Kızılay sırtlarında yükselen, Cumhuriyet tarihinin en büyük ve en görkemli klasik Osmanlı mimarisine sahip camisi.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 39.916,
        lng: 32.860,
        reviews: [],
      ),
      Place(
        name: 'Dikmen Vadisi',
        description:
            'Şehrin ortasında şelaleleri, yemyeşil terasları ve cam seralarıyla huzurlu bir vadi projesi.',
        category: 'Doğa',
        rating: 4.6,
        lat: 39.884,
        lng: 32.846,
        reviews: [],
      ),
      Place(
        name: 'MTA Tabiat Tarihi Müzesi',
        description:
            'Türkiye\'nin tek, dünyanın sayılı tabiat tarihi müzelerinden; gerçek dinozor (Allosaurus) iskeletleri ve dev meteorlar.',
        category: 'Müze',
        rating: 4.8,
        lat: 39.904,
        lng: 32.802,
        reviews: [],
      ),
      Place(
        name: 'Harikalar Diyarı',
        description:
            'Sincan\'da bulunan Avrupa\'nın en büyük kent parklarından biri; dev masal kahramanları heykelleri (Güliver, Sünger Bob).',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.967,
        lng: 32.557,
        reviews: [],
      ),
      Place(
        name: 'Gordion Antik Kenti',
        description:
            'Polatlı yakınlarında, "Gordion Düğümü" ve Kral Midas\'ın efsanevi devasa tümülüs mezarına (Dünyanın 2. en büyüğü) ev sahipliği yapan antik başkent.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 39.650,
        lng: 31.996,
        reviews: [],
      ),
      Place(
        name: 'Altınköy Açık Hava Müzesi',
        description:
            'Altındağ\'da 100 yıl öncesinin Ankara köy hayatını birebir yaşatan, yel değirmenleri ve köy fırınları olan eko-yaşam alanı.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 39.964,
        lng: 32.969,
        reviews: [],
      ),
      Place(
        name: 'Beypazarı Tarihi Konakları ve Çarşısı',
        description:
            'Osmanlı sivil mimarisinin kusursuz örneği olan ahşap konaklar, kurumuş gümüş (telkari) işlemecileri ve meşhur Beypazarı Kurusu fırınları.',
        category: 'Gezi',
        rating: 4.8,
        lat: 40.165,
        lng: 31.921,
        reviews: [],
      ),
      Place(
        name: 'Nallıhan Kuş Cenneti ve Kız Tepesi',
        description:
            'Sokakları yarmış gibi duran sıra dışı renkli (kırmızı/sarı) volkanik tepeler ve binlerce su kuşunun uğrak yeri olan vaha.',
        category: 'Doğa',
        rating: 4.7,
        lat: 40.095,
        lng: 31.579,
        reviews: [],
      ),
      Place(
        name: 'Kızılcahamam (Soğuksu) Milli Parkı',
        description:
            'Çam ormanlarıyla kaplı kaplıcalar diyarı; Atatürk\'ün "Burası termal cenneti" dediği oksijen ve şifa kaynağı doğa harikası.',
        category: 'Doğa',
        rating: 4.6,
        lat: 40.457,
        lng: 32.617,
        reviews: [],
      ),
      Place(
        name: 'İlk Meclis Yanı (Cumhuriyet) Meydanı',
        description:
            'Atatürk Anıtı ve eski Ankara ruhunu taşıyan Ziraat Bankası, İş Bankası gibi devasa tarihi taş binalar kompleksi.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.941,
        lng: 32.854,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 7,
    name: 'Antalya',
    region: 'Akdeniz',
    lat: 36.88,
    lng: 30.70,
    population: 2688004,
    places: [
      Place(
        name: 'Kaleiçi',
        description: 'Tarihi şehir merkezi',
        category: 'Tarihi',
        rating: 4.7,
        lat: 36.88,
        lng: 30.70,
        reviews: [
          Review(
            user: 'Gezgin',
            comment: 'Harika sokaklar',
            rating: 5,
            date: '2024-08-20',
          ),
        ],
      ),
      Place(
        name: 'Düden Şelalesi',
        description: 'Denize dökülen muhteşem şelale',
        category: 'Doğa',
        rating: 4.6,
        lat: 36.85,
        lng: 30.78,
        reviews: [
          Review(
            user: 'Doğa7',
            comment: 'Muhteşem!',
            rating: 5,
            date: '2024-07-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 8,
    name: 'Artvin',
    region: 'Karadeniz',
    lat: 41.18,
    lng: 41.82,
    population: 170875,
    places: [
      Place(
        name: 'Borçka Karagöl',
        description: 'Dağlar arasında saklı göl',
        category: 'Doğa',
        rating: 4.7,
        lat: 41.35,
        lng: 41.70,
        reviews: [
          Review(
            user: 'Doğa',
            comment: 'Cennet gibi',
            rating: 5,
            date: '2024-06-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 9,
    name: 'Aydın',
    region: 'Ege',
    lat: 37.85,
    lng: 27.83,
    population: 1134031,
    places: [
      Place(
        name: 'Aphrodisias Antik Kenti',
        description:
            'Aşk ve güzellik tanrıçası Afrodit\'e adanmış çok iyi korunmuş antik kent ve stadyum. Heykeltraşlık okuluna sahipti.',
        category: 'Tarihi',
        rating: 5.0,
        lat: 37.70,
        lng: 28.72,
        reviews: [
          Review(
            user: 'RehberAli',
            comment: 'Türkiye\'deki en iyi antik kentlerden biri.',
            rating: 5,
            date: '2024-05-12',
          ),
        ],
      ),
      Place(
        name: 'Didim Apollon Tapınağı',
        description:
            'Antik dünyanın en büyük üçüncü tapınağı. Kehanet merkezi olarak ün yapmıştır ve Medusa başı figürüyle tanınır.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.38,
        lng: 27.25,
        reviews: [
          Review(
            user: 'Gezgin',
            comment: 'Muazzam büyüklükte sütunlar var.',
            rating: 5,
            date: '2024-07-22',
          ),
        ],
      ),
      Place(
        name: 'Dilek Yarımadası Milli Parkı',
        description:
            'Mavinin ve yeşilin iç içe geçtiği, domuzların sahilde gezdiği, eşsiz koylara sahip doğa harikası milli park.',
        category: 'Doğa',
        rating: 4.9,
        lat: 37.69,
        lng: 27.14,
        reviews: [
          Review(
            user: 'DoğaSever',
            comment: 'Kalamaki koyları bir harika!',
            rating: 5,
            date: '2024-08-10',
          ),
        ],
      ),
      Place(
        name: 'Milet Antik Kenti',
        description:
            'Filozofların şehri. Felsefenin ve bilimin doğduğu antik metropol, muazzam tiyatrosu ile ünlü.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 37.53,
        lng: 27.27,
        reviews: [
          Review(
            user: 'Tarihçi',
            comment: 'Felsefenin doğduğu yer!',
            rating: 5,
            date: '2024-09-01',
          ),
        ],
      ),
      Place(
        name: 'Güvercinada Kalesi',
        description:
            'Kuşadası\'na adını veren küçük ada üzerinde yer alan tarihi Bizans-Osmanlı kalesi.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.86,
        lng: 27.25,
        reviews: [
          Review(
            user: 'Turist',
            comment: 'Gün batımında burada olmak çok güzel.',
            rating: 4.5,
            date: '2024-06-15',
          ),
        ],
      ),
      Place(
        name: 'Priene Antik Kenti',
        description:
            'Büyük İskender\'in ziyaret ettiği, ızgara planla kurulmuş, Athena tapınağına sahip büyüleyici kent.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 37.65,
        lng: 27.29,
        reviews: [
          Review(
            user: 'Mimar',
            comment: 'Antik şehirciliğin en güzel örneklerinden.',
            rating: 5,
            date: '2024-05-20',
          ),
        ],
      ),
      Place(
        name: 'Zeus Mağarası',
        description:
            'Mitolojik hikayelere konu olan, Dilek Yarımadası girişindeki gizli ve buz gibi sulu efsanevi mağara.',
        category: 'Doğa',
        rating: 4.6,
        lat: 37.71,
        lng: 27.22,
        reviews: [
          Review(
            user: 'SuAşığı',
            comment: 'Suyu çok soğuk ama girince harika hissettiriyor.',
            rating: 4.5,
            date: '2024-08-30',
          ),
        ],
      ),
      Place(
        name: 'Kadınlar Denizi Plajı',
        description:
            'Kuşadası\'nın en popüler, ince kumlu ve sığ denize sahip Mavi Bayraklı plajı.',
        category: 'Deniz',
        rating: 4.5,
        lat: 37.84,
        lng: 27.25,
        reviews: [
          Review(
            user: 'YazTatili',
            comment: 'Oldukça kalabalık ama denizi temiz.',
            rating: 4,
            date: '2024-07-05',
          ),
        ],
      ),
      Place(
        name: 'Tralleis Antik Kenti',
        description:
            'Ünlü Üç Gözler kalıntısının bulunduğu, şifacı hekimlerin ve zeytinin kenti.',
        category: 'Tarihi',
        rating: 4.3,
        lat: 37.86,
        lng: 27.84,
        reviews: [
          Review(
            user: 'TarihDostu',
            comment: 'Aydın merkezde, Üç Gözler sembol yapı.',
            rating: 4.5,
            date: '2024-03-12',
          ),
        ],
      ),
      Place(
        name: 'Arapapıştı Kanyonu',
        description:
            'Şaşırtıcı turkuaz rengi suyu ve dik kayalıklarıyla Aydın\'ın gizli kalmış doğa mucizesi.',
        category: 'Doğa',
        rating: 4.8,
        lat: 37.64,
        lng: 28.52,
        reviews: [
          Review(
            user: 'Kampçı',
            comment: 'Tekne turu ile kanyonu gezmek nefes kesici.',
            rating: 5,
            date: '2024-06-25',
          ),
        ],
      ),
      Place(
        name: 'Nysa Antik Kenti',
        description:
            'Sultanhisar içerisindeki, zeytin ağaçları arasına saklanmış kütüphanesi ve tiyatrosu olan kent.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.90,
        lng: 28.14,
        reviews: [
          Review(
            user: 'Tarihçi',
            comment: 'Köprü ve tüneller mimari deha işi.',
            rating: 5,
            date: '2024-05-18',
          ),
        ],
      ),
      Place(
        name: 'Eski Doğanbey Köyü',
        description:
            'Rum mimarisinin eşsiz örneklerini barındıran, labirent sokaklarıyla büyüleyen restore edilmiş dağ köyü.',
        category: 'Gezi',
        rating: 4.7,
        lat: 37.61,
        lng: 27.19,
        reviews: [
          Review(
            user: 'Fotoğraf',
            comment: 'Taş evler ve bitki örtüsü şahane fotoğraf veriyor.',
            rating: 5,
            date: '2024-04-22',
          ),
        ],
      ),
      Place(
        name: 'Altınkum Plajı',
        description:
            'Didim\'in dünyaca ünlü altın rengi kumlarından ismini alan, upuzun sığ plaj.',
        category: 'Deniz',
        rating: 4.5,
        lat: 37.35,
        lng: 27.28,
        reviews: [
          Review(
            user: 'Mustafa',
            comment: 'Çocuklu aileler için çok uygun, sığ.',
            rating: 4.5,
            date: '2024-07-28',
          ),
        ],
      ),
      Place(
        name: 'Alabanda Antik Kenti',
        description:
            'Çine\'de kralların meclis binası ve tapınaklarının tüm heybetiyle durduğu tarihi kent.',
        category: 'Tarihi',
        rating: 4.2,
        lat: 37.59,
        lng: 27.98,
        reviews: [
          Review(
            user: 'Arkeolog',
            comment: 'Sessiz ve çok etkileyici.',
            rating: 4,
            date: '2024-04-05',
          ),
        ],
      ),
      Place(
        name: 'Alinda Antik Kenti',
        description:
            'Karpuzlu ilçesinde Büyük İskender\'in kraliçe Ada ile görüştüğü devasa agora yapısıyla bilinen kent.',
        category: 'Tarihi',
        rating: 4.4,
        lat: 37.56,
        lng: 27.81,
        reviews: [],
      ),
      Place(
        name: 'Magnesia Antik Kenti',
        description:
            'Dünya\'nın en iyi korunmuş ve en büyük stadyumlarından birine sahip antik kent.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.85,
        lng: 27.52,
        reviews: [
          Review(
            user: 'ArkeoSever',
            comment: 'Stadyum kazısı muazzam sonuç vermiş!',
            rating: 5,
            date: '2024-03-30',
          ),
        ],
      ),
      Place(
        name: 'Yörük Ali Efe Müzesi',
        description:
            'Kurtuluş Savaşı kahramanı Yörük Ali Efe\'nin Yenipazar\'daki tarihi evi ve eşyaları.',
        category: 'Müze',
        rating: 4.6,
        lat: 37.81,
        lng: 28.19,
        reviews: [
          Review(
            user: 'Vatan',
            comment: 'Milli mücadele ruhunu hissetmek için gidilmeli.',
            rating: 5,
            date: '2024-05-19',
          ),
        ],
      ),
      Place(
        name: 'Karacasu Etnografya Müzesi',
        description:
            'Yüzyıllık kültürü, özellikle Afrodisias bölgesi kültürünü ve çömlek sanatını sergiler.',
        category: 'Müze',
        rating: 4.3,
        lat: 37.73,
        lng: 28.60,
        reviews: [],
      ),
      Place(
        name: 'Kurşunlu Manastırı',
        description:
            'Dilek Yarımadası\'nda saklı kalan nefes kesici manzarasıyla 11. Yüzyıl Ortodoks Manastırı.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.68,
        lng: 27.20,
        reviews: [],
      ),
      Place(
        name: 'Bafa Gölü Tabiat Parkı',
        description:
            'Aydın ve Muğla sınırında, binlerce kuş türüne ev sahipliği yapan ve tepesinde adacıklar bulunan göl.',
        category: 'Doğa',
        rating: 4.7,
        lat: 37.51,
        lng: 27.46,
        reviews: [
          Review(
            user: 'KuşGözlemcisi',
            comment: 'Flamingolar için doğru mevsimde harika.',
            rating: 5,
            date: '2024-01-20',
          ),
        ],
      ),
      Place(
        name: 'İlyas Bey Külliyesi',
        description:
            'Milet antik kentinin hemen yanında yer alan, eşsiz taş işçiliğiyle bilinen beylikler devri eseri.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.52,
        lng: 27.28,
        reviews: [],
      ),
      Place(
        name: 'Oleatrium Zeytin ve Zeytinyağı Tarihi Müzesi',
        description:
            'Zeytin ile ilgili Anadolu\'nun kültür tarihini yansıtan Türkiye\'nin en gelişmiş müzelerinden biri.',
        category: 'Müze',
        rating: 4.9,
        lat: 37.78,
        lng: 27.29,
        reviews: [
          Review(
            user: 'Gurme',
            comment: 'Beklentimin çok üstünde bir müze, harika tasarım.',
            rating: 5,
            date: '2024-06-12',
          ),
        ],
      ),
      Place(
        name: 'Kuşadası Milli Park Koyları',
        description:
            'Kavaklıburun, Karasu ve Aydınlık koyları; adeta bir akvaryumu andıran tertemiz sulara sahiptir.',
        category: 'Deniz',
        rating: 4.9,
        lat: 37.70,
        lng: 27.16,
        reviews: [],
      ),
      Place(
        name: 'Gerga Antik Kenti',
        description:
            'Devrilmiş heykelleri ve sarp kayalıklara kazınmış GERGA yazılarıyla gizemli, Karia kenti.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.60,
        lng: 28.01,
        reviews: [],
      ),
      Place(
        name: 'Cihanoğlu Camii',
        description:
            'Aydın il merkezinde, barok mimarinin Türk-İslam geleneğiyle sentezlendiği zarif cami.',
        category: 'Tarihi',
        rating: 4.4,
        lat: 37.84,
        lng: 27.84,
        reviews: [],
      ),
      Place(
        name: 'Öküz Mehmed Paşa Kervansarayı',
        description:
            'Kuşadası çarşı içinde 4 asırlık tarihi kervansaray, günümüzde etkinliklere ev sahipliği yapar.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.86,
        lng: 27.26,
        reviews: [],
      ),
      Place(
        name: 'Kuşadası Çarşısı ve Kaleiçi',
        description:
            'Taş sokaklar arasına gizlenmiş barlar, hediyelik eşya dükkanları ve yöresel ürünler.',
        category: 'Gezi',
        rating: 4.5,
        lat: 37.86,
        lng: 27.25,
        reviews: [],
      ),
      Place(
        name: 'Akbük Koyu',
        description:
            'Didim sınırları içinde çam ağaçlarının denizle birleştiği, huzurlu ve bol oksijenli koy.',
        category: 'Deniz',
        rating: 4.6,
        lat: 37.40,
        lng: 27.42,
        reviews: [
          Review(
            user: 'Huzur',
            comment: 'Çok sessiz ve dinlendirici bir yer.',
            rating: 4.5,
            date: '2024-07-26',
          ),
        ],
      ),
      Place(
        name: 'Saplı Ada',
        description:
            'Didim Akbük\'te denizin içinden yürüyerek geçilebilen, ilginç doğa oluşumu ada.',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.42,
        lng: 27.42,
        reviews: [],
      ),
      Place(
        name: 'Aydın Arkeoloji Müzesi',
        description:
            'Çevre antik kentlerden (Tralleis, Magnesia vs.) çıkan eşsiz eserlerin sergilendiği modern müze.',
        category: 'Müze',
        rating: 4.7,
        lat: 37.85,
        lng: 27.86,
        reviews: [
          Review(
            user: 'MüzeSever',
            comment: 'Heykellerin sergileme düzeni mükemmel.',
            rating: 5,
            date: '2024-02-14',
          ),
        ],
      ),
      Place(
        name: 'Paşa Yaylası',
        description:
            'Efeler merkeze çok yakın muhteşem yayla havası, serinliği ve çam ormanlarıyla ünlü dinlenme alanı.',
        category: 'Doğa',
        rating: 4.6,
        lat: 37.95,
        lng: 27.85,
        reviews: [],
      ),
      Place(
        name: 'Büyük Menderes Deltası Milli Parkı',
        description:
            'Söke ve Didim sahil bandında yer alan, yüzlerce göçmen kuşa ve flamingoya ev sahipliği yapan eşsiz delta.',
        category: 'Doğa',
        rating: 4.8,
        lat: 37.56,
        lng: 27.18,
        reviews: [
          Review(
            user: 'DoğaFoto',
            comment: 'Flamingoları izlemek için muazzam bir yer.',
            rating: 5,
            date: '2024-03-10',
          ),
        ],
      ),
      Place(
        name: 'Çine Vadisi',
        description:
            'Devasa, mitolojik görünümlü gnays kayalıkları arasından süzülen Çine Çayı ve köprüleriyle büyüleyici vadi.',
        category: 'Doğa',
        rating: 4.7,
        lat: 37.52,
        lng: 28.06,
        reviews: [
          Review(
            user: 'Yolcu',
            comment: 'Yol üstünde durup fotoğraf çekmeden geçilmez.',
            rating: 5,
            date: '2024-04-12',
          ),
        ],
      ),
      Place(
        name: 'Madran Dağı',
        description:
            'Bozdoğan ilçesini kucaklayan, muhteşem kaynak suları, zirvesi ve serinliğiyle ünlü görkemli dağ.',
        category: 'Doğa',
        rating: 4.5,
        lat: 37.64,
        lng: 28.26,
        reviews: [],
      ),
      Place(
        name: 'Sırtlanini Mağarası',
        description:
            'Karacasu ilçesinde bulunan, damlataş oluşumları, dikitleri ve sarkıtlarıyla gizemli bir doğa harikası.',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.74,
        lng: 28.61,
        reviews: [],
      ),
      Place(
        name: 'Dandalas Köprüsü',
        description:
            'Karacasu Dandalas çayı üzerinde kurulu, mimarisiyle göz dolduran tarihi kemer köprü.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.75,
        lng: 28.60,
        reviews: [],
      ),
      Place(
        name: 'Cincin Kalesi (Cihanoğlu Kalesi)',
        description:
            'Koçarlı Cincin köyünde, 18. yüzyıl Cihanoğulları Beyliği\'nden kalma görkemli tarihi kale ve konak kalıntısı.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.72,
        lng: 27.73,
        reviews: [],
      ),
      Place(
        name: 'Körteke Kalesi',
        description:
            'Bozdoğan Körteke köyünde sarp kayalıklar üzerine kurulmuş, ulaşması zor ama manzarası eşsiz Karya kalesi.',
        category: 'Tarihi',
        rating: 4.3,
        lat: 37.55,
        lng: 28.18,
        reviews: [],
      ),
      Place(
        name: 'Andız Kulesi',
        description:
            'Karpuzlu yöresinde Hellenistik döneme ait kalıntılardan oluşan, tarihi askeri gözetleme kulesi.',
        category: 'Tarihi',
        rating: 4.2,
        lat: 37.60,
        lng: 27.85,
        reviews: [],
      ),
      Place(
        name: 'Tavşan Adası',
        description:
            'Didim Panormos limanı açıklarında martıların ve yunusların uğrak noktası olan sevimli doğa harikası ada.',
        category: 'Doğa',
        rating: 4.5,
        lat: 37.36,
        lng: 27.24,
        reviews: [],
      ),
      Place(
        name: 'Gümrük Önü Hanı',
        description:
            'Efeler merkezde yer alan, restore edilmiş tarihi han ve yerel ürünlerin satıldığı nostaljik çarşı.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.84,
        lng: 27.84,
        reviews: [],
      ),
      Place(
        name: 'Aydın Kent Meydanı',
        description:
            'Şehrin en dinamik, palmiyeli ve dev süs havuzlu toplanma alanı. Gece turları için ideal.',
        category: 'Gezi',
        rating: 4.5,
        lat: 37.84,
        lng: 27.83,
        reviews: [],
      ),
      Place(
        name: 'Süleyman Bey Camii',
        description:
            'Efeler kalbinde, 17. yüzyılın en güzel Osmanlı taş işçiliklerinden birini yansıtan tarihi cami.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 37.85,
        lng: 27.84,
        reviews: [],
      ),
      Place(
        name: 'Forum Aydın AVM',
        description:
            'İncir ve zeytin ağaçlarıyla süslü açık hava konseptiyle Türkiye\'nin en sevilen alışveriş ve yaşam merkezlerinden biri.',
        category: 'Gezi',
        rating: 4.8,
        lat: 37.83,
        lng: 27.86,
        reviews: [
          Review(
            user: 'AlışverişTutkunu',
            comment: 'Açık hava mimarisi harika, bunaltmıyor.',
            rating: 5,
            date: '2024-05-15',
          ),
        ],
      ),
      Place(
        name: 'Tarihi Aydın Evleri (Hasanefendi)',
        description:
            'Hasanefendi ve Kozdibi mahallelerinde özenle korunmuş, restore edilmiş ahşap ve taş işlemeli tarihi konaklar.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.85,
        lng: 27.84,
        reviews: [],
      ),
      Place(
        name: 'Pınarbaşı Mesire Alanı ve Aytepe',
        description:
            'Efeler ilçesini kuşbakışı gören, çam ağaçları içindeki serin piknik, macera ve dinlenme tesisi.',
        category: 'Doğa',
        rating: 4.5,
        lat: 37.85,
        lng: 27.83,
        reviews: [],
      ),
      Place(
        name: 'Güzelçamlı Milli Parkı Seyir Terası',
        description:
            'Samos adasını ve tüm Ege sahillerini kuşbakışı görebileceğiniz, eşsiz deniz manzaralı yüksek teras.',
        category: 'Doğa',
        rating: 4.8,
        lat: 37.712,
        lng: 27.215,
        reviews: [],
      ),
      Place(
        name: 'Milet Müzesi',
        description:
            'Milet antik kentinin hemen yanında, antik İyonya bölgesinin muazzam heykellerinin sergilendiği müze.',
        category: 'Müze',
        rating: 4.6,
        lat: 37.530,
        lng: 27.276,
        reviews: [],
      ),
      Place(
        name: 'Karacasu Çömlek Atölyeleri',
        description:
            'Kırmızı toprağın sanata dönüştüğü, ustaları çalışırken izleyebileceğiniz asırlık atölyeler.',
        category: 'Gezi',
        rating: 4.5,
        lat: 37.734,
        lng: 28.598,
        reviews: [],
      ),
      Place(
        name: 'Bozdoğan Kemer Barajı',
        description:
            'Arapapıştı kanyonunu da besleyen, etrafında balık restoranları ve piknik alanları olan dev baraj gölü.',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.538,
        lng: 28.349,
        reviews: [],
      ),
      Place(
        name: 'İsmail Cem Barış Meydanı ve El Heykeli',
        description:
            'Kuşadası sahilinde gün batımının en güzel izlendiği, üzerinde kuşların uçuştuğu barış heykelli ikonik meydan.',
        category: 'Gezi',
        rating: 4.5,
        lat: 37.863,
        lng: 27.257,
        reviews: [],
      ),
      Place(
        name: 'Çine Yolu Çöp Şiş Tesisleri',
        description:
            'Muğla-Marmaris yolculuklarının vazgeçilmez durağı; sıra sıra dizilmiş meşhur Çine köfte ve çöp şiş mekanları.',
        category: 'Gezi',
        rating: 4.7,
        lat: 37.577,
        lng: 28.058,
        reviews: [],
      ),
      Place(
        name: 'Yediler Manastırı (Gölyaka)',
        description:
            'Bafa Gölü eteklerinde, Beşparmak (Latmos) dağları içine gizlenmiş, yürüyüş rotalarıyla ünlü tarihi manastır.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.536,
        lng: 27.525,
        reviews: [],
      ),
      Place(
        name: 'Karakaya Prehistorik Kaya Resimleri',
        description:
            'Latmos Dağları\'nda bulunan 8.000 yıllık, dünya tarihine ışık tutan prehistorik çağ kaya resimleri.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 37.540,
        lng: 27.560,
        reviews: [
          Review(
            user: 'ArkeoGezi',
            comment: 'Bulmak için zorlu bir yürüyüş gerekiyor ama muazzam!',
            rating: 5,
            date: '2024-05-11',
          ),
        ],
      ),
      Place(
        name: 'Panionion',
        description:
            'Güzelçamlı\'da antik çağda 12 İyon şehrinin bir araya gelip siyasi kararlar aldığı antik toplanma merkezi.',
        category: 'Tarihi',
        rating: 4.2,
        lat: 37.714,
        lng: 27.227,
        reviews: [],
      ),
      Place(
        name: 'Kuşadası Setur Marina',
        description:
            'Lüks yatların demirlediği, lüks mağazalar ve restoranlarla dolu modern marina ve yaşam alanı.',
        category: 'Gezi',
        rating: 4.6,
        lat: 37.872,
        lng: 27.260,
        reviews: [],
      ),
      Place(
        name: 'D-Marin Didim Marina',
        description:
            'Ege\'nin en büyük yat limanlarından biri; özel plajı, kafe ve restoranlarıyla seçkin bir buluşma noktası.',
        category: 'Gezi',
        rating: 4.7,
        lat: 37.341,
        lng: 27.255,
        reviews: [],
      ),
      Place(
        name: 'Serçin Köyü Ekokamp',
        description:
            'Bafa Gölü tabiat parkı sınırında, özellikle yılan balığı tadımı ve kamp yapmak için harika bir ekoturizm köyü.',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.558,
        lng: 27.424,
        reviews: [],
      ),
      Place(
        name: 'Davutlar Şifa Kaplıcaları',
        description:
            'Kuşadası Davutlar bölgesinde yer alan, termal suları ve lüks hamam/spa tesisleriyle ünlü şifa merkezi.',
        category: 'Gezi',
        rating: 4.5,
        lat: 37.720,
        lng: 27.265,
        reviews: [],
      ),
      Place(
        name: 'Kapıkırı Köyü (Herakleia)',
        description:
            'Milas sınırında ağırlıklı Bafa Gölü etrafında şekillenmiş, evlerin antik kent kalıntılarıyla iç içe geçtiği taş köy.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.502,
        lng: 27.525,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 10,
    name: 'Balıkesir',
    region: 'Marmara',
    lat: 39.65,
    lng: 27.88,
    population: 1251500,
    places: [
      Place(
        name: 'Ayvalık',
        description: 'Taş evleri ve zeytinlikleri ile ünlü',
        category: 'Gezi',
        rating: 4.6,
        lat: 39.31,
        lng: 26.69,
        reviews: [
          Review(
            user: 'Gezici',
            comment: 'Muhteşem!',
            rating: 5,
            date: '2024-07-25',
          ),
        ],
      ),
      Place(
        name: 'Kazdağları Milli Parkı (İda Dağı)',
        description:
            'Edremit körfezine tepeden bakan, Alplerden sonra dünyanın en yüksek oksijen oranına sahip efsanevi oksijen deposu dağ.',
        category: 'Doğa',
        rating: 4.9,
        lat: 39.697,
        lng: 26.892,
        reviews: [
          Review(
            user: 'Rehber',
            comment: 'Oksijen deposu, efsanelerin ve mitolojinin kalbi!',
            rating: 5,
            date: '2024-05-18',
          ),
        ],
      ),
      Place(
        name: 'Hasanboğuldu Göleti ve Sütüven Şelalesi',
        description:
            'Edremit Zeytinli köyü üzerinden ulaşılan, efsanelere konu olmuş, yemyeşil orman içinde buz gibi suyuyla muhteşem şelale ve gölet.',
        category: 'Doğa',
        rating: 4.8,
        lat: 39.638,
        lng: 26.940,
        reviews: [],
      ),
      Place(
        name: 'Sarıkız Tepesi',
        description:
            'Edremit Kazdağları\'nın zirvelerinden biri olan, efsanelere konu olmuş ve tüm körfezi ayaklar altına alan kutsal sayılan seyir noktası.',
        category: 'Doğa',
        rating: 4.7,
        lat: 39.704,
        lng: 26.837,
        reviews: [],
      ),
      Place(
        name: 'Antandros Antik Kenti',
        description:
            'Edremit Altınoluk\'ta zeytinlikler içine saklanmış, dünyanın ilk güzellik yarışmasının yapıldığı İda dağının yamaçlarındaki mozaikli tarihi Roma kenti.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 39.574,
        lng: 26.776,
        reviews: [],
      ),
      Place(
        name: 'Tahtakuşlar Etnografya Müzesi',
        description:
            'Edremit Tahtakuşlar köyünde yer alan, Şaman geleneklerini ve Alevi-Türkmen kültürünü sergileyen Türkiye\'nin ilk özel Türkmen etnografya müzesi.',
        category: 'Müze',
        rating: 4.6,
        lat: 39.610,
        lng: 26.860,
        reviews: [],
      ),
      Place(
        name: 'Şahinderesi Kanyonu',
        description:
            'Edremit Altınoluk arka taraflarında, Kazdağları\'nın sarp ve el değmemiş yamaçlarında yer alan nefes kesici, 27 kilometre uzunluğundaki macera kanyonu.',
        category: 'Doğa',
        rating: 4.9,
        lat: 39.605,
        lng: 26.743,
        reviews: [],
      ),
      Place(
        name: 'Altınoluk (Oksijen Çadırı)',
        description:
            'Kazdağları\'nın eteklerinde, dünyaca ünlü oksijen seviyesi, zeytin ağaçları ve harika sahil sularıyla meşhur Edremit mahallesi.',
        category: 'Deniz',
        rating: 4.6,
        lat: 39.576,
        lng: 26.746,
        reviews: [],
      ),
      Place(
        name: 'Akçay Kordon',
        description:
            'Buz gibi artezyen sularının deniz içinden fışkırdığı (Sarıkız suyu), uzun yürüyüş yolları ve çay bahçeleriyle körfezin hareketli Edremit sahili.',
        category: 'Gezi',
        rating: 4.4,
        lat: 39.585,
        lng: 26.920,
        reviews: [],
      ),
      Place(
        name: 'Güre Kaplıcaları ve Tesisleri',
        description:
            'Edremit Güre\'de Afrodit\'in güzellik sırrı olduğu rivayet edilen termal sular, lüks oteller ve tertemiz bir doğa.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.606,
        lng: 26.862,
        reviews: [],
      ),
      Place(
        name: 'Cunda (Alibey) Adası',
        description:
            'Ayvalık sahiline tarihi bir köprü ile bağlı; Arnavut kaldırımlı sokakları, taş evleri, Rum mimarisi, Yel Değirmeni ve muazzam deniz ürünleri restoranlarıyla efsane ada.',
        category: 'Gezi',
        rating: 4.9,
        lat: 39.336,
        lng: 26.657,
        reviews: [],
      ),
      Place(
        name: 'Şeytan Sofrası',
        description:
            'Ayvalık\'ta volkanik lav birikintilerinin oluşturduğu sarp tepe. Tüm Midilli adasını ve adacıkları görebileceğiniz harika gün batımı noktası.',
        category: 'Doğa',
        rating: 4.8,
        lat: 39.262,
        lng: 26.643,
        reviews: [
          Review(
            user: 'Manzara',
            comment: 'Gün batımı sırasında iğne atsanız yere düşmez ama değer.',
            rating: 5,
            date: '2024-06-30',
          ),
        ],
      ),
      Place(
        name: 'Sarımsaklı Plajı',
        description:
            'Ayvalık\'ta kilometrelerce uzanan, incecik kumu ve pürüzsüz suyuyla dünyanın en uzun plajlarından ve turizm merkezlerinden biri.',
        category: 'Deniz',
        rating: 4.7,
        lat: 39.264,
        lng: 26.663,
        reviews: [],
      ),
      Place(
        name: 'Kuşcenneti Milli Parkı',
        description:
            'Bandırma\'da Manyas gölü çevresinde, her yıl 3 milyona yakın göçmen kuşa ve pelikanlara ev sahipliği yapan muazzam sulak alan.',
        category: 'Doğa',
        rating: 4.6,
        lat: 40.218,
        lng: 28.021,
        reviews: [],
      ),
      Place(
        name: 'Susurluk Çay Evi ve Tesisleri',
        description:
            'Meşhur bol köpüklü ayranı, Susurluk tostu ve zeytinyağlıların ana vatanı olan Balıkesir-Bursa yolu üstü dinlenme klasikleri bölgesi.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.914,
        lng: 28.163,
        reviews: [],
      ),
      Place(
        name: 'Kyzikos Antik Kenti',
        description:
            'Erdek ilçesinde Kapıdağ yarımadasının bağlandığı kıstakta yer alan, dünyanın en büyük Hadrian tapınağına sahip antik Roma kalıntıları.',
        category: 'Tarihi',
        rating: 4.3,
        lat: 40.385,
        lng: 27.874,
        reviews: [],
      ),
      Place(
        name: 'Kapıdağ Yarımadası Ormanları',
        description:
            'Erdek ilçesini sarmalayan, Karadeniz ormanlarını aratmayan gür bitki örtüsü, şelaleleri, zorlu dağ yolları ve saklı koyları olan dev yarımada.',
        category: 'Doğa',
        rating: 4.7,
        lat: 40.481,
        lng: 27.842,
        reviews: [],
      ),
      Place(
        name: 'Gömeç Atatürk Kayalıkları',
        description:
            'Gömeç ilçesi tepelerinde yer alan, İzmir yolu üzerinden çok net görülen ve silüeti direkt olarak Mustafa Kemal Atatürk\'ün profiline benzeyen mucizevi doğal kayalıklar.',
        category: 'Doğa',
        rating: 4.7,
        lat: 39.387,
        lng: 26.851,
        reviews: [],
      ),
      Place(
        name: 'Ören Sahili ve Pelitköy',
        description:
            'Burhaniye\'de Kazdağları oksijeniyle çam ve asırlık meşe ağaçlarının direkt sahil kumlarıyla birleştiği, muazzam yürüyüş yollarına sahip tatil beldesi.',
        category: 'Deniz',
        rating: 4.6,
        lat: 39.497,
        lng: 26.936,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 11,
    name: 'Bilecik',
    region: 'Marmara',
    lat: 40.05,
    lng: 30.0,
    population: 228673,
    places: [
      Place(
        name: 'Söğüt',
        description: 'Osmanlı Devleti\'nin kuruluş yeri',
        category: 'Tarihi',
        rating: 4.3,
        lat: 40.03,
        lng: 30.18,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 12,
    name: 'Bingöl',
    region: 'Doğu Anadolu',
    lat: 38.88,
    lng: 40.49,
    population: 281205,
    places: [
      Place(
        name: 'Yıldırım Dağı',
        description: 'Kayak merkezi',
        category: 'Doğa',
        rating: 4.0,
        lat: 38.85,
        lng: 40.50,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 13,
    name: 'Bitlis',
    region: 'Doğu Anadolu',
    lat: 38.40,
    lng: 42.10,
    population: 353988,
    places: [
      Place(
        name: 'Ahlat Selçuklu Mezarlığı',
        description: 'Dünyanın en büyük Türk-İslam mezarlığı',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.75,
        lng: 42.48,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 14,
    name: 'Bolu',
    region: 'Karadeniz',
    lat: 40.73,
    lng: 31.61,
    population: 316126,
    places: [
      Place(
        name: 'Abant Gölü',
        description: 'Doğa harikası göl',
        category: 'Doğa',
        rating: 4.7,
        lat: 40.60,
        lng: 31.28,
        reviews: [
          Review(
            user: 'Doğasever',
            comment: 'Her mevsim güzel',
            rating: 5,
            date: '2024-09-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 15,
    name: 'Burdur',
    region: 'Akdeniz',
    lat: 37.72,
    lng: 30.29,
    population: 270796,
    places: [
      Place(
        name: 'Salda Gölü',
        description: 'Türkiye\'nin Maldivleri',
        category: 'Doğa',
        rating: 4.8,
        lat: 37.53,
        lng: 29.67,
        reviews: [
          Review(
            user: 'Fotoğrafçı',
            comment: 'İnanılmaz renk!',
            rating: 5,
            date: '2024-08-01',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 16,
    name: 'Bursa',
    region: 'Marmara',
    lat: 40.18,
    lng: 29.06,
    population: 3147818,
    places: [
      Place(
        name: 'Uludağ',
        description: 'Türkiye\'nin en ünlü kayak merkezi',
        category: 'Doğa',
        rating: 4.6,
        lat: 40.08,
        lng: 29.23,
        reviews: [
          Review(
            user: 'Kayakçı',
            comment: 'Pistler harika',
            rating: 4.5,
            date: '2024-01-20',
          ),
        ],
      ),
      Place(
        name: 'Yeşil Türbe',
        description: 'Osmanlı mimari şaheseri',
        category: 'Tarihi',
        rating: 4.5,
        lat: 40.18,
        lng: 29.07,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 17,
    name: 'Çanakkale',
    region: 'Marmara',
    lat: 40.15,
    lng: 26.41,
    population: 560000,
    places: [
      Place(
        name: 'Truva Antik Kenti',
        description: 'UNESCO - Efsanevi antik kent',
        category: 'Tarihi',
        rating: 4.5,
        lat: 39.96,
        lng: 26.24,
        reviews: [
          Review(
            user: 'Tarih',
            comment: 'Etkileyici',
            rating: 4.5,
            date: '2024-05-10',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 18,
    name: 'Çankırı',
    region: 'İç Anadolu',
    lat: 40.60,
    lng: 33.61,
    population: 195789,
    places: [
      Place(
        name: 'Tuz Mağarası',
        description: 'Şifalı tuz mağarası',
        category: 'Doğa',
        rating: 4.2,
        lat: 40.60,
        lng: 33.60,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 19,
    name: 'Çorum',
    region: 'Karadeniz',
    lat: 40.55,
    lng: 34.95,
    population: 536000,
    places: [
      Place(
        name: 'Hattuşa',
        description: 'UNESCO - Hitit başkenti',
        category: 'Tarihi',
        rating: 4.6,
        lat: 40.02,
        lng: 34.62,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 20,
    name: 'Denizli',
    region: 'Ege',
    lat: 37.77,
    lng: 29.08,
    population: 1037000,
    places: [
      Place(
        name: 'Pamukkale',
        description: 'UNESCO - Beyaz travertenler',
        category: 'Doğa',
        rating: 4.9,
        lat: 37.92,
        lng: 29.12,
        reviews: [
          Review(
            user: 'Turist',
            comment: 'Dünya harikası!',
            rating: 5,
            date: '2024-04-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 21,
    name: 'Diyarbakır',
    region: 'Güneydoğu Anadolu',
    lat: 37.91,
    lng: 40.24,
    population: 1790000,
    places: [
      Place(
        name: 'Diyarbakır Surları',
        description: 'UNESCO - Dünyanın en uzun ikinci surları',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.91,
        lng: 40.23,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 22,
    name: 'Edirne',
    region: 'Marmara',
    lat: 41.68,
    lng: 26.55,
    population: 413000,
    places: [
      Place(
        name: 'Selimiye Camii',
        description: 'UNESCO - Mimar Sinan\'ın şaheseri',
        category: 'Tarihi',
        rating: 4.9,
        lat: 41.68,
        lng: 26.56,
        reviews: [
          Review(
            user: 'Mimarsever',
            comment: 'Mükemmel',
            rating: 5,
            date: '2024-03-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 23,
    name: 'Elazığ',
    region: 'Doğu Anadolu',
    lat: 38.68,
    lng: 39.22,
    population: 591000,
    places: [
      Place(
        name: 'Hazar Gölü',
        description: 'Doğu\'nun gizli cenneti',
        category: 'Doğa',
        rating: 4.3,
        lat: 38.49,
        lng: 39.38,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 24,
    name: 'Erzincan',
    region: 'Doğu Anadolu',
    lat: 39.75,
    lng: 39.49,
    population: 238000,
    places: [
      Place(
        name: 'Ergan Dağı Kayak Merkezi',
        description: 'Modern kayak merkezi',
        category: 'Doğa',
        rating: 4.2,
        lat: 39.73,
        lng: 39.65,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 25,
    name: 'Erzurum',
    region: 'Doğu Anadolu',
    lat: 39.90,
    lng: 41.27,
    population: 758000,
    places: [
      Place(
        name: 'Palandöken',
        description: 'Kayak merkezi',
        category: 'Doğa',
        rating: 4.6,
        lat: 39.88,
        lng: 41.33,
        reviews: [
          Review(
            user: 'Kayakçı2',
            comment: 'Süper pistler',
            rating: 4.5,
            date: '2024-02-10',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 26,
    name: 'Eskişehir',
    region: 'İç Anadolu',
    lat: 39.77,
    lng: 30.52,
    population: 888000,
    places: [
      Place(
        name: 'Odunpazarı Evleri',
        description: 'Renkli Osmanlı evleri',
        category: 'Tarihi',
        rating: 4.5,
        lat: 39.76,
        lng: 30.53,
        reviews: [],
      ),
      Place(
        name: 'Porsuk Çayı',
        description: 'Gondol gezisi',
        category: 'Gezi',
        rating: 4.4,
        lat: 39.77,
        lng: 30.52,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 27,
    name: 'Gaziantep',
    region: 'Güneydoğu Anadolu',
    lat: 37.07,
    lng: 37.38,
    population: 2101000,
    places: [
      Place(
        name: 'Zeugma Müzesi',
        description: 'Dünyanın en büyük mozaik koleksiyonu',
        category: 'Müze',
        rating: 4.8,
        lat: 37.07,
        lng: 37.38,
        reviews: [
          Review(
            user: 'Sanat',
            comment: 'Muhteşem mozaikler',
            rating: 5,
            date: '2024-06-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 28,
    name: 'Giresun',
    region: 'Karadeniz',
    lat: 40.91,
    lng: 38.39,
    population: 453000,
    places: [
      Place(
        name: 'Giresun Adası',
        description: 'Karadeniz\'in tek adası',
        category: 'Doğa',
        rating: 4.3,
        lat: 40.92,
        lng: 38.38,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 29,
    name: 'Gümüşhane',
    region: 'Karadeniz',
    lat: 40.46,
    lng: 39.48,
    population: 151000,
    places: [
      Place(
        name: 'Karaca Mağarası',
        description: 'Muhteşem sarkıt/dikit oluşumları',
        category: 'Doğa',
        rating: 4.5,
        lat: 40.55,
        lng: 39.10,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 30,
    name: 'Hakkari',
    region: 'Güneydoğu Anadolu',
    lat: 37.58,
    lng: 43.74,
    population: 280000,
    places: [
      Place(
        name: 'Cilo Dağı',
        description: 'Buzul gölleri ve dağcılık',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.50,
        lng: 44.00,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 31,
    name: 'Hatay',
    region: 'Akdeniz',
    lat: 36.40,
    lng: 36.35,
    population: 1659000,
    places: [
      Place(
        name: 'St. Pierre Kilisesi',
        description: 'Hristiyanlığın ilk kilisesi',
        category: 'Tarihi',
        rating: 4.5,
        lat: 36.41,
        lng: 36.36,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 32,
    name: 'Isparta',
    region: 'Akdeniz',
    lat: 37.76,
    lng: 30.55,
    population: 445000,
    places: [
      Place(
        name: 'Eğirdir Gölü',
        description: 'Göller bölgesinin incisi',
        category: 'Doğa',
        rating: 4.4,
        lat: 37.89,
        lng: 30.87,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 33,
    name: 'Mersin',
    region: 'Akdeniz',
    lat: 36.80,
    lng: 34.63,
    population: 1868000,
    places: [
      Place(
        name: 'Kızkalesi',
        description: 'Denizde yüzen kale',
        category: 'Tarihi',
        rating: 4.5,
        lat: 36.46,
        lng: 34.15,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 34,
    name: 'İstanbul',
    region: 'Marmara',
    lat: 41.01,
    lng: 28.98,
    population: 15907951,
    places: [
      Place(
        name: 'Ayasofya-i Kebir Cami-i Şerifi',
        description:
            'Dünya mimarlık tarihinin başyapıtlarından, 1500 yıllık efsanevi mabet ve Ayasofya Meydanı.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 41.008,
        lng: 28.980,
        reviews: [
          Review(
            user: 'TarihSever',
            comment: 'Kubbenin altındaki ihtişam tarif edilemez!',
            rating: 5,
            date: '2024-11-01',
          ),
        ],
      ),
      Place(
        name: 'Topkapı Sarayı',
        description:
            'Osmanlı İmparatorluğu\'nun 400 yıl boyunca kalbi olan, Kutsal Emanetler ve Harem\'i barındıran devasa imparatorluk sarayı.',
        category: 'Müze',
        rating: 4.8,
        lat: 41.011,
        lng: 28.983,
        reviews: [],
      ),
      Place(
        name: 'Yerebatan Sarnıcı',
        description:
            'Medusa başı ve mistik aydınlatmasıyla büyüleyen, Bizans döneminden kalma devasa yer altı su sarnıcı.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 41.008,
        lng: 28.978,
        reviews: [],
      ),
      Place(
        name: 'Sultanahmet Camii (Blue Mosque)',
        description:
            'Altı minaresi ve içini süsleyen 20.000\'i aşkın mavi İznik çinisiyle İstanbul silüetinin vazgeçilmezi.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 41.005,
        lng: 28.976,
        reviews: [],
      ),
      Place(
        name: 'Kapalıçarşı (Grand Bazaar)',
        description:
            '4000\'den fazla dükkanı ve 61 sokağıyla dünyanın en eski ve en büyük tarihi kapalı alışveriş merkezi.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.010,
        lng: 28.968,
        reviews: [],
      ),
      Place(
        name: 'Süleymaniye Camii',
        description:
            'Mimar Sinan\'ın "Kalfalık eserim" dediği, şehrin her yerinden görünen ve muazzam bir akustiğe sahip başyapıt.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 41.016,
        lng: 28.964,
        reviews: [],
      ),
      Place(
        name: 'Mısır Çarşısı',
        description:
            'Eminönü\'nde baharat, lokum ve kuruyemiş kokularının birbirine karıştığı efsanevi tarihi çarşı.',
        category: 'Gezi',
        rating: 4.7,
        lat: 41.016,
        lng: 28.970,
        reviews: [],
      ),
      Place(
        name: 'Galata Kulesi',
        description:
            'Cenevizlilerden günümüze ulaşan, Haliç ve Boğaz manzarasına 360 derece hakim, İstanbul\'un en romantik kulesi.',
        category: 'Gezi',
        rating: 4.8,
        lat: 41.025,
        lng: 28.974,
        reviews: [],
      ),
      Place(
        name: 'İstiklal Caddesi ve Taksim Meydanı',
        description:
            'Nostaljik tramvayı, tarihi pasajları (Çiçek Pasajı), kiliseleri ve 24 saat bitmeyen enerjisiyle şehrin atardamarı.',
        category: 'Gezi',
        rating: 4.5,
        lat: 41.034,
        lng: 28.978,
        reviews: [],
      ),
      Place(
        name: 'Dolmabahçe Sarayı',
        description:
            'Ulu Önder Atatürk\'ün hayata gözlerini yumduğu, Boğaz\'a sıfır rüya gibi mimarisiyle son dönem Osmanlı sarayı.',
        category: 'Müze',
        rating: 4.9,
        lat: 41.039,
        lng: 28.998,
        reviews: [],
      ),
      Place(
        name: 'Ortaköy Meydanı ve Camii',
        description:
            'Boğaziçi Köprüsü\'nün hemen altında, kumpircileri ve Boğaz\'la bütünleşen ikonik Barok tarzdaki camisiyle ünlü meydan.',
        category: 'Gezi',
        rating: 4.8,
        lat: 41.047,
        lng: 29.027,
        reviews: [],
      ),
      Place(
        name: 'Rumeli Hisarı',
        description:
            'Fatih Sultan Mehmet tarafından İstanbul\'un fethinden hemen önce 90 günde yaptırılan devasa şaheser.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 41.085,
        lng: 29.052,
        reviews: [],
      ),
      Place(
        name: 'Kız Kulesi',
        description:
            'Üsküdar Salacak açıklarında, İstanbul denince akla ilk gelen efsanelere konu olmuş yalnız ve güzel kule.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 41.021,
        lng: 29.004,
        reviews: [],
      ),
      Place(
        name: 'Çamlıca Tepesi, Kulesi ve Camii',
        description:
            'Asya yakasının en yüksek noktası; İstanbul\'un panoramik manzarasını ayaklar altına alan modern kule ve devasa yeni cami.',
        category: 'Gezi',
        rating: 4.7,
        lat: 41.032,
        lng: 29.066,
        reviews: [],
      ),
      Place(
        name: 'Kuzguncuk Sokakları',
        description:
            'Üsküdar\'da ahşap köşkleri, hoşgörü kültürü (Cami, kilise ve sinagog yan yana) ve dizi setleriyle meşhur semt.',
        category: 'Gezi',
        rating: 4.8,
        lat: 41.036,
        lng: 29.030,
        reviews: [],
      ),
      Place(
        name: 'Pierre Loti Tepesi',
        description:
            'Eyüpsultan\'da teleferikle çıkılan, Haliç\'in altın boynuz manzarasına karşı kahve yudumlanabilen tarihi tepe.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.054,
        lng: 28.933,
        reviews: [],
      ),
      Place(
        name: 'Emirgan Korusu',
        description:
            'Özellikle bahar aylarında (Nisan) Tulip (Lale) festivali zamanı yüzbinlerce renge bürünen tarihi boğaz korusu.',
        category: 'Doğa',
        rating: 4.7,
        lat: 41.109,
        lng: 29.052,
        reviews: [],
      ),
      Place(
        name: 'Kanlıca Sahili ve Mihrabat Korusu',
        description:
            'Beykoz tarafında efsanevi pudra şekerli Kanlıca Yoğurdu yenilen tarihi yalılar bölgesi.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.100,
        lng: 29.064,
        reviews: [],
      ),
      Place(
        name: 'Büyükada ve Heybeliada Ruhban Okulu',
        description:
            'Prens Adaları\'nın en büyükleri; motorlu araçların yasak olduğu, tarihi köşkler ve devasa ormanlar sunan adalar.',
        category: 'Gezi',
        rating: 4.8,
        lat: 40.871,
        lng: 29.130,
        reviews: [],
      ),
      Place(
        name: 'Balat ve Fener Sokakları',
        description:
            'Tarihi renkli cumba evleri, kırmızı tuğlalı devasa Fener Rum Lisesi ve Demir Kilise (Sveti Stefan) ile Fatih\'in incisi.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 41.030,
        lng: 28.947,
        reviews: [],
      ),
      Place(
        name: 'Karaköy ve Galataport',
        description:
            'İstanbul\'un yeni kruvaziyer limanı Galataport ile Karaköy\'ün tarihi sokak ve kafelerinin modern birleşimi.',
        category: 'Gezi',
        rating: 4.7,
        lat: 41.025,
        lng: 28.981,
        reviews: [],
      ),
      Place(
        name: 'Belgrad Ormanı',
        description:
            'Sarıyer sırtlarında, şehrin su ihtiyacını yüzyıllardır karşılayan Kemerburgaz su kemerlerine ve yürüyüş parkurlarına sahip dev akciğer.',
        category: 'Doğa',
        rating: 4.6,
        lat: 41.185,
        lng: 28.956,
        reviews: [],
      ),
      Place(
        name: 'Bebek Sahili ve Aşiyan',
        description:
            'Lüks yatların, efsanevi badem ezmesinin ve harika sahil yürüyüş yolunun adresi.',
        category: 'Gezi',
        rating: 4.8,
        lat: 41.077,
        lng: 29.043,
        reviews: [],
      ),
      Place(
        name: 'Moda Sahili ve Süreyya Operası',
        description:
            'Kadıköy\'ün sanat ve huzur dolu semti, ikonik tarihi tramvay ve çimlerde güneşi batırma noktası.',
        category: 'Gezi',
        rating: 4.8,
        lat: 40.980,
        lng: 29.023,
        reviews: [],
      ),
      Place(
        name: 'Eyüp Sultan Camii ve Külliyesi',
        description:
            'İstanbul\'un manevi kalbi ve en kutsal ziyaret mekanlarından biri olan tarihi asırlık külliye.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 41.047,
        lng: 28.934,
        reviews: [],
      ),
      Place(
        name: 'Ihlamur Kasırları',
        description:
            'Beşiktaş Nişantaşı arasında saklı kalmış, zarafetiyle büyüleyen Osmanlı dinlenme köşkleri ve vadisi.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.050,
        lng: 28.999,
        reviews: [],
      ),
      Place(
        name: 'Miniatürk',
        description:
            'Haliç kıyısında Türkiye\'nin dört bir yanından seçilmiş mimari eserlerin 1/25 ölçekli maketlerinin sergilendiği açık hava müzesi.',
        category: 'Müze',
        rating: 4.5,
        lat: 41.060,
        lng: 28.947,
        reviews: [],
      ),
      Place(
        name: 'Rahmi M. Koç Müzesi',
        description:
            'Haliç kıyısında ulaşım, endüstri ve iletişim tarihine adanmış interaktif devasa sanayi müzesi.',
        category: 'Müze',
        rating: 4.8,
        lat: 41.042,
        lng: 28.948,
        reviews: [],
      ),
      Place(
        name: 'Atatürk Arboretumu',
        description:
            'Sarıyer\'de binlerce farklı bitki, ağaç türü ve göletin bulunduğu cennetten kopma botanik park.',
        category: 'Doğa',
        rating: 4.8,
        lat: 41.168,
        lng: 28.985,
        reviews: [],
      ),
      Place(
        name: 'Nişantaşı (Abdi İpekçi Caddesi)',
        description:
            'İstanbul\'un en lüks mağazalarının, kafelerinin ve moda tasarımcılarının bulunduğu seçkin semt.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.054,
        lng: 28.992,
        reviews: [],
      ),
      Place(
        name: 'Yedikule Zindanları (Hisarı)',
        description:
            'İstanbul surlarının Marmara denizine yakın kısmında bulunan, tarihi Bizans Altın Kapısı ve Osmanlı zindanları.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 40.992,
        lng: 28.922,
        reviews: [],
      ),
      Place(
        name: 'Çamlıca Camii ve İslam Medeniyetleri Müzesi',
        description:
            'Türkiye\'nin en büyük camisi ve alt katlarında yer alan son teknoloji dijital İslam eserleri müzesi.',
        category: 'Müze',
        rating: 4.8,
        lat: 41.035,
        lng: 29.068,
        reviews: [],
      ),
      Place(
        name: 'Polonezköy Tabiat Parkı',
        description:
            'Beykoz\'da 1800\'lerde kurulan tarihi bir Polonya köyü; hafta sonu kahvaltıları ve dev orman yürüyüşleri için ideal.',
        category: 'Doğa',
        rating: 4.6,
        lat: 41.112,
        lng: 29.212,
        reviews: [],
      ),
      Place(
        name: 'Şile Feneri ve Ağva',
        description:
            'Karadeniz kıyısında İstanbul\'un arka bahçesi; devasa tarihi deniz feneri, plajları ve Göksu nehri.',
        category: 'Gezi',
        rating: 4.6,
        lat: 41.176,
        lng: 29.613,
        reviews: [],
      ),
      Place(
        name: 'Anadolu Kavağı ve Yoros Kalesi',
        description:
            'Boğazın Karadeniz\'e açıldığı noktada deniz ürünleri restoranları ve tarihi Ceneviz/Osmanlı kalesi.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 41.176,
        lng: 29.094,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 35,
    name: 'İzmir',
    region: 'Ege',
    lat: 38.42,
    lng: 27.14,
    population: 4394694,
    places: [
      Place(
        name: 'Efes Antik Kenti',
        description: 'UNESCO - Antik dünyanın harikası',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.94,
        lng: 27.34,
        reviews: [
          Review(
            user: 'Arkeolog',
            comment: 'Muhteşem!',
            rating: 5,
            date: '2024-05-20',
          ),
        ],
      ),
      Place(
        name: 'Kordon',
        description: 'Deniz kenarı yürüyüş yolu',
        category: 'Gezi',
        rating: 4.5,
        lat: 38.43,
        lng: 27.14,
        reviews: [],
      ),
      Place(
        name: 'İzmir Saat Kulesi',
        description:
            'Konak Meydanı\'nda yer alan, II. Abdülhamid\'in tahta çıkışının 25. yılı anısına yaptırılan şehrin zarif sembolü.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.418,
        lng: 27.128,
        reviews: [],
      ),
      Place(
        name: 'Kemeraltı Çarşısı',
        description:
            'Dünyanın en eski ve en büyük açık hava alışveriş merkezlerinden biri; baharatçılar, kahveciler ve tarihi hanlar.',
        category: 'Gezi',
        rating: 4.6,
        lat: 38.416,
        lng: 27.132,
        reviews: [],
      ),
      Place(
        name: 'Tarihi Asansör',
        description:
            'Karataş semtinde manzarasıyla büyüleyen, iki sokak arasındaki 58 metrelik kot farkını birleştiren tarihi kule.',
        category: 'Gezi',
        rating: 4.8,
        lat: 38.408,
        lng: 27.117,
        reviews: [
          Review(
            user: 'ManzaraAvcısı',
            comment:
                'Dario Moreno sokağından yürüyerek çıkmak ve kafesinde gün batımını izlemek efsane.',
            rating: 5,
            date: '2024-05-30',
          ),
        ],
      ),
      Place(
        name: 'Alsancak Sevgi Yolu ve Kıbrıs Şehitleri',
        description:
            'İzmir\'in kalbi Alsancak\'ta kitapçıların dizildiği sokaklar ve kafelerle dolu cıvıl cıvıl cadde.',
        category: 'Gezi',
        rating: 4.7,
        lat: 38.435,
        lng: 27.141,
        reviews: [],
      ),
      Place(
        name: 'Meryem Ana Evi',
        description:
            'Bülbüldağı\'nda bulunan ve Hz. Meryem\'in son günlerini geçirdiğine inanılan kutsal haç yeri.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.913,
        lng: 27.332,
        reviews: [],
      ),
      Place(
        name: 'Şirince Köyü',
        description:
            'Evleri, şarapları, taş sokakları ve matematik köyü ile ün salmış, tepeler arasına gizlenmiş eski Rum köyü.',
        category: 'Gezi',
        rating: 4.7,
        lat: 37.942,
        lng: 27.430,
        reviews: [
          Review(
            user: 'Gezgin',
            comment: 'Kumda kahve ve şarap tadımı harika.',
            rating: 5,
            date: '2024-06-12',
          ),
        ],
      ),
      Place(
        name: 'Alaçatı Yel Değirmenleri ve Sokakları',
        description:
            'Taş evleri, rüzgar sörfü, cumbalı rengarenk pencereleri ve butik otelleriyle ünlü Ege kasabası.',
        category: 'Gezi',
        rating: 4.7,
        lat: 38.283,
        lng: 26.375,
        reviews: [],
      ),
      Place(
        name: 'Çeşme Kalesi ve Marina',
        description:
            '16. Yüzyıldan kalma devasa kale ve denizcilik rüzgarlarının estiği lüks marina alanı.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 38.324,
        lng: 26.301,
        reviews: [],
      ),
      Place(
        name: 'Sığacık Kaleiçi ve Teos Antik Kenti',
        description:
            'Sakin Şehir (Cittaslow) Seferihisar\'da denize sıfır kaleiçi pazarı ve sanatçıların antik kenti Teos.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.196,
        lng: 26.784,
        reviews: [],
      ),
      Place(
        name: 'Eski Foça Evleri ve Limanı',
        description:
            'Siren kayalıkları, Akdeniz fokları ve taştan yığma tarihi ahşap evleriyle benzersiz balıkçı kasabası.',
        category: 'Gezi',
        rating: 4.8,
        lat: 38.667,
        lng: 26.756,
        reviews: [],
      ),
      Place(
        name: 'Bergama (Pergamon) Antik Kenti',
        description:
            'Dik yamaçlara kurulmuş, dik tiyatrosu ve antik dünyanın en büyük kütüphanelerinden biriyle UNESCO mirası.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 39.132,
        lng: 27.184,
        reviews: [],
      ),
      Place(
        name: 'Urla Bağ Yolu ve Sanat Sokağı',
        description:
            'Ege gastronomisinin başkenti kabul edilen, zeytinyağlıları, şarap bağları ve sanat dolu sokaklarıyla Urla.',
        category: 'Gezi',
        rating: 4.7,
        lat: 38.318,
        lng: 26.764,
        reviews: [],
      ),
      Place(
        name: 'Bostanlı Gün Batımı Seyir Terası',
        description:
            'Ahşap basamaklarıyla denize uzanan, gençlerin buluştuğu ve İzmir Körfezi\'nde gün batımının en güzel izlendiği yer.',
        category: 'Gezi',
        rating: 4.8,
        lat: 38.455,
        lng: 27.091,
        reviews: [],
      ),
      Place(
        name: 'İzmir Doğal Yaşam Parkı',
        description:
            'Avrupa\'nın en büyük doğal yaşam parklarından biri, hayvanların geniş alanlarda özgürce yaşadığı park.',
        category: 'Gezi',
        rating: 4.6,
        lat: 38.490,
        lng: 26.974,
        reviews: [],
      ),
      Place(
        name: 'İzmir Agorası (Smyrna Agorası)',
        description:
            'Şehrin ortasında, tarihi Kemeraltı Çarşısı\'na çok yakın konumdaki Antik Roma dönemine ait olağanüstü pazar yeri.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.416,
        lng: 27.139,
        reviews: [],
      ),
      Place(
        name: 'Karaburun Sarpıncık Feneri',
        description:
            'Ege Denizi\'nin sularına hakim, dağlık ve virajlı yollardan ulaşılan gizli oksijen deposu doğa harikası.',
        category: 'Doğa',
        rating: 4.6,
        lat: 38.653,
        lng: 26.368,
        reviews: [],
      ),
      Place(
        name: 'Balçova Teleferik Tesisleri',
        description:
            'İzmir Körfezi ve orman manzarasını aynı anda sunan, barbekü alanlarına sahip eşsiz seyir noktası.',
        category: 'Doğa',
        rating: 4.5,
        lat: 38.384,
        lng: 27.039,
        reviews: [],
      ),
      Place(
        name: 'Gölcük Gölü',
        description:
            'Ödemiş ilçesi sınırlarında, çam ormanlarıyla çevrili, dağların arasında gizlenmiş krater gölü.',
        category: 'Doğa',
        rating: 4.7,
        lat: 38.311,
        lng: 28.025,
        reviews: [],
      ),
      Place(
        name: 'Birgi Tarihi Köyü',
        description:
            'Aydınoğulları Beyliği\'nin başkentliğini yapmış, ahşap işlemeli konakları ve tarihi camisiyle ünlü köy.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.257,
        lng: 28.064,
        reviews: [],
      ),
      Place(
        name: 'İnciraltı Kent Ormanı',
        description:
            'Deniz süngerleri, çam ağaçları ve lagünü ile bisiklet sürmek, yürüyüş ve deniz müzesi gezmek için ideal.',
        category: 'Doğa',
        rating: 4.5,
        lat: 38.411,
        lng: 27.027,
        reviews: [],
      ),
      Place(
        name: 'İnciraltı Deniz Müzesi',
        description:
            'Tarihi Ege Fırkateyni ve Pirireis Denizaltısı\'nın sergilendiği, denizin üstündeki askeri müze.',
        category: 'Müze',
        rating: 4.7,
        lat: 38.412,
        lng: 27.035,
        reviews: [],
      ),
      Place(
        name: 'Kızlarağası Hanı',
        description:
            'Kemeraltı içinde fincanda pişen Türk kahvesi, gümüşçüler ve nostaljik avlusuyla meşhur dev Osmanlı hanı.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.417,
        lng: 27.135,
        reviews: [],
      ),
      Place(
        name: 'Homeros Vadisi',
        description:
            'Bornova\'da yer alan, adını mitolojik çağ şairi Homeros\'tan alan doğa içindeki huzurlu yürüyüş vadisi.',
        category: 'Doğa',
        rating: 4.5,
        lat: 38.487,
        lng: 27.240,
        reviews: [],
      ),
      Place(
        name: 'Karagöl Tabiat Parkı',
        description:
            'Menemen dağlarına gizlenmiş, volkanik oluşumlu efsanevi Karagöl ve etrafındaki sisli ormanlar.',
        category: 'Doğa',
        rating: 4.7,
        lat: 38.563,
        lng: 27.218,
        reviews: [],
      ),
      Place(
        name: 'Klazomenai Zeytinyağı İşliği',
        description:
            'Urla\'da dünyada bilinen en eski zeytinyağı işliklerinden biri (M.Ö. 6.yy) olan antik kent kalıntısı.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 38.361,
        lng: 26.765,
        reviews: [],
      ),
      Place(
        name: 'Bademler Köyü Şehir Tiyatrosu',
        description:
            'Urla\'da yer alan, Türkiye\'de kendi tiyatrosuna, oyuncularına ve kütüphanesine sahip ilk ve tek Alevi/Tahtacı köyü.',
        category: 'Gezi',
        rating: 4.9,
        lat: 38.257,
        lng: 26.837,
        reviews: [],
      ),
      Place(
        name: 'Dikili Bademli Koyu ve Kalem Adası',
        description:
            'Maldivleri kıskandıracak su rengine sahip gizli koylar ve lüks konaklama imkanı sunan ada.',
        category: 'Deniz',
        rating: 4.8,
        lat: 39.011,
        lng: 26.822,
        reviews: [],
      ),
      Place(
        name: 'Smyrna Antik Tiyatrosu',
        description:
            'Kadifekale eteklerinde yeni gün yüzüne çıkarılan, 20 bin kişilik devasa Roma amfitiyatrosu.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.414,
        lng: 27.142,
        reviews: [],
      ),
      Place(
        name: 'Bozdağ Kayak Merkezi',
        description:
            'Ödemiş ilçesi sınırlarında, Ege\'nin Uludağ\'ı olarak bilinen yüksek dağ ve kış sporları merkezi.',
        category: 'Doğa',
        rating: 4.4,
        lat: 38.358,
        lng: 28.083,
        reviews: [],
      ),
      Place(
        name: 'Metropolis Antik Kenti',
        description:
            'Torbalı sırtlarında ihtişamıyla duran, "Ana Tanrıça Kenti" olarak bilinen kazı alanı.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 38.163,
        lng: 27.348,
        reviews: [],
      ),
      Place(
        name: 'Çandarlı Kalesi',
        description:
            'Dikili Çandarlı sahiline sıfır restore edilmiş muazzam Ceneviz ve Osmanlı kalesi.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 38.948,
        lng: 26.927,
        reviews: [],
      ),
      Place(
        name: 'Karantina Adası',
        description:
            'Girişinde tarihi Urla Devlet Hastanesi\'nin bulunduğu adaya antik tünelle bağlanmış Osmanlı karantina merkezi.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.374,
        lng: 26.784,
        reviews: [],
      ),
      Place(
        name: 'Tarihi Havagazı Fabrikası',
        description:
            'Alsancak yakınlarında restore edilmiş sanayi mirası. Yazları ücretsiz çim konserleri ve etkinlikleriyle çok popüler.',
        category: 'Gezi',
        rating: 4.6,
        lat: 38.438,
        lng: 27.149,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 36,
    name: 'Kars',
    region: 'Doğu Anadolu',
    lat: 40.60,
    lng: 43.10,
    population: 288000,
    places: [
      Place(
        name: 'Ani Harabeleri',
        description: 'UNESCO - 1001 Kilise Şehri',
        category: 'Tarihi',
        rating: 4.7,
        lat: 40.51,
        lng: 43.57,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 37,
    name: 'Kastamonu',
    region: 'Karadeniz',
    lat: 41.38,
    lng: 33.76,
    population: 383000,
    places: [
      Place(
        name: 'Ilgaz Dağı',
        description: 'Milli park ve kayak merkezi',
        category: 'Doğa',
        rating: 4.3,
        lat: 41.08,
        lng: 33.70,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 38,
    name: 'Kayseri',
    region: 'İç Anadolu',
    lat: 38.73,
    lng: 35.49,
    population: 1421000,
    places: [
      Place(
        name: 'Erciyes Dağı',
        description: 'Kayak ve dağcılık merkezi',
        category: 'Doğa',
        rating: 4.7,
        lat: 38.53,
        lng: 35.45,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 39,
    name: 'Kırklareli',
    region: 'Marmara',
    lat: 41.73,
    lng: 27.22,
    population: 361000,
    places: [
      Place(
        name: 'İğneada Longoz Ormanları',
        description: 'Nadir su basar ormanları',
        category: 'Doğa',
        rating: 4.4,
        lat: 41.88,
        lng: 27.97,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 40,
    name: 'Kırşehir',
    region: 'İç Anadolu',
    lat: 39.14,
    lng: 34.16,
    population: 242000,
    places: [
      Place(
        name: 'Ahi Evran Müzesi',
        description: 'Ahilik kültür merkezi',
        category: 'Müze',
        rating: 4.0,
        lat: 39.14,
        lng: 34.16,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 41,
    name: 'Kocaeli',
    region: 'Marmara',
    lat: 40.76,
    lng: 29.94,
    population: 2033000,
    places: [
      Place(
        name: 'Sapanca Gölü',
        description: 'Marmara\'nın doğa harikası',
        category: 'Doğa',
        rating: 4.5,
        lat: 40.69,
        lng: 30.28,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 42,
    name: 'Konya',
    region: 'İç Anadolu',
    lat: 37.87,
    lng: 32.48,
    population: 2277000,
    places: [
      Place(
        name: 'Mevlana Müzesi',
        description: 'Hz. Mevlana\'nın türbesi',
        category: 'Tarihi',
        rating: 4.8,
        lat: 37.87,
        lng: 32.50,
        reviews: [
          Review(
            user: 'Manevi',
            comment: 'Huzur dolu',
            rating: 5,
            date: '2024-04-10',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 43,
    name: 'Kütahya',
    region: 'Ege',
    lat: 39.42,
    lng: 29.98,
    population: 578000,
    places: [
      Place(
        name: 'Çini Müzesi',
        description: 'Dünyaca ünlü Kütahya çinileri',
        category: 'Müze',
        rating: 4.3,
        lat: 39.42,
        lng: 29.98,
        reviews: [],
      ),
      Place(
        name: 'Aizanoi Antik Kenti',
        description:
            'Çavdarhisar ilçesinde, dünyanın ilk borsasına ve Anadolu\'nun en iyi korunmuş Zeus Tapınağı\'na ev sahipliği yapan "İkinci Efes".',
        category: 'Tarihi',
        rating: 4.9,
        lat: 39.200,
        lng: 29.613,
        reviews: [
          Review(
            user: 'Arkeolog',
            comment:
                'Zeus Tapınağı\'nın bodrum katındaki atmosfer kesinlikle büyüleyici!',
            rating: 5,
            date: '2024-05-12',
          ),
        ],
      ),
      Place(
        name: 'Kütahya Kalesi ve Dönençtepe',
        description:
            'Şehre tamamen hakim bir tepede bulunan, eşsiz panoramik manzarası ve Döner Gazinosu ile ünlü tarihi Bizans/Osmanlı kalesi.',
        category: 'Tarihi',
        rating: 4.6,
        lat: 39.417,
        lng: 29.972,
        reviews: [],
      ),
      Place(
        name: 'Frig Vadisi ve Oymataş Kalıntıları',
        description:
            'Kütahya, Afyon ve Eskişehir üçgenindeki doğa harikası peri bacaları, kaya mezarları ve binlerce yıllık Frig yürüyüş yolu.',
        category: 'Doğa',
        rating: 4.8,
        lat: 39.319,
        lng: 30.298,
        reviews: [],
      ),
      Place(
        name: 'Dumlupınar Meydan Muharebesi Şehitliği',
        description:
            'Kurtuluş Savaşı\'nın kazanıldığı ve Türkiye Cumhuriyeti\'nin temellerinin atıldığı kutsal topraklardaki devasa anıt ve şehitlik.',
        category: 'Tarihi',
        rating: 5.0,
        lat: 38.751,
        lng: 29.973,
        reviews: [],
      ),
      Place(
        name: 'Hayme Ana Türbesi',
        description:
            'Domaniç Çarşamba köyünde bulunan, Ertuğrul Gazi\'nin annesi ve Osmanlı rüya çınarının tohumunu atan "Devlet Ana"nın ebedi istirahatgahı.',
        category: 'Tarihi',
        rating: 4.7,
        lat: 39.805,
        lng: 29.610,
        reviews: [],
      ),
      Place(
        name: 'Murat Dağı Termal Kayak Merkezi',
        description:
            'Gediz ilçesinde, hem termal sıcak suları hem de kayak keyfini aynı anda sunan Türkiye\'deki eşsiz çift konseptli dağ.',
        category: 'Doğa',
        rating: 4.8,
        lat: 38.932,
        lng: 29.623,
        reviews: [],
      ),
      Place(
        name: 'Yoncalı Kaplıcaları',
        description:
            'Anadolu Selçuklu döneminden beri şifa dağıtan, fizik tedavi ve rehabilitasyon merkezleriyle ünlü tarihi termal bölge.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.467,
        lng: 29.835,
        reviews: [],
      ),
      Place(
        name: 'Germiyan Sokağı Tarihi Evleri',
        description:
            'Kütahya merkezde, Osmanlı dönemi sivil mimarisinin en güzel ahşap ve cumbalı ev örneklerinin sıralandığı nostaljik sokak.',
        category: 'Gezi',
        rating: 4.7,
        lat: 39.419,
        lng: 29.982,
        reviews: [],
      ),
      Place(
        name: 'Çinili Cami',
        description:
            'Ressam ve neyzen Ahmet Yakupoğlu tarafından yaptırılan, dış cephesi tamamen eşsiz Kütahya çinileriyle kaplı mimari şaheser.',
        category: 'Tarihi',
        rating: 4.9,
        lat: 39.408,
        lng: 29.991,
        reviews: [],
      ),
      Place(
        name: 'Emet Termal Tatil Köyü',
        description:
            'Dünyaca ünlü yosunlu sularıyla şifa dağıtan, Emet ilçesinin devasa termal turizm kompleksi.',
        category: 'Gezi',
        rating: 4.6,
        lat: 39.340,
        lng: 29.255,
        reviews: [],
      ),
      Place(
        name: 'Gölcük Yaylası',
        description:
            'Simav ilçesi sınırlarında yer alan, dev çam ağaçları ve piknik alanlarıyla çevrili krater gölü kıyısında doğa harikası.',
        category: 'Doğa',
        rating: 4.7,
        lat: 39.141,
        lng: 29.083,
        reviews: [],
      ),
      Place(
        name: 'Zafertepe Çalköy Anıtı',
        description:
            'Başkomutan Meydan Muharebesi\'nin bizzat Atatürk tarafından sevk ve idare edildiği 1181 rakımlı tepedeki "Ordular İlk Hedefiniz Akdeniz\'dir" anıtı.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.868,
        lng: 30.015,
        reviews: [],
      ),
      Place(
        name: 'Yeniköy Peri Bacaları',
        description:
            'Simav Yeniköy\'de jeolojik oluşumlarla rüzgarın şekillendirdiği, Kapadokya\'yı aratmayan saklı kalmış doğal kaya sütunları.',
        category: 'Doğa',
        rating: 4.5,
        lat: 39.123,
        lng: 28.981,
        reviews: [],
      ),
      Place(
        name: 'Evliya Çelebi Kültür Merkezi (Doğduğu Ev)',
        description:
            'Dünyaca ünlü Türk gezgini Evliya Çelebi\'nin doğduğu evin aslına uygun restore edilmiş, kültürel etkinliklere ev sahipliği yapan hali.',
        category: 'Gezi',
        rating: 4.5,
        lat: 39.421,
        lng: 29.979,
        reviews: [],
      ),
      Place(
        name: 'Ilıca Kaplıcaları',
        description:
            'Çam ormanlarının tam ortasında, yüksek mineralli sulara sahip sessiz, huzurlu ve bol oksijenli termal tatil merkezi.',
        category: 'Gezi',
        rating: 4.4,
        lat: 39.521,
        lng: 29.967,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 44,
    name: 'Malatya',
    region: 'Doğu Anadolu',
    lat: 38.35,
    lng: 38.31,
    population: 800000,
    places: [
      Place(
        name: 'Arslantepe Höyüğü',
        description: 'UNESCO - 5000 yıllık yerleşim',
        category: 'Tarihi',
        rating: 4.4,
        lat: 38.38,
        lng: 38.36,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 45,
    name: 'Manisa',
    region: 'Ege',
    lat: 38.61,
    lng: 27.43,
    population: 1450000,
    places: [
      Place(
        name: 'Sardes (Sart) Antik Kenti ve Artemis Tapınağı',
        description:
            'Tarihte paranın ilk icat edildiği Lidya Krallığı\'nın görkemli başkenti; devasa Artemis Tapınağı ve Gymnasium.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.488,
        lng: 28.040,
        reviews: [
          Review(
            user: 'TarihSever',
            comment:
                'Altın akan Paktolos nehrinin kenarında muazzam bir tarih yatıyor.',
            rating: 5,
            date: '2024-11-20',
          ),
        ],
      ),
      Place(
        name: 'Spil Dağı Milli Parkı',
        description:
            'Yılkı atları, endemik Manisa lalesi ve tertemiz havasıyla şehrin sırtını yasladığı devasa doğa harikası.',
        category: 'Doğa',
        rating: 4.7,
        lat: 38.567,
        lng: 27.447,
        reviews: [],
      ),
      Place(
        name: 'Niobe (Ağlayan Kaya)',
        description:
            'Spil Dağı eteklerinde, evlat acısıyla taş kesildiğine inanılan mitolojik Karakaya efsanesi.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.604,
        lng: 27.435,
        reviews: [],
      ),
      Place(
        name: 'Kula Jeoparkı (Kuladokya Peri Bacaları)',
        description:
            'UNESCO tescilli, volkanik patlamalarla oluşmuş Türkiye\'nin en genç volkanik kuşağı ve peri bacaları diyarı.',
        category: 'Doğa',
        rating: 4.8,
        lat: 38.563,
        lng: 28.530,
        reviews: [],
      ),
      Place(
        name: 'Tarihi Kula Evleri ve Sokakları',
        description:
            'Osmanlı sivil mimarisinin en zarif ahşap ve cumbalı örneklerinden oluşan, zamanın durduğu tarihi sokaklar.',
        category: 'Gezi',
        rating: 4.7,
        lat: 38.544,
        lng: 28.649,
        reviews: [],
      ),
      Place(
        name: 'Kurşunlu Kaplıcaları',
        description:
            'Salihli Bozdağ eteklerinde, doğa ile iç içe şifa dağıtan efsanevi sıcak su kaplıcaları ve vadisi.',
        category: 'Doğa',
        rating: 4.6,
        lat: 38.435,
        lng: 28.106,
        reviews: [],
      ),
      Place(
        name: 'Sultan Camii ve Külliyesi',
        description:
            'Hafsa Sultan için yaptırılan ve 500 yıldır her Nevruz\'da şifalı Mesir Macunu saçılan tarihi kompleks.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.614,
        lng: 27.429,
        reviews: [],
      ),
      Place(
        name: 'Muradiye Camii',
        description:
            'Ege Bölgesi\'nde Mimar Sinan\'ın tasarladığı tek cami; medresesi, imareti ve muazzam çinileriyle Şehzadeler\'in kalbi.',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.612,
        lng: 27.427,
        reviews: [],
      ),
      Place(
        name: 'Manisa (Sipil) Kalesi',
        description:
            'Helenistik dönemden Bizans ve Osmanlı\'ya kadar şehri koruyan, Spil dağının eteklerindeki tarihi surlar.',
        category: 'Tarihi',
        rating: 4.4,
        lat: 38.598,
        lng: 27.433,
        reviews: [],
      ),
      Place(
        name: 'Bintepeler (Lidya Kral Mezarları)',
        description:
            'Salihli-Gölmarmara yolu üzerinde, Anadolu\'nun piramitleri sayılan 100\'den fazla devasa kral tümülüsü.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.625,
        lng: 28.021,
        reviews: [],
      ),
      Place(
        name: 'Akhisar (Thyatira) Antik Kenti',
        description:
            'Hristiyanlığın ilk yedi kilisesinden (Apocalypse Vahiy Kiliseleri) birine ev sahipliği yapan tarihi merkez.',
        category: 'Tarihi',
        rating: 4.5,
        lat: 38.924,
        lng: 27.838,
        reviews: [],
      ),
      Place(
        name: 'Alaşehir (Philadelphia) Kiliseleri',
        description:
            'Hristiyanlığın 7 kutsal Asya kilisesinden birini barındıran ("Kardeş Sevgisi" şehri) dev tarihi kalıntılar.',
        category: 'Tarihi',
        rating: 4.4,
        lat: 38.351,
        lng: 28.515,
        reviews: [],
      ),
      Place(
        name: 'Turgutlu Seyirtepe',
        description:
            'Gediz Ovası\'na ve "Kasaba" (Turgutlu) şehir merkezine kuşbakışı bakan, akşamları ışıl ışıl olan tepelik tesisler.',
        category: 'Gezi',
        rating: 4.4,
        lat: 38.487,
        lng: 27.701,
        reviews: [],
      ),
      Place(
        name: 'Yeni Han ve Tarihi Çarşı',
        description:
            'Şehzadeler ilçesinde, yüzlerce yıllık el sanatları ustalarının, bakırcıların ve kuyumcuların bulunduğu tarihi han.',
        category: 'Gezi',
        rating: 4.5,
        lat: 38.615,
        lng: 27.429,
        reviews: [],
      ),
      Place(
        name: 'Urganlı Kaplıcaları',
        description:
            'Gediz Ovası\'nda Turgutlu sınırlarındaki, tarih boyunca krallara şifa olmuş termal sağlık merkezi.',
        category: 'Doğa',
        rating: 4.3,
        lat: 38.508,
        lng: 27.854,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 46,
    name: 'Kahramanmaraş',
    region: 'Akdeniz',
    lat: 37.58,
    lng: 36.93,
    population: 1168000,
    places: [
      Place(
        name: 'Germanicia Mozaik Müzesi',
        description: 'Roma dönemi mozaikleri',
        category: 'Müze',
        rating: 4.4,
        lat: 37.58,
        lng: 36.93,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 47,
    name: 'Mardin',
    region: 'Güneydoğu Anadolu',
    lat: 37.31,
    lng: 40.73,
    population: 862000,
    places: [
      Place(
        name: 'Mardin Taş Evleri',
        description: 'Mezopotamya manzaralı taş evler',
        category: 'Tarihi',
        rating: 4.7,
        lat: 37.31,
        lng: 40.73,
        reviews: [
          Review(
            user: 'Gezgin3',
            comment: 'Masalsı!',
            rating: 5,
            date: '2024-03-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 48,
    name: 'Muğla',
    region: 'Ege',
    lat: 37.21,
    lng: 28.36,
    population: 1020000,
    places: [
      Place(
        name: 'Ölüdeniz',
        description: 'Dünyanın en güzel plajı',
        category: 'Deniz',
        rating: 4.9,
        lat: 36.55,
        lng: 29.12,
        reviews: [
          Review(
            user: 'Deniz',
            comment: 'Cennet!',
            rating: 5,
            date: '2024-07-01',
          ),
        ],
      ),
      Place(
        name: 'Bodrum Kalesi',
        description: 'Tarihi kale ve sualtı müzesi',
        category: 'Tarihi',
        rating: 4.6,
        lat: 37.03,
        lng: 27.43,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 49,
    name: 'Muş',
    region: 'Doğu Anadolu',
    lat: 38.74,
    lng: 41.49,
    population: 411000,
    places: [
      Place(
        name: 'Muş Ovası',
        description: 'Türkiye\'nin en büyük ovası',
        category: 'Doğa',
        rating: 3.8,
        lat: 38.74,
        lng: 41.49,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 50,
    name: 'Nevşehir',
    region: 'İç Anadolu',
    lat: 38.62,
    lng: 34.71,
    population: 303000,
    places: [
      Place(
        name: 'Kapadokya',
        description: 'UNESCO - Peri bacaları ve balon turu',
        category: 'Doğa',
        rating: 4.9,
        lat: 38.64,
        lng: 34.83,
        reviews: [
          Review(
            user: 'Baloncu',
            comment: 'Muhteşem deneyim!',
            rating: 5,
            date: '2024-10-05',
          ),
        ],
      ),
      Place(
        name: 'Derinkuyu Yeraltı Şehri',
        description: '85m derinliğinde antik yeraltı şehri',
        category: 'Tarihi',
        rating: 4.7,
        lat: 38.37,
        lng: 34.73,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 51,
    name: 'Niğde',
    region: 'İç Anadolu',
    lat: 37.97,
    lng: 34.68,
    population: 362000,
    places: [
      Place(
        name: 'Aladağlar',
        description: 'Tırmanış ve kanyoning merkezi',
        category: 'Doğa',
        rating: 4.5,
        lat: 37.77,
        lng: 35.22,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 52,
    name: 'Ordu',
    region: 'Karadeniz',
    lat: 41.0,
    lng: 37.88,
    population: 754000,
    places: [
      Place(
        name: 'Boztepe',
        description: 'Şehir manzaralı tepe',
        category: 'Gezi',
        rating: 4.4,
        lat: 41.0,
        lng: 37.88,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 53,
    name: 'Rize',
    region: 'Karadeniz',
    lat: 41.02,
    lng: 40.52,
    population: 348000,
    places: [
      Place(
        name: 'Ayder Yaylası',
        description: 'Kaçkar Dağları eteklerinde yayla',
        category: 'Doğa',
        rating: 4.7,
        lat: 40.95,
        lng: 41.10,
        reviews: [
          Review(
            user: 'Yaylacı',
            comment: 'Huzur dolu',
            rating: 5,
            date: '2024-08-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 54,
    name: 'Sakarya',
    region: 'Marmara',
    lat: 40.68,
    lng: 30.40,
    population: 1042000,
    places: [
      Place(
        name: 'Sapanca',
        description: 'Göl kenarı tatil merkezi',
        category: 'Doğa',
        rating: 4.4,
        lat: 40.69,
        lng: 30.28,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 55,
    name: 'Samsun',
    region: 'Karadeniz',
    lat: 41.29,
    lng: 36.33,
    population: 1356000,
    places: [
      Place(
        name: 'Bandırma Vapuru Müzesi',
        description: 'Atatürk\'ün Samsun\'a çıkışı',
        category: 'Müze',
        rating: 4.4,
        lat: 41.29,
        lng: 36.33,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 56,
    name: 'Siirt',
    region: 'Güneydoğu Anadolu',
    lat: 37.93,
    lng: 41.94,
    population: 331000,
    places: [
      Place(
        name: 'Botan Vadisi',
        description: 'Rafting ve doğa sporları',
        category: 'Doğa',
        rating: 4.2,
        lat: 37.75,
        lng: 42.05,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 57,
    name: 'Sinop',
    region: 'Karadeniz',
    lat: 42.03,
    lng: 35.15,
    population: 219000,
    places: [
      Place(
        name: 'Sinop Cezaevi',
        description: 'Tarihi cezaevi müzesi',
        category: 'Müze',
        rating: 4.3,
        lat: 42.03,
        lng: 35.15,
        reviews: [],
      ),
      Place(
        name: 'Hamsilos Koyu',
        description: 'Türkiye\'nin fiyort koyu',
        category: 'Doğa',
        rating: 4.6,
        lat: 42.07,
        lng: 34.82,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 58,
    name: 'Sivas',
    region: 'İç Anadolu',
    lat: 39.75,
    lng: 37.01,
    population: 646000,
    places: [
      Place(
        name: 'Divriği Ulu Camii',
        description: 'UNESCO - Taş işçiliği şaheseri',
        category: 'Tarihi',
        rating: 4.6,
        lat: 39.37,
        lng: 38.12,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 59,
    name: 'Tekirdağ',
    region: 'Marmara',
    lat: 41.0,
    lng: 27.51,
    population: 1081000,
    places: [
      Place(
        name: 'Namık Kemal Evi',
        description: 'Ünlü şairin doğduğu ev',
        category: 'Müze',
        rating: 3.9,
        lat: 41.0,
        lng: 27.51,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 60,
    name: 'Tokat',
    region: 'Karadeniz',
    lat: 40.31,
    lng: 36.55,
    population: 612000,
    places: [
      Place(
        name: 'Ballıca Mağarası',
        description: 'Anadolu\'nun en büyük mağarası',
        category: 'Doğa',
        rating: 4.3,
        lat: 40.39,
        lng: 36.60,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 61,
    name: 'Trabzon',
    region: 'Karadeniz',
    lat: 41.0,
    lng: 39.72,
    population: 808000,
    places: [
      Place(
        name: 'Sümela Manastırı',
        description: 'Kayalıklara oyulmuş manastır',
        category: 'Tarihi',
        rating: 4.8,
        lat: 40.68,
        lng: 39.66,
        reviews: [
          Review(
            user: 'Karadeniz',
            comment: 'İnanılmaz!',
            rating: 5,
            date: '2024-07-30',
          ),
        ],
      ),
      Place(
        name: 'Uzungöl',
        description: 'Sis içinde göl manzarası',
        category: 'Doğa',
        rating: 4.6,
        lat: 40.62,
        lng: 40.29,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 62,
    name: 'Tunceli',
    region: 'Doğu Anadolu',
    lat: 39.11,
    lng: 39.55,
    population: 88000,
    places: [
      Place(
        name: 'Munzur Vadisi',
        description: 'Milli park ve doğa harikası',
        category: 'Doğa',
        rating: 4.6,
        lat: 39.20,
        lng: 39.70,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 63,
    name: 'Şanlıurfa',
    region: 'Güneydoğu Anadolu',
    lat: 37.16,
    lng: 38.79,
    population: 2115000,
    places: [
      Place(
        name: 'Göbeklitepe',
        description: 'UNESCO - Dünyanın en eski tapınağı',
        category: 'Tarihi',
        rating: 4.9,
        lat: 37.22,
        lng: 38.92,
        reviews: [
          Review(
            user: 'Tarihçi2',
            comment: '12.000 yıllık tarih!',
            rating: 5,
            date: '2024-04-01',
          ),
        ],
      ),
      Place(
        name: 'Balıklıgöl',
        description: 'Kutsal balıklar gölü',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.16,
        lng: 38.79,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 64,
    name: 'Uşak',
    region: 'Ege',
    lat: 38.68,
    lng: 29.41,
    population: 373000,
    places: [
      Place(
        name: 'Uşak Müzesi',
        description: 'Karun Hazinesi koleksiyonu',
        category: 'Müze',
        rating: 4.2,
        lat: 38.68,
        lng: 29.41,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 65,
    name: 'Van',
    region: 'Doğu Anadolu',
    lat: 38.50,
    lng: 43.38,
    population: 1136000,
    places: [
      Place(
        name: 'Akdamar Adası',
        description: 'Van Gölü üzerinde tarihi kilise',
        category: 'Tarihi',
        rating: 4.8,
        lat: 38.34,
        lng: 43.05,
        reviews: [
          Review(
            user: 'Van',
            comment: 'Efsane manzara',
            rating: 5,
            date: '2024-06-15',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 66,
    name: 'Yozgat',
    region: 'İç Anadolu',
    lat: 39.82,
    lng: 34.80,
    population: 421000,
    places: [
      Place(
        name: 'Çamlık Milli Parkı',
        description: 'Avrupa\'nın ilk milli parkı',
        category: 'Doğa',
        rating: 4.0,
        lat: 39.82,
        lng: 34.80,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 67,
    name: 'Zonguldak',
    region: 'Karadeniz',
    lat: 41.45,
    lng: 31.79,
    population: 596000,
    places: [
      Place(
        name: 'Gökgöl Mağarası',
        description: 'Işıklandırılmış mağara',
        category: 'Doğa',
        rating: 4.1,
        lat: 41.45,
        lng: 31.79,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 68,
    name: 'Aksaray',
    region: 'İç Anadolu',
    lat: 38.37,
    lng: 34.03,
    population: 421000,
    places: [
      Place(
        name: 'Ihlara Vadisi',
        description: '14 km uzunluğunda kanyon',
        category: 'Doğa',
        rating: 4.6,
        lat: 38.25,
        lng: 34.30,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 69,
    name: 'Bayburt',
    region: 'Karadeniz',
    lat: 40.25,
    lng: 40.22,
    population: 84000,
    places: [
      Place(
        name: 'Bayburt Kalesi',
        description: 'Tarihi kale ve manzara',
        category: 'Tarihi',
        rating: 4.0,
        lat: 40.25,
        lng: 40.22,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 70,
    name: 'Karaman',
    region: 'İç Anadolu',
    lat: 37.17,
    lng: 33.23,
    population: 253000,
    places: [
      Place(
        name: 'Manazan Mağaraları',
        description: 'Kaya oyma yerleşim yeri',
        category: 'Tarihi',
        rating: 4.1,
        lat: 37.36,
        lng: 33.38,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 71,
    name: 'Kırıkkale',
    region: 'İç Anadolu',
    lat: 39.85,
    lng: 33.51,
    population: 286000,
    places: [
      Place(
        name: 'Silah Müzesi',
        description: 'MKE Silah Müzesi',
        category: 'Müze',
        rating: 3.9,
        lat: 39.85,
        lng: 33.51,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 72,
    name: 'Batman',
    region: 'Güneydoğu Anadolu',
    lat: 37.88,
    lng: 41.13,
    population: 620000,
    places: [
      Place(
        name: 'Hasankeyf',
        description: 'Tarihi antik kent',
        category: 'Tarihi',
        rating: 4.5,
        lat: 37.71,
        lng: 41.41,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 73,
    name: 'Şırnak',
    region: 'Güneydoğu Anadolu',
    lat: 37.52,
    lng: 42.46,
    population: 542000,
    places: [
      Place(
        name: 'Cudi Dağı',
        description: 'Nuh\'un gemisi efsanesi',
        category: 'Doğa',
        rating: 4.0,
        lat: 37.39,
        lng: 42.58,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 74,
    name: 'Bartın',
    region: 'Karadeniz',
    lat: 41.64,
    lng: 32.33,
    population: 203000,
    places: [
      Place(
        name: 'Amasra',
        description: 'Karadeniz\'in incisi sahil kasabası',
        category: 'Gezi',
        rating: 4.7,
        lat: 41.75,
        lng: 32.39,
        reviews: [
          Review(
            user: 'Sahil',
            comment: 'Muhteşem!',
            rating: 5,
            date: '2024-08-20',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 75,
    name: 'Ardahan',
    region: 'Doğu Anadolu',
    lat: 41.11,
    lng: 42.70,
    population: 98000,
    places: [
      Place(
        name: 'Çıldır Gölü',
        description: 'Kış aylarında donan göl üstünde atlı kızak',
        category: 'Doğa',
        rating: 4.5,
        lat: 41.05,
        lng: 43.26,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 76,
    name: 'Iğdır',
    region: 'Doğu Anadolu',
    lat: 39.92,
    lng: 44.05,
    population: 203000,
    places: [
      Place(
        name: 'Ağrı Dağı Güney Yamacı',
        description: 'Ağrı Dağı manzarası',
        category: 'Doğa',
        rating: 4.3,
        lat: 39.80,
        lng: 44.10,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 77,
    name: 'Yalova',
    region: 'Marmara',
    lat: 40.65,
    lng: 29.27,
    population: 276000,
    places: [
      Place(
        name: 'Termal Kaplıcaları',
        description: 'Şifalı termal sular',
        category: 'Doğa',
        rating: 4.3,
        lat: 40.61,
        lng: 29.18,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 78,
    name: 'Karabük',
    region: 'Karadeniz',
    lat: 41.20,
    lng: 32.62,
    population: 248000,
    places: [
      Place(
        name: 'Safranbolu',
        description: 'UNESCO - Osmanlı evleri şehri',
        category: 'Tarihi',
        rating: 4.8,
        lat: 41.25,
        lng: 32.69,
        reviews: [
          Review(
            user: 'Osmanlı',
            comment: 'Zamanda yolculuk',
            rating: 5,
            date: '2024-05-10',
          ),
        ],
      ),
    ],
  ),
  Province(
    plateCode: 79,
    name: 'Kilis',
    region: 'Güneydoğu Anadolu',
    lat: 36.72,
    lng: 37.12,
    population: 142000,
    places: [
      Place(
        name: 'Ravanda Kalesi',
        description: 'Tarihi kale',
        category: 'Tarihi',
        rating: 3.8,
        lat: 36.72,
        lng: 37.12,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 80,
    name: 'Osmaniye',
    region: 'Akdeniz',
    lat: 37.07,
    lng: 36.25,
    population: 538000,
    places: [
      Place(
        name: 'Kastabala Antik Kenti',
        description: 'Roma dönemi antik kent',
        category: 'Tarihi',
        rating: 4.0,
        lat: 37.18,
        lng: 36.18,
        reviews: [],
      ),
    ],
  ),
  Province(
    plateCode: 81,
    name: 'Düzce',
    region: 'Karadeniz',
    lat: 40.84,
    lng: 31.16,
    population: 392000,
    places: [
      Place(
        name: 'Samandere Şelalesi',
        description: 'Doğa içinde şelale',
        category: 'Doğa',
        rating: 4.3,
        lat: 40.74,
        lng: 31.12,
        reviews: [],
      ),
    ],
  ),
];
