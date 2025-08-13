import 'dart:io';
import 'package:mason/mason.dart';

void main(HookContext context) async {
  final log = context.logger;
  final feature = (context.vars['feature_name'] as String).trim();
  final includeLocal = (context.vars['include_local'] as bool?) ?? true;
  final includeRemote = (context.vars['include_remote'] as bool?) ?? true;
  final includeBloc = (context.vars['include_bloc'] as bool?) ?? true;

  String p(List<String> parts) => parts.join(Platform.pathSeparator);

  final localDS = p(['lib','features',feature,'data','datasources','${feature}_local_data_source.dart']);
  final remoteDS = p(['lib','features',feature,'data','datasources','${feature}_remote_data_source.dart']);
  final blocFile = p(['lib','features',feature,'presentation','bloc','${feature}_bloc.dart']);
  final blocDir  = p(['lib','features',feature,'presentation','bloc']);

  void removeIfExists(String path) {
    final f = File(path);
    if (f.existsSync()) {
      f.deleteSync();
      log.info('Removed $path');
    }
  }

  void removeDirIfEmpty(String path) {
    final d = Directory(path);
    if (d.existsSync() && d.listSync().isEmpty) {
      d.deleteSync();
      log.info('Removed empty dir $path');
    }
  }

  if (!includeLocal) removeIfExists(localDS);
  if (!includeRemote) removeIfExists(remoteDS);
  if (!includeBloc) {
    removeIfExists(blocFile);
    removeDirIfEmpty(blocDir);
  }

  log.info('post_gen cleanup complete.');
}
