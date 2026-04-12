import 'package:flashchat/TMart/controller/internet_provider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/no_internet_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BaseScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final List<Widget>? persistentFooterButtons;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.persistentFooterButtons,
    this.backgroundColor,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, provider, _) {
        if (provider.isOnline == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.isOnline == false) {
          return Scaffold(
            body: NoInternetBox(provider),
          );
        }

        return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          drawer: drawer,
          persistentFooterButtons: persistentFooterButtons,
          backgroundColor: backgroundColor,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );
  }
}
