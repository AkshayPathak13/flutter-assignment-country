import 'package:ezcountries/constants/country_endpoints.dart';
import 'package:graphql/client.dart';

class CountryApi {
  final GraphQLClient _graphQLClient;
  const CountryApi({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;
  Future<QueryResult<Object?>> getCountries(
      {required String continentCode}) async {
    QueryResult<Object?> queryResult = await _graphQLClient.query(QueryOptions(
        document: gql(countriesFromContinent),
        variables: {'code': continentCode}));
    return queryResult;
  }

  Future<QueryResult<Object?>> getContinents() async {
    QueryResult<Object?> queryResult = await _graphQLClient
        .query(QueryOptions(document: gql(continentsEndpoint)));
    return queryResult;
  }
}
