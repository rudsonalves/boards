import 'dart:async';

import 'package:flutter/material.dart';

import '../form_controllers/numeric_edit_controller.dart';

class SpinBoxField<T extends num> extends StatefulWidget {
  final T? value;
  final Widget? label;
  final TextStyle? style;
  final String? hintText;
  final TextEditingController controller;
  final int flex;
  final T minValue;
  final T maxValue;
  final T increment;
  final InputDecoration? decoration;
  final int fractionDigits;
  final void Function(T)? onChange;

  const SpinBoxField({
    super.key,
    this.value,
    this.label,
    this.style,
    this.hintText,
    required this.controller,
    this.onChange,
    this.flex = 1,
    T? minValue,
    T? maxValue,
    T? increment,
    this.decoration,
    this.fractionDigits = 0,
  })  : minValue = minValue ?? (T == int ? 0 as T : 0.0 as T),
        maxValue = maxValue ?? (T == int ? 10 as T : 10.0 as T),
        increment = increment ?? (T == int ? 1 as T : 1.0 as T);

  @override
  State<SpinBoxField> createState() => _SpinBoxFieldState<T>();
}

class _SpinBoxFieldState<T extends num> extends State<SpinBoxField<T>> {
  late T value;
  Timer? _incrementTimer;
  Timer? _decrementTimer;
  bool _isLongPressActive = false;
  bool _internalChange = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller is NumericEditController) {
      value = (widget.controller as NumericEditController).numericValue as T;
      if (value == 0 && widget.value != null && widget.value != 0) {
        value = widget.value as T;
        (widget.controller as NumericEditController<T>).numericValue = value;
      }
    } else {
      value = widget.value ?? widget.minValue;
      widget.controller.text = value.toStringAsFixed(widget.fractionDigits);
    }

    widget.controller.addListener(() {
      if (_internalChange) return;
      final parseValue = _parseValue(widget.controller.text);
      if (parseValue != null) {
        value = parseValue;
        _changeText(value);
      }
    });
  }

  T? _parseValue(String text) {
    if (T == int) {
      return int.tryParse(text) as T?;
    } else if (T == double) {
      return double.tryParse(text) as T?;
    }
    return null;
  }

  void _longIncrement() {
    _incrementTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (value < widget.maxValue) {
          _increment();
        } else {
          _incrementTimer?.cancel();
        }
      },
    );
  }

  void _longDecrement() {
    _decrementTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (value > widget.minValue) {
          _decrement();
        } else {
          _decrementTimer?.cancel();
        }
      },
    );
  }

  void _stopIncrement() {
    _incrementTimer?.cancel();
  }

  void _stopDecrement() {
    _decrementTimer?.cancel();
  }

  void _updateOnChange() {
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  void _increment() {
    if (value < widget.maxValue) {
      value = (value + widget.increment) as T;
      value = value > widget.maxValue ? widget.maxValue : value;
      _changeText(value);
      _updateOnChange();
    }
  }

  void _decrement() {
    if (value > widget.minValue) {
      value = (value - widget.increment) as T;
      value = value < widget.minValue ? widget.minValue : value;
      _changeText(value);
      _updateOnChange();
    }
  }

  void _changeText(T value) {
    _internalChange = true;
    widget.controller.text = value.toStringAsFixed(widget.fractionDigits);
    _internalChange = false;
  }

  void _onLongPressIncrement() {
    _isLongPressActive = true;
    _longIncrement();
  }

  void _onLongPressDecrement() {
    _isLongPressActive = true;
    _longDecrement();
  }

  void _onLongPressEndIncrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stopIncrement();
  }

  void _onLongPressEndDecrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stopDecrement();
  }

  void _onTapDecrement() {
    if (!_isLongPressActive) {
      _decrement();
    }
  }

  void _onTapIncrement() {
    if (!_isLongPressActive) {
      _increment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.label != null) widget.label!,
          GestureDetector(
            onLongPress: _onLongPressDecrement,
            onLongPressEnd: _onLongPressEndDecrement,
            child: InkWell(
              onTap: _onTapDecrement,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ),
          ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                return Text(
                  widget.controller.text.trim(),
                  textAlign: TextAlign.center,
                );
              }),
          GestureDetector(
            onLongPress: _onLongPressIncrement,
            onLongPressEnd: _onLongPressEndIncrement,
            child: InkWell(
              onTap: _onTapIncrement,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
