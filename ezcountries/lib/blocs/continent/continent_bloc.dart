import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/graph/country_service.dart';
import 'continent_states.dart';
import 'continent_events.dart';

class ContinentBloc extends Bloc<ContinentEvent, ContinentState> {
  final CountryService countryService;
  ContinentBloc({required this.countryService}) : super(Initial()) {
    on<LoadContinents>((event, emit) async {
      emit(LoadingContinents());
      await Future.delayed(Duration.zero);
      final response = await countryService.getContinents();
      if (response.operationException == null) {
        emit(LoadedContinents(continents: response.data!));
      } else {
        emit(FailedToLoadContinents(message: 'Failed to fetch countries'));
      }
    });
  }
}
