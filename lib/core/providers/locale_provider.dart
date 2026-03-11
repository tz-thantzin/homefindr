import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────
// Supported locales
// ─────────────────────────────────────────────
const List<Locale> kSupportedLocales = [
  Locale('en'),
  Locale('th'),
  Locale('zh'),
  Locale('ja'),
  Locale('my'),
];

const Map<String, Locale> kCodeToLocale = {
  'EN': Locale('en'),
  'TH': Locale('th'),
  'ZH': Locale('zh'),
  'JA': Locale('ja'),
  'MY': Locale('my'),
};

const Map<String, String> kLocaleToCode = {
  'en': 'EN',
  'th': 'TH',
  'zh': 'ZH',
  'ja': 'JA',
  'my': 'MY',
};

// ─────────────────────────────────────────────
// Riverpod provider — watched by MaterialApp
// ─────────────────────────────────────────────
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en'); // default

  void setLocale(Locale locale) => state = locale;

  void setByCode(String code) {
    final locale = kCodeToLocale[code];
    if (locale != null) state = locale;
  }

  String get currentCode => kLocaleToCode[state.languageCode] ?? 'EN';
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);