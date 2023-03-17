import 'package:flutter/cupertino.dart';

/// A helper for building web browser bottom dialogs.
class BasicBrowserBottomDialog extends StatefulWidget {
  final bool isOpen;
  final List<Widget> children;

  const BasicBrowserBottomDialog({
    super.key,
    required this.isOpen,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return _BasicBrowserBottomDialogState();
  }
}

class _BasicBrowserBottomDialogState extends State<BasicBrowserBottomDialog> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: widget.isOpen ? null : 0,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}
