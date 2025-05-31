import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget portraitLayout;
  final Widget landscapeLayout;

  const ResponsiveScaffold({
    super.key,
    required this.portraitLayout,
    required this.landscapeLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(body: portraitLayout);
        } else {
          return Scaffold(body: landscapeLayout);
        }
      },
    );
  }
}
