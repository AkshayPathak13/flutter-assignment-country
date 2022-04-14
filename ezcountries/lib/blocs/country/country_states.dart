import '../../models/country_model.dart';

abstract class CountryStates {}

class Initial extends CountryStates {}

class LoadingCountries extends CountryStates {}

class LoadedCountries extends CountryStates {
  final List<CountryModel> countries;
  final Map<String, bool> languages;
  final String searchText;
  LoadedCountries(
      {required this.countries, required this.languages, this.searchText = ''});
}

class FailedToLoadCountries extends CountryStates {
  final String message;
  FailedToLoadCountries({required this.message});
}
