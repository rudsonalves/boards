import 'package:flutter/material.dart';

class CustomNamesFormField extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextEditingController controller;
  final List<String> names;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final FocusNode? nextFocusNode;
  final bool fullBorder;
  final int? maxLines;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? errorText;

  const CustomNamesFormField({
    super.key,
    this.labelText,
    this.labelStyle,
    this.hintText,
    required this.controller,
    required this.names,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.nextFocusNode,
    this.fullBorder = true,
    this.maxLines = 1,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.readOnly = false,
    this.suffixIcon,
    this.errorText,
    this.textCapitalization,
  });

  @override
  State<CustomNamesFormField> createState() => _CustomNamesFormFieldState();
}

class _CustomNamesFormFieldState extends State<CustomNamesFormField> {
  final errorString = ValueNotifier<String?>(null);
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
        if (widget.onSubmitted != null) widget.onSubmitted!(_controller.text);
      }
    });

    _controller.addListener(() {
      _updateSuggestions();
      _showOverlay();
    });
  }

  @override
  void dispose() {
    errorString.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSuggestions() {
    final query = _controller.text.toLowerCase();
    if (query.length < 2) {
      _suggestions.clear();
      _removeOverlay();
      return;
    }
    setState(() {
      _suggestions = widget.names
          .where((game) => game.toLowerCase().contains(query))
          .take(10)
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onTap(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    _removeOverlay();
    _focusNode.nextFocus();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    final colorScheme = Theme.of(context).colorScheme;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 240,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () => _onTap(_suggestions[index]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: _controller,
          validator: widget.validator,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: widget.labelStyle,
            hintText: widget.hintText,
            errorText: widget.errorText,
            suffixIcon: widget.suffixIcon,
            border: widget.fullBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            floatingLabelBehavior: widget.floatingLabelBehavior,
          ),
          onChanged: widget.onChanged,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(value);
            }
          },
        ),
      ),
    );
  }
}
