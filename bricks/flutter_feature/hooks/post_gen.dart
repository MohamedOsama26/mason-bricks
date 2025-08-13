// No mason import needed
import 'dart:io';

// Accept a dynamic context so we don't depend on package:mason
void run(dynamic context) async {
  final log = context.logger; // still available at runtime

  // Read vars safely
  final vars = Map<String, dynamic>.from(context.vars as Map);
  final feature = (vars['feature_name'] as String).trim();
  final includeLocal  = (vars['include_local']  as bool?) ?? true;
  final includeRemote = (vars['include_remote'] as bool?) ?? true;
  final includeBloc   = (vars['include_bloc']   as bool?) ?? true;

  String p(List<String> parts) => parts.join(Platform.pathSeparator);

  final localDS = p(['lib','features',feature,'data','datasources','${feature}_local_data_source.dart']);
  final remoteDS = p(['lib','features',feature,'data','datasources','${feature}_remote_data_source.dart']);
  final blocFile = p(['lib','features',feature,'presentation','bloc','${feature}_bloc.dart']);
  final blocDir  = p(['lib','features',feature,'presentation','bloc']);

  void removeIfExists(String path) {
    try {
      final f = File(path);
      if (f.existsSync()) {
        f.deleteSync();
        log.info('Removed $path');
      }
    } catch (_) {}
  }

  void removeDirIfEmpty(String path) {
    try {
      final d = Directory(path);
      if (d.existsSync() && d.listSync().isEmpty) {
        d.deleteSync();
        log.info('Removed empty dir $path');
      }
    } catch (_) {}
  }

  if (!includeLocal)  removeIfExists(localDS);
  if (!includeRemote) removeIfExists(remoteDS);
  if (!includeBloc) {
    removeIfExists(blocFile);
    removeDirIfEmpty(blocDir);
  }

  log.info('post_gen cleanup complete.');
}