import 'package:ezcountries/services/graph/country_service.dart';

class Singleton {
  Singleton._privateConstructor();
  static final Singleton _instance = Singleton._privateConstructor();
  static Singleton get instance => _instance;
  static final CountryService _countryService =
      CountryService(apiLink: 'https://countries.trevorblades.com/graphql');
  static CountryService get countryService => _countryService;
}
