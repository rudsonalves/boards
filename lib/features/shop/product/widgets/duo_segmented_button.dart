import 'package:flutter/material.dart';

class DuoSegmentedButton extends StatelessWidget {
  final String label1;
  final String label2;
  final IconData iconData1;
  final IconData iconData2;
  final void Function() callBack1;
  final void Function() callBack2;
  final bool hideButton1;

  const DuoSegmentedButton({
    super.key,
    required this.label1,
    required this.label2,
    required this.iconData1,
    required this.iconData2,
    required this.callBack1,
    required this.callBack2,
    this.hideButton1 = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScreme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SegmentedButton<int>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    colorScreme.primaryContainer.withOpacity(0.85)),
              ),
              segments: [
                if (!hideButton1)
                  ButtonSegment(
                    value: 1,
                    icon: Icon(iconData1),
                    label: Text(label1),
                  ),
                ButtonSegment(
                  value: 2,
                  icon: Icon(iconData2),
                  label: Text(label2),
                ),
              ],
              multiSelectionEnabled: true,
              showSelectedIcon: false,
              selected: const {1, 2},
              onSelectionChanged: (value) {
                if (!value.contains(1)) {
                  callBack1();
                } else if (!value.contains(2)) {
                  callBack2();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
