import 'package:flutter/foundation.dart';

class TankCache extends ChangeNotifier {
  static final TankCache _instance = TankCache._internal();
  factory TankCache() => _instance;
  TankCache._internal();

  String? tankName;
  int? tankCapacity;
  int? tankHeight;
  bool? isAutoModeOn; // <-- Added

  bool get hasData => tankName != null && tankCapacity != null && tankHeight != null;

  void update({String? name, int? capacity, int? height, bool? autoMode}) {
    bool changed = false;
    
    if (name != null && name != tankName) { tankName = name; changed = true; }
    if (capacity != null && capacity != tankCapacity) { tankCapacity = capacity; changed = true; }
    if (height != null && height != tankHeight) { tankHeight = height; changed = true; }
    if (autoMode != null && autoMode != isAutoModeOn) { isAutoModeOn = autoMode; changed = true; } // <-- Added
    
    if (changed) notifyListeners();
  }
}