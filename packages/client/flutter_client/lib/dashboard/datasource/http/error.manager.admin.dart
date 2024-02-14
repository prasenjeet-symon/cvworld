import 'package:rxdart/rxdart.dart';

class ErrorManager {
  static ErrorManager? _instance;
  final Subject<String> _errorMessage = PublishSubject<String>();

  // Private constructor
  ErrorManager._();

  // Singleton instance getter
  static ErrorManager getInstance() {
    _instance ??= ErrorManager._();
    return _instance!;
  }

  // Observable getter
  Stream<String> get observable => _errorMessage.stream;

  // Dispatch method
  void dispatch(String error) {
    _errorMessage.add(error);
  }

  // Dispose method
  void dispose() {
    _errorMessage.close();
  }
}
