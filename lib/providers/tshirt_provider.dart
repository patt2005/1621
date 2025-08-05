import 'package:flutter/material.dart';
import '../models/tshirt_models.dart';

class TShirtProvider extends ChangeNotifier {
  TShirtDesign _currentDesign = TShirtDesign();
  String _currentView = 'Front'; // 'Front' or 'Back'
  Color _selectedColor = Colors.white;

  TShirtDesign get currentDesign => _currentDesign;
  String get currentView => _currentView;
  Color get selectedColor => _selectedColor;

  List<TShirtElement> get currentElements {
    return _currentView == 'Front'
        ? _currentDesign.frontElements
        : _currentDesign.backElements;
  }

  void setCurrentView(String view) {
    _currentView = view;
    notifyListeners();
  }

  void addElement(TShirtElement element) {
    if (_currentView == 'Front') {
      _currentDesign.frontElements.add(element);
    } else {
      _currentDesign.backElements.add(element);
    }
    notifyListeners();
  }

  void removeElement(TShirtElement element) {
    if (_currentView == 'Front') {
      _currentDesign.frontElements.remove(element);
    } else {
      _currentDesign.backElements.remove(element);
    }
    notifyListeners();
  }

  void updateElement(int index, TShirtElement element) {
    if (_currentView == 'Front' &&
        index < _currentDesign.frontElements.length) {
      _currentDesign.frontElements[index] = element;
    } else if (_currentView == 'Back' &&
        index < _currentDesign.backElements.length) {
      _currentDesign.backElements[index] = element;
    }
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void moveElement(int oldIndex, int newIndex) {
    List<TShirtElement> elements =
        _currentView == 'Front'
            ? _currentDesign.frontElements
            : _currentDesign.backElements;

    if (oldIndex < elements.length && newIndex < elements.length) {
      final element = elements.removeAt(oldIndex);
      elements.insert(newIndex, element);
      notifyListeners();
    }
  }

  void updateElementPosition(TShirtElement element, double x, double y) {
    element.x = x;
    element.y = y;
    notifyListeners();
  }

  void updateElementSize(TShirtElement element, double width, double height) {
    element.width = width;
    element.height = height;
    notifyListeners();
  }

  void setTShirtColor(Color color) {
    _currentDesign.tshirtColor = color;
    notifyListeners();
  }

  void setDesignName(String name) {
    _currentDesign.designName = name;
    notifyListeners();
  }

  void newDesign() {
    _currentDesign = TShirtDesign();
    _currentView = 'Front';
    notifyListeners();
  }

  void loadDesign(TShirtDesign design) {
    _currentDesign = design;
    _currentView = 'Front';
    notifyListeners();
  }

  Map<String, dynamic> saveDesign() {
    return _currentDesign.toJson();
  }

  void clearCurrentView() {
    if (_currentView == 'Front') {
      _currentDesign.frontElements.clear();
    } else {
      _currentDesign.backElements.clear();
    }
    notifyListeners();
  }

  int get frontElementCount => _currentDesign.frontElements.length;
  int get backElementCount => _currentDesign.backElements.length;

  List<TShirtElement> get frontElements => _currentDesign.frontElements;
  List<TShirtElement> get backElements => _currentDesign.backElements;
}
