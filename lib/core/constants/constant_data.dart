import '../../domain/models/property.dart';

// List of 5 high-quality real estate images
final List<String> heroBgImages = [
  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=1920&q=80',
  'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80',
];


/// Generates a list of 500 mock properties for the Homez app.
final List<Property> mockProperties = List.generate(500, (index) {
  // Deterministic random-like variables based on index
  // final isEven = index % 2 == 0;
  final cityIndex = index % 5;
  final neighborhoodIndex = index % 5;

  final cities = ["New York", "Los Angeles", "Chicago", "Miami", "Austin"];
  final neighborhoods = ["Manhattan", "Beverly Hills", "Lincoln Park", "South Beach", "Downtown"];
  final propertyTypes = ["Modern Apartment", "Luxury Villa", "Cozy Studio", "Penthouse", "Family Home"];

  final city = cities[cityIndex];
  final neighborhood = neighborhoods[neighborhoodIndex];
  final type = propertyTypes[index % propertyTypes.length];

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
    title: '$type in $neighborhood',
    location: '$neighborhood, $city, USA',
    price: formattedPrice,
    status: status,
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
  ];
  return images[index % images.length];
}
