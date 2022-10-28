import 'dart:async';
import 'package:flutter/material.dart';
import 'vouchain_localizations.dart';

class VouchainLocalizationsDelegate
    extends LocalizationsDelegate<VouchainLocalizations> {
  const VouchainLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['it', 'en'].contains(locale.languageCode);

  @override
  Future<VouchainLocalizations> load(Locale locale) =>
      VouchainLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<VouchainLocalizations> old) => false;
}
