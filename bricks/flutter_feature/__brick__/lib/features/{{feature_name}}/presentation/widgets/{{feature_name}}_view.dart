import 'package:flutter/material.dart';

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}View extends StatelessWidget {
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('{{#titleCase}}{{feature_name}}{{/titleCase}}'));
  }
}
