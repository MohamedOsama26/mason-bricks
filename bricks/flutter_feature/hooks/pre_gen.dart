
import 'package:mason/mason.dart';

String toSnake(String s) => s
    .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m.group(1)}_${m.group(2)}')
    .replaceAll(RegExp(r'\s+'), '_')
    .toLowerCase();

String toCamel(String s) {
  final p = toSnake(s).split('_');
  return [p.first, ...p.skip(1).map((w) => w[0].toUpperCase() + w.substring(1))].join();
}

String toPascal(String s) =>
    toSnake(s).split('_').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join();

void run(HookContext context) {
  final logger = context.logger;
  final modelsCsv = (context.vars['models_csv'] as String? ?? '').trim();
  if (modelsCsv.isEmpty) {
    logger.err('You must provide at least one model in PascalCase (e.g., Booking,BookingDetails).');
    throw const FormatException('models_csv empty');
  }
  final paginationCsv = (context.vars['pagination_models_csv'] as String? ?? '').trim();

  final modelNames = modelsCsv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  final paginationSet = paginationCsv.isEmpty
      ? <String>{}
      : paginationCsv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

  final models = modelNames.map((name) {
    final pascal = toPascal(name);
    final snake = toSnake(name);
    final camel = toCamel(name);
    final hasPagination = paginationSet.contains(name) || paginationSet.contains(pascal) || paginationSet.contains(snake);
    return {
      'raw': name,
      'pascal': pascal,
      'snake': snake,
      'camel': camel,
      'hasPagination': hasPagination,
    };
  }).toList();

  context.vars = {
    ...context.vars,
    'models': models,
  };

  logger.info('Models: ${models.map((m) => m['pascal']).join(', ')}');
  final withPg = models.where((m) => m['hasPagination'] == true).map((m) => m['pascal']).toList();
  if (withPg.isNotEmpty) {
    logger.info('Pagination wrappers for: ${withPg.join(', ')}');
  }
}
