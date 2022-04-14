import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/graph/country_service.dart';
import 'country_states.dart';
import 'country_events.dart';

class CountryBloc extends Bloc<CountryEvent, CountryStates> {
  final CountryService countryService;
  CountryBloc({required this.countryService}) : super(Initial()) {
    on<LoadCountries>((event, emit) async {
      final response =
          await countryService.getCountries(continentCode: event.continentCode);
      Map<String, bool> tLanguages = {};
      if (response.operationException == null) {
        response.data?.forEach((element) {
          if ((element.native?.isNotEmpty ?? false) &&
              tLanguages.containsKey(element.native) == false) {
            tLanguages[element.native!] = true;
          }
        });
        emit(LoadedCountries(countries: response.data!, languages: tLanguages));
      } else {
        emit(FailedToLoadCountries(message: 'Failed to fetch countries'));
      }
    });

    on<ReloadCountries>((event, emit) async {
      emit(LoadingCountries());
      await Future.delayed(const Duration(seconds: 1));
      emit(LoadedCountries(
          countries: event.countries,
          languages: event.languages,
          searchText: event.searchText));
    });
  }
}
