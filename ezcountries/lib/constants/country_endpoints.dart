const continentsEndpoint = r'''
query continentsEndpoint {
  continents {
    code
    name
  }
}
''';

const countriesFromContinent = r'''
query countriesFromContinent($code: ID!) {
  continent(code: $code) {
    countries {
      code 
      currency
      emoji 
      name 
      native 
      phone 
    }
  }
}
''';
