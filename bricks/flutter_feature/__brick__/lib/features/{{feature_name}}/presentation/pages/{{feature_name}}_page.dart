import 'package:flutter/material.dart';
{{#include_bloc}}import '../bloc/{{feature_name}}_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';{{/include_bloc}}
import '../widgets/{{feature_name}}_view.dart';

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Page extends StatelessWidget {
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    {{#include_bloc}}
    return BlocProvider(
      create: (_) => {{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc()..add(Load{{#pascalCase}}{{feature_name}}{{/pascalCase}}()),
      child: const {{#pascalCase}}{{feature_name}}{{/pascalCase}}View(),
    );
    {{/include_bloc}}
    {{^include_bloc}}
    return const {{#pascalCase}}{{feature_name}}{{/pascalCase}}View();
    {{/include_bloc}}
  }
}
