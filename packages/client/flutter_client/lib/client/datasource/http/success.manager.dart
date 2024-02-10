import 'package:rxdart/rxdart.dart';

class SuccessManager {
  static SuccessManager? _instance;
  late final Subject<String> _message;

  // Private constructor
  SuccessManager._() {
    _message = PublishSubject<String>();
  }

  // Singleton instance getter
  static SuccessManager getInstance() {
    _instance ??= SuccessManager._();
    return _instance!;
  }

  // Observable getter
  Stream<String> get observable => _message.stream;

  // Dispatch method
  void dispatch(String message) {
    _message.add(message);
  }

  // Dispose method
  void dispose() {
    _message.close();
  }
}
