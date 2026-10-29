
import 'package:flutter/foundation.dart';

class AdminViewModel extends ChangeNotifier {
  AdminViewModel();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
}
