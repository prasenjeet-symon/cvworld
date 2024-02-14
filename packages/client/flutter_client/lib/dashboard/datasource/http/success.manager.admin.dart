import 'package:rxdart/rxdart.dart';

class SuccessManager {
  static SuccessManager? _instance;
  final Subject<String> _message = PublishSubject<String>();

  SuccessManager._();

  static SuccessManager getInstance() {
    _instance ??= SuccessManager._();
    return _instance!;
  }

  Stream<String> get observable => _message.stream;

  void dispatch(String message) {
    _message.add(message);
  }

  void dispose() {
    _message.close();
  }
}
