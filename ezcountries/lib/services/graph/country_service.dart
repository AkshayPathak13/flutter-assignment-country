import '../../apis/graph/country_api.dart';
import 'package:graphql/client.dart';

import '../../models/continent_model.dart';
import '../../models/country_model.dart';
import '../../models/graph_response_model.dart';

class CountryService {
  late CountryApi _countryApi;
  CountryService({required String apiLink}) {
    Link link = HttpLink(apiLink);
    GraphQLClient graphQLClient =
        GraphQLClient(link: link, cache: GraphQLCache());
    _countryApi = CountryApi(graphQLClient: graphQLClient);
  }
  Future<GraphResponse<List<CountryModel>>> getCountries(
      {required String continentCode}) async {
    final result = await _countryApi.getCountries(continentCode: continentCode);
    if (result.hasException) {
      return GraphResponse(operationException: result.exception);
    } else {
      Map? graphData = result.data?['continent'];
      List<CountryModel> countries = [];
      if (graphData != null && graphData.containsKey('countries')) {
        List? elements = graphData['countries'];
        elements?.forEach((element) {
          CountryModel continentModel = CountryModel.fromJson(element);
          countries.add(continentModel);
        });
      }
      return GraphResponse(data: countries);
    }
  }

  Future<GraphResponse<List<ContinentModel>>> getContinents() async {
    final result = await _countryApi.getContinents();
    if (result.hasException) {
      return GraphResponse(operationException: result.exception);
    } else {
      Map? graphData = result.data;
      List<ContinentModel> continents = [];
      if (graphData != null) {
        List? elements = graphData['continents'];
        elements?.forEach((element) {
          ContinentModel continentModel = ContinentModel.fromJson(element);
          continents.add(continentModel);
        });
      }
      return GraphResponse(data: continents);
    }
  }
}
