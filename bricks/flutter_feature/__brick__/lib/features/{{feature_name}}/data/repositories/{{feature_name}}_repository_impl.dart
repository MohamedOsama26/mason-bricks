import '../../domain/repositories/{{feature_name}}_repository.dart';
{{#include_remote}}import '../datasources/{{feature_name}}_remote_data_source.dart';{{/include_remote}}
{{#include_local}}import '../datasources/{{feature_name}}_local_data_source.dart';{{/include_local}}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl implements {{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {
  {{#include_remote}}final {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource remote;{{/include_remote}}
  {{#include_local}}final {{#pascalCase}}{{feature_name}}{{/pascalCase}}LocalDataSource local;{{/include_local}}

  {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl({
    {{#include_remote}}required this.remote,{{/include_remote}}
    {{#include_local}}required this.local,{{/include_local}}
  });
}
