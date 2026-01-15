import 'package:flutter_riverpod/legacy.dart';

final billingCycleProvider = StateProvider<bool>((ref) => false); // false = monthly, true = yearly
