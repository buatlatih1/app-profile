import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'app_footer.dart';
import 'app_navbar.dart';

class PortalShell extends StatefulWidget {
  final Widget child;

  const PortalShell({super.key, required this.child});

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppNavbar(scaffoldKey: _scaffoldKey),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.child,
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

