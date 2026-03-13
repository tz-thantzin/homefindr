import '../../domain/models/property.dart';


/// List of 5 high-quality real estate images for Hero Section
final List<String> heroBgImages = [
  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80',
];

/// Generates a list of 500 mock properties for the Homez app.
final List<Property> mockProperties = List.generate(500, (index) {
  final cities = [
    "Yangon",
    "Mandalay",
    "Naypyidaw",
    "Bago",
    "Taunggyi",
    "Mawlamyine",
    "Pathein",
    "Pyay",
    "Magway",
    "Monywa",
    "Sagaing",
    "Meiktila",
    "Myitkyina",
    "Lashio",
    "Hpa-An",
    "Dawei",
    "Myeik",
    "Sittwe",
    "Thandwe (Ngapali)",
    "Loikaw",
    "Kalaw",
    "Pyin Oo Lwin",
    "Thanlyin",
    "Hinthada",
    "Pakokku",
    "Kyaukpyu",
  ];

  final neighborhoods = [
    // Yangon
    "Downtown Yangon",
    "Sanchaung",
    "Bahan",
    "Yankin",
    "Hlaing",
    "Kamaryut",
    "Mayangone",
    "Insein",
    "Ahlone",
    "Kyimyindaing",
    "Thingangyun",
    "South Okkalapa",
    "North Okkalapa",
    "Tamwe",
    "Thaketa",
    "Dagon Myothit",
    "Dagon Seikkan",
    "Hlaing Tharyar",
    "Shwe Pyi Thar",
    "Mingaladon",
    "Dawbon",
    "Lanmadaw",
    "Latha",
    "Pabedan",
    "Botataung",
    "Pazundaung",
    "Thanlyin",
    "Dala",

    // Mandalay
    "Chanayethazan",
    "Chanmyathazi",
    "Aungmyethazan",
    "Maha Aungmye",
    "Amarapura",
    "Pyigyitagon",
    "Patheingyi",

    // Naypyidaw
    "Zabuthiri",
    "Ottara Thiri",
    "Dekkhina Thiri",
    "Pobbathiri",
    "Tatkon",
    "Pyinmana",

    // Taunggyi / Shan
    "Taunggyi Downtown",
    "Aye Tharyar",
    "Kalaw",
    "Nyaung Shwe (Inle)",
    "Hopong",
    "Lashio Downtown",

    // Mawlamyine / Mon
    "Mawlamyine Downtown",
    "Chaungzon",
    "Mudon",
    "Thanbyuzayat",

    // Bago
    "Bago Downtown",
    "Pyay Downtown",
    "Nyaunglebin",

    // Pathein / Ayeyarwady
    "Pathein Downtown",
    "Hinthada",
    "Maubin",
    "Bogale",

    // Magway / Central
    "Magway Downtown",
    "Pakokku",
    "Minbu",
    "Yenangyaung",

    // Monywa / Sagaing
    "Monywa Downtown",
    "Sagaing City",
    "Shwebo",

    // Kayin / Kayah
    "Hpa-An Downtown",
    "Loikaw Downtown",

    // Tanintharyi
    "Dawei Downtown",
    "Myeik Downtown",
    "Kawthaung",

    // Rakhine
    "Sittwe Downtown",
    "Thandwe (Ngapali Beach)",
    "Kyaukpyu",

    // Kachin
    "Myitkyina Downtown",
    "Bhamo",
  ];

  // Assign PropertyType enum based on rotation
  final typeEnum = PropertyType.values[index % PropertyType.values.length];

  final city = cities[index % cities.length];
  final neighborhood = neighborhoods[index % neighborhoods.length];

  // Status Logic: 30% For Rent, 60% For Sale, 10% Sold
  String status = "For Sale";
  if (index % 10 < 3) {
    status = "For Rent";
  } else if (index % 10 == 9) {
    status = "Sold";
  }

  // Price Logic: Rent is monthly, Sale is total
  final basePrice = status == "For Rent" ? 1800 : 350000;
  final calculatedPrice = basePrice + (index * (status == "For Rent" ? 25 : 1500));

  // Format price with commas for the UI
  final formattedPrice = status == "For Rent"
      ? "\$${_formatNumber(calculatedPrice)}/month"
      : "\$${_formatNumber(calculatedPrice)}";

  return Property(
    id: 'prop_${index + 1}',
    title: '${_capitalize(typeEnum.name)} in $neighborhood',
    location: '$neighborhood, $city, USA',
    price: formattedPrice,
    status: status,
    type: typeEnum,
    beds: (index % 4) + 1,
    baths: (index % 3) + 1,
    sqft: 850 + (index * 12),
    imageUrl: _getImageUrl(index),
    createdAt: DateTime.now().subtract(Duration(days: index, hours: index % 24)),
    isFeatured: index < 12, // First 12 are marked as featured
  );
});

/// Helper to format numbers with commas (e.g., 1,200,000)
String _formatNumber(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  );
}

/// Helper to capitalize enum names for titles
String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

/// Rotating high-quality architectural images
String _getImageUrl(int index) {
  final images = [
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600570997533-f14d7a120083?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600607687940-4e5a99427ae5?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1572120360610-d971b9b78825?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1571939228382-b2f2b585ce15?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1516455590571-18256e5bb9ff?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1599423300746-b62533397364?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600585154154-712bd0b15c6b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?auto=format&fit=crop&w=1200&q=80',
  ];

  return images[index % images.length];
}