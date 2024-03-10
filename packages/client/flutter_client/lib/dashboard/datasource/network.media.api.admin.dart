import 'package:cvworld/config.dart';

class NetworkMediaApiAdmin {
  static String publicResource(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }

    return '${ApplicationConfiguration.apiUrl}/server/media/$path';
  }
}
