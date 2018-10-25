import 'package:flutter/material.dart';

class SettingController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  SettingState state = SettingState.closed;

  SettingController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = SettingState.opening;
            break;
          case AnimationStatus.reverse:
            state = SettingState.closing;
            break;
          case AnimationStatus.completed:
            state = SettingState.open;
            break;
          case AnimationStatus.dismissed:
            state = SettingState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == SettingState.open) {
      close();
    } else if (state == SettingState.closed) {
      open();
    }
  }
}

enum SettingState {
  closed,
  opening,
  open,
  closing,
}