import '../../models/continent_model.dart';

abstract class ContinentState {}

class Initial extends ContinentState {}

class LoadingContinents extends ContinentState {}

class LoadedContinents extends ContinentState {
  final List<ContinentModel> continents;
  LoadedContinents({required this.continents});
}

class FailedToLoadContinents extends ContinentState {
  final String message;
  FailedToLoadContinents({required this.message});
}
