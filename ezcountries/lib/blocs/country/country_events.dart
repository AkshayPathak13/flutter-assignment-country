import '../../models/country_model.dart';

abstract class CountryEvent {}

class LoadCountries extends CountryEvent {
  final String continentCode;
  LoadCountries({required this.continentCode});
}

class ReloadCountries extends CountryEvent {
  final List<CountryModel> countries;
  final Map<String, bool> languages;
  final String searchText;
  ReloadCountries(
      {required this.countries,
      required this.languages,
      required this.searchText});
}
