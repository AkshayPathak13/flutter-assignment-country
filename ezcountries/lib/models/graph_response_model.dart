import 'package:graphql/client.dart';

class GraphResponse<T> {
  final T? data;
  final OperationException? operationException;
  GraphResponse({this.data, this.operationException});
}
