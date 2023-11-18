import 'package:flutter/material.dart';

enum CardStatus { like, disLike, supeLike }

class CardProvider extends ChangeNotifier {
  CardProvider() {
    reserImages();
  }
  List<String> _urlImages = [];

  String? url;

  List<String> get urlImages => _urlImages;

  Offset _position = Offset.zero;
  bool isDragging = false;

  Offset get posiiton => _position;
  Size _screenSize = Size.zero;
  double _angle = 0;
  double get angle => _angle;

  reserImages() {
    _urlImages = <String>[
      'https://plus.unsplash.com/premium_photo-1668383210938-0183489b5f8a?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://plus.unsplash.com/premium_photo-1663045746070-119bcb8d5a7d?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://plus.unsplash.com/premium_photo-1664302868051-9e3c7f6a9c96?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://plus.unsplash.com/premium_photo-1674461536809-67c9ffbb6523?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ].reversed.toList();
    notifyListeners();
  }

  Size setScreenSize(screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    isDragging = true;
    notifyListeners();
  }

  endPosition(DragEndDetails details) {
    isDragging = false;
    final status = getStatus();

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.disLike:
        dislike();
        break;

      case CardStatus.supeLike:
        // superLike();
        break;
      default:
        resetPosition();
        break;
    }
  }

  like() {
    _angle = 20;

    _position += Offset(2 * _screenSize.width, 0);

    _nextCard();
    notifyListeners();
  }

  dislike() {
    _angle = 20;

    _position += Offset(-2 * _screenSize.width, 0);

    _nextCard();
    notifyListeners();
  }

  superLike() {
    _angle = 0;

    _position += Offset(0, -_screenSize.height);

    _nextCard();
    notifyListeners();
  }

  rewind() {
    if (url != null) {
      _urlImages.add(url!);
      url = null;
      notifyListeners();
    }
  }

  _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    if (_urlImages.isNotEmpty) {
      url = _urlImages[_urlImages.length - 1];
      print('url ====>>>$url');
    }

    _urlImages.removeLast();

    resetPosition();
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += Offset(details.delta.dx, 0);
    final x = _position.dx;

    _angle = 20 * x / _screenSize.width;
    notifyListeners();
  }

  void resetPosition() {
    _position = Offset.zero;
    _angle = 0;
    isDragging = false;

    notifyListeners();
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    final delta = 180;
    final forceSuperLike = x < 20;

    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.disLike;
    } else if (y <= -delta / 2 && forceSuperLike) {
      return CardStatus.supeLike;
    }
  }
}
