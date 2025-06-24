import 'package:flutter/material.dart';

class ExpandedView2Row extends StatelessWidget {
  final int flex1, flex2;
  final Widget child1, child2;
  final bool isCentered;
  const ExpandedView2Row({
    super.key,
    required this.flex1,
    required this.flex2,
    required this.child1,
    required this.child2,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isCentered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Expanded(flex: flex1, child: child1),
        Expanded(flex: flex2, child: child2),
      ],
    );
  }
}

class ExpandedView3Row extends StatelessWidget {
  final int flex1, flex2, flex3;
  final Widget child1, child2, child3;
  const ExpandedView3Row({
    super.key,
    required this.flex1,
    required this.flex2,
    required this.flex3,
    required this.child1,
    required this.child2,
    required this.child3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: flex1, child: child1),
        Expanded(flex: flex2, child: child2),
        Expanded(flex: flex3, child: child3),
      ],
    );
  }
}
