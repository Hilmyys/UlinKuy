import '../models/cafe_model.dart';

class CafeRepository {
  static final List<Cafe> _cafes = [
    Cafe(
      id: '1',
      name: 'Seroja Bake & Coffee',
      location: 'Jl. Cikutra No.164, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1511081692775-05d0f180a065?auto=format&fit=crop&q=80&w=800',
      rating: 4.9,
      reviewsCount: 1200,
      priceRange: r'$$',
      wifiSpeed: 85,
      crowdLevel: 0.65,
      tasteRating: '9.5/10',
      tags: ['PASTRY', 'COZY', 'WORK-FRIENDLY'],
      facilities: ['Musholla Bersih', 'Parkir Luas', 'Stopkontak Tiap Meja', 'Area Terbuka'],
      specialMenus: [
        MenuDetail(
          name: 'Pavlova Buah Musiman',
          price: '35k',
          imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&q=80&w=400',
          description: 'Meringue renyah dengan krim lembut and topping buah lokal segar.',
        ),
        MenuDetail(
          name: 'Kopi Susu Seroja',
          price: '28k',
          imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi susu gula aren khas Seroja dengan aroma rempah tipis.',
        ),
      ],
      reviews: [
        ReviewDetail(
          userName: 'Rizky Ramadhan',
          userAvatar: 'https://i.pravatar.cc/150?u=rizky',
          rating: 5.0,
          comment: 'Pastry-nya juara di Bandung! Pavlova-nya wajib coba banget.',
          date: '2 weeks ago',
        ),
      ],
      operatingHours: '08:00 - 22:00',
    ),
    Cafe(
      id: '2',
      name: 'Lacamera Coffee',
      location: 'Jl. Naripan No.99, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=800',
      rating: 4.8,
      reviewsCount: 850,
      priceRange: r'$$',
      wifiSpeed: 60,
      crowdLevel: 0.40,
      tasteRating: '9.0/10',
      tags: ['HUGE VIBE', 'AESTHETIC', 'LEGENDARY'],
      facilities: ['WiFi Kencang', 'Indoor & Outdoor', 'Live Music'],
      specialMenus: [
        MenuDetail(
          name: 'Choco Avocado Coffee',
          price: '42k',
          imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&q=80&w=400',
          description: 'Perpaduan alpukat segar, cokelat premium, dan espresso.',
        ),
        MenuDetail(
          name: 'Waffle Classic',
          price: '38k',
          imageUrl: 'https://images.unsplash.com/photo-1513530534585-c7b1394c6d51?auto=format&fit=crop&q=80&w=400',
          description: 'Waffle renyah dengan topping es krim vanilla.',
        ),
      ],
      reviews: [],
      operatingHours: '09:00 - 21:00',
    ),
    Cafe(
      id: '3',
      name: 'Blue Doors',
      location: 'Jl. Alkateri No.2, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1445116572660-236099ec97a0?auto=format&fit=crop&q=80&w=800',
      rating: 4.7,
      reviewsCount: 920,
      priceRange: r'$$$',
      wifiSpeed: 50,
      crowdLevel: 0.80,
      tasteRating: '8.8/10',
      tags: ['BEST VIBE', 'LEGENDARY', 'SPECIALTY'],
      facilities: ['Quiet Sanctuary', 'Premium Coffee', 'No Smoking Area'],
      specialMenus: [
        MenuDetail(
          name: 'Magic',
          price: '40k',
          imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&q=80&w=400',
          description: 'Double ristretto dengan susu hangat, rasa kopi lebih bold.',
        ),
        MenuDetail(
          name: 'Manual Brew V60',
          price: '45k',
          imageUrl: 'https://images.unsplash.com/photo-1544787210-282713df82ef?auto=format&fit=crop&q=80&w=400',
          description: 'Biji kopi pilihan dari roastery lokal terbaik.',
        ),
      ],
      reviews: [],
      operatingHours: '07:00 - 20:00',
    ),
    Cafe(
      id: '4',
      name: 'Kopi Toko Djawa',
      location: 'Jl. Braga No.81, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1461023233037-2440c0e735fe?auto=format&fit=crop&q=80&w=800',
      rating: 4.6,
      reviewsCount: 2100,
      priceRange: r'$',
      wifiSpeed: 40,
      crowdLevel: 0.95,
      tasteRating: '9.2/10',
      tags: ['LEGENDARY', 'VINTAGE', 'BRAGA'],
      facilities: ['Braga Atmosphere', 'Quick Serve', 'Vintage Decor'],
      specialMenus: [
        MenuDetail(
          name: 'Es Kopi Awan',
          price: '24k',
          imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&q=80&w=400',
          description: 'Es kopi susu gula aren dengan foam lembut di atasnya.',
        ),
        MenuDetail(
          name: 'Donat Kampung',
          price: '10k',
          imageUrl: 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&q=80&w=400',
          description: 'Donat kentang klasik dengan taburan gula halus.',
        ),
      ],
      reviews: [],
      operatingHours: '08:00 - 22:00',
    ),
    Cafe(
      id: '5',
      name: 'Mimiti Coffee & Space',
      location: 'Jl. Sumur Bandung No.14, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1521017432531-fbd92d744264?auto=format&fit=crop&q=80&w=800',
      rating: 4.5,
      reviewsCount: 740,
      priceRange: r'$$$',
      wifiSpeed: 70,
      crowdLevel: 0.30,
      tasteRating: '8.5/10',
      tags: ['SOCIAL SPOT', 'OUTDOOR', 'AESTHETIC'],
      facilities: ['Spacious Outdoor', 'Modern Design', 'Pet Friendly'],
      specialMenus: [
        MenuDetail(
          name: 'Flat White',
          price: '38k',
          imageUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&q=80&w=400',
          description: 'Keseimbangan sempurna antara espresso and micro-foam.',
        ),
        MenuDetail(
          name: 'Iced Matcha Latte',
          price: '40k',
          imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&q=80&w=400',
          description: 'Matcha Jepang premium dengan susu segar.',
        ),
      ],
      reviews: [],
      operatingHours: '08:00 - 21:00',
    ),
    Cafe(
      id: '6',
      name: 'Armor Kopi',
      location: 'Jl. Bukit Pakar Utara No.10, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&q=80&w=800',
      rating: 4.4,
      reviewsCount: 1800,
      priceRange: r'$',
      wifiSpeed: 45,
      crowdLevel: 0.85,
      tasteRating: '8.0/10',
      tags: ['NATURE', 'DAGO', 'PINE FOREST'],
      facilities: ['Open Air', 'Garden View', 'Parking Area'],
      specialMenus: [
        MenuDetail(
          name: 'Kopi Tubruk Robusta',
          price: '15k',
          imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi hitam klasik dengan sensasi hutan pinus.',
        ),
        MenuDetail(
          name: 'Pisang Goreng Keju',
          price: '20k',
          imageUrl: 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&q=80&w=400',
          description: 'Pisang goreng hangat dengan limpahan keju parut.',
        ),
      ],
      reviews: [],
      operatingHours: '09:00 - 21:00',
    ),
    Cafe(
      id: '7',
      name: 'Sydwic',
      location: 'Jl. Cilaki No.63, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec41b5ec?auto=format&fit=crop&q=80&w=800',
      rating: 4.6,
      reviewsCount: 620,
      priceRange: r'$$',
      wifiSpeed: 75,
      crowdLevel: 0.55,
      tasteRating: '8.9/10',
      tags: ['MINIMALIST', 'SCANDINAVIAN', 'AESTHETIC'],
      facilities: ['Cozy Indoor', 'Clean Toilet', 'Fast WiFi'],
      specialMenus: [
        MenuDetail(
          name: 'Sydwic Iced Coffee',
          price: '32k',
          imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi susu spesial dengan racikan rahasia Sydwic.',
        ),
        MenuDetail(
          name: 'Chicken Nanban',
          price: '45k',
          imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&q=80&w=400',
          description: 'Ayam goreng juicy dengan saus tartar homemade.',
        ),
      ],
      reviews: [],
      operatingHours: '10:00 - 22:00',
    ),
    Cafe(
      id: '8',
      name: 'Two Cents',
      location: 'Jl. Lombok No.28a, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=800',
      rating: 4.7,
      reviewsCount: 1400,
      priceRange: r'$$',
      wifiSpeed: 80,
      crowdLevel: 0.70,
      tasteRating: '9.3/10',
      tags: ['ROASTERY', 'BRUNCH', 'SPECIALTY'],
      facilities: ['Indoor AC', 'Smoking Area', 'Great Coffee Beans'],
      specialMenus: [
        MenuDetail(
          name: 'Orange Honey Latte',
          price: '38k',
          imageUrl: 'https://images.unsplash.com/photo-1534778101976-62847782c213?auto=format&fit=crop&q=80&w=400',
          description: 'Latte dengan sentuhan kesegaran jeruk and madu.',
        ),
        MenuDetail(
          name: 'Eggs Benedict',
          price: '55k',
          imageUrl: 'https://images.unsplash.com/photo-1608039755401-742074f0548d?auto=format&fit=crop&q=80&w=400',
          description: 'Menu sarapan mewah dengan telur poached sempurna.',
        ),
      ],
      reviews: [],
      operatingHours: '07:00 - 21:00',
    ),
    Cafe(
      id: '9',
      name: 'Wiki Koffie',
      location: 'Jl. Braga No.90, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&q=80&w=800',
      rating: 4.5,
      reviewsCount: 3200,
      priceRange: r'$',
      wifiSpeed: 50,
      crowdLevel: 0.90,
      tasteRating: '8.4/10',
      tags: ['HERITAGE', 'LEGENDARY', 'BUDGET'],
      facilities: ['Historic Building', 'Open View Braga', 'Smoking Area'],
      specialMenus: [
        MenuDetail(
          name: 'Thai Tea Iced',
          price: '18k',
          imageUrl: 'https://images.unsplash.com/photo-1594631252845-29fc458695d7?auto=format&fit=crop&q=80&w=400',
          description: 'Teh Thailand otentik dengan susu kental manis.',
        ),
        MenuDetail(
          name: 'Banana Pancake',
          price: '22k',
          imageUrl: 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&q=80&w=400',
          description: 'Pancake lembut dengan irisan pisang and sirup maple.',
        ),
      ],
      reviews: [],
      operatingHours: '08:00 - 00:00',
    ),
    Cafe(
      id: '10',
      name: 'Kopi Kenangan Heritage',
      location: 'Jl. Asia Afrika No.150, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&q=80&w=800',
      rating: 4.6,
      reviewsCount: 500,
      priceRange: r'$$',
      wifiSpeed: 90,
      crowdLevel: 0.60,
      tasteRating: '8.7/10',
      tags: ['HERITAGE', 'LUXURY', 'QUICK'],
      facilities: ['Art Deco Interior', 'Charging Station', 'Air Conditioning'],
      specialMenus: [
        MenuDetail(
          name: 'Kopi Kenangan Mantan Heritage',
          price: '32k',
          imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&q=80&w=400',
          description: 'Versi premium dari menu andalan dengan biji kopi pilihan.',
        ),
        MenuDetail(
          name: 'Sultan Croissant',
          price: '35k',
          imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&q=80&w=400',
          description: 'Croissant mentega yang sangat renyah and gurih.',
        ),
      ],
      reviews: [],
      operatingHours: '08:00 - 22:00',
    ),
    Cafe(
      id: '11',
      name: 'Sejiwa Coffee',
      location: 'Jl. Progo No.15, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec41b5ec?auto=format&fit=crop&q=80&w=800',
      rating: 4.8,
      reviewsCount: 2800,
      priceRange: r'$$',
      wifiSpeed: 85,
      crowdLevel: 0.80,
      tasteRating: '9.4/10',
      tags: ['FAMOUS', 'INDUSTRIAL', 'PREMIUM'],
      facilities: ['Modern Interior', 'Barista Show', 'Indoor & Outdoor'],
      specialMenus: [
        MenuDetail(
          name: 'Es Kopi Jiwa',
          price: '35k',
          imageUrl: 'https://images.unsplash.com/photo-1461023233037-2440c0e735fe?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi susu khas Sejiwa dengan gula aren kualitas terbaik.',
        ),
        MenuDetail(
          name: 'Truffle Fries',
          price: '48k',
          imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&q=80&w=400',
          description: 'Kentang goreng dengan aroma truffle yang mewah.',
        ),
      ],
      reviews: [],
      operatingHours: '07:00 - 23:00',
    ),
    Cafe(
      id: '12',
      name: 'Kopi Nako',
      location: 'Jl. Pahlawan No.42, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1521017432531-fbd92d744264?auto=format&fit=crop&q=80&w=800',
      rating: 4.5,
      reviewsCount: 1200,
      priceRange: r'$',
      wifiSpeed: 65,
      crowdLevel: 0.85,
      tasteRating: '8.6/10',
      tags: ['GLASS HOUSE', 'INSTAGRAMMABLE', 'OUTDOOR'],
      facilities: ['Unique Architecture', 'Large Parking', 'Prayer Room'],
      specialMenus: [
        MenuDetail(
          name: 'Es Kopi Sayang',
          price: '23k',
          imageUrl: 'https://images.unsplash.com/photo-1551046779-bc45aff622f8?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi susu dengan madu alami yang menyegarkan.',
        ),
        MenuDetail(
          name: 'Nasi Jinggo Nako',
          price: '20k',
          imageUrl: 'https://images.unsplash.com/photo-1512058560366-cd242d4ba351?auto=format&fit=crop&q=80&w=400',
          description: 'Nasi bungkus khas Bali versi Kopi Nako.',
        ),
      ],
      reviews: [],
      operatingHours: '08:00 - 22:00',
    ),
    Cafe(
      id: '13',
      name: 'The Hallway Space',
      location: 'Pasar Kosambi, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&q=80&w=800',
      rating: 4.7,
      reviewsCount: 450,
      priceRange: r'$',
      wifiSpeed: 60,
      crowdLevel: 0.70,
      tasteRating: '9.0/10',
      tags: ['CREATIVE HUB', 'HIDDEN GEMS', 'UNDERGROUND'],
      facilities: ['Creative Shops', 'Community Space', 'Urban Vibe'],
      specialMenus: [
        MenuDetail(
          name: 'Manual Brew Gayo',
          price: '28k',
          imageUrl: 'https://images.unsplash.com/photo-1544787210-282713df82ef?auto=format&fit=crop&q=80&w=400',
          description: 'Kopi Aceh Gayo dengan profil rasa fruity.',
        ),
        MenuDetail(
          name: 'Gyoza Mentai',
          price: '30k',
          imageUrl: 'https://images.unsplash.com/photo-1541696440987-21cc1db60127?auto=format&fit=crop&q=80&w=400',
          description: 'Gyoza ayam dengan saus mentai yang creamy.',
        ),
      ],
      reviews: [],
      operatingHours: '12:00 - 21:00',
    ),
    Cafe(
      id: '14',
      name: 'Mercusuar Cafe & Resto',
      location: 'Jl. Lembah Pakar Timur No.7, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1445116572660-236099ec97a0?auto=format&fit=crop&q=80&w=800',
      rating: 4.4,
      reviewsCount: 5200,
      priceRange: r'$$$',
      wifiSpeed: 50,
      crowdLevel: 0.95,
      tasteRating: '8.2/10',
      tags: ['CASTLE', 'TOURIST SPOT', 'DAGO'],
      facilities: ['Castle View', 'Photography Spots', 'Family Friendly'],
      specialMenus: [
        MenuDetail(
          name: 'Blue Ocean Drink',
          price: '45k',
          imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&q=80&w=400',
          description: 'Minuman segar berwarna biru dengan rasa jeruk citrus.',
        ),
        MenuDetail(
          name: 'Pizza Margherita',
          price: '85k',
          imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbad80ad50?auto=format&fit=crop&q=80&w=400',
          description: 'Pizza tipis renyah dengan saus tomat and keju mozzarella.',
        ),
      ],
      reviews: [],
      operatingHours: '09:00 - 21:00',
    ),
    Cafe(
      id: '15',
      name: 'Sun Date Moon',
      location: 'Jl. Prof. Dr. Sutami No.89, Bandung',
      imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec41b5ec?auto=format&fit=crop&q=80&w=800',
      rating: 4.7,
      reviewsCount: 800,
      priceRange: r'$$',
      wifiSpeed: 80,
      crowdLevel: 0.65,
      tasteRating: '9.1/10',
      tags: ['BEACH VIBE', 'AESTHETIC', 'COCKTAIL'],
      facilities: ['Outdoor Beach Decor', 'Unique Photo Spots', 'AC Indoor'],
      specialMenus: [
        MenuDetail(
          name: 'Summer Breeze',
          price: '40k',
          imageUrl: 'https://images.unsplash.com/photo-1536935338218-841273c1f08d?auto=format&fit=crop&q=80&w=400',
          description: 'Perpaduan buah tropis yang menyegarkan dahaga.',
        ),
        MenuDetail(
          name: 'Nasi Goreng Sun Date',
          price: '55k',
          imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&q=80&w=400',
          description: 'Nasi goreng bumbu spesial dengan sate ayam.',
        ),
      ],
      reviews: [],
      operatingHours: '11:00 - 23:00',
    ),
  ];

  static List<Cafe> getMockCafes() => List.unmodifiable(_cafes);

  static void addCafe(Cafe cafe) {
    _cafes.add(cafe);
  }

  static void updateCafe(Cafe updatedCafe) {
    final index = _cafes.indexWhere((c) => c.id == updatedCafe.id);
    if (index != -1) {
      _cafes[index] = updatedCafe;
    }
  }

  static void deleteCafe(String id) {
    _cafes.removeWhere((c) => c.id == id);
  }

  static List<Cafe> searchCafes(String query) {
    final all = getMockCafes();
    if (query.isEmpty) return all;
    return all.where((c) => 
      c.name.toLowerCase().contains(query.toLowerCase()) || 
      c.location.toLowerCase().contains(query.toLowerCase()) ||
      c.tags.any((t) => t.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  static List<Cafe> filterByTag(String tag) {
    final all = getMockCafes();
    return all.where((c) => c.tags.contains(tag)).toList();
  }
}
