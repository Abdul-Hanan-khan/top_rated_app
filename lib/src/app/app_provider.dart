import 'package:flutter/material.dart';

import 'app_bloc.dart';

export 'app_bloc.dart';

class AppProvider extends InheritedWidget {
  AppProvider({Key key, this.child}) : super(key: key, child: child);

  final AppBloc bloc = AppBloc.instance;
  // final AppBloc bloc = AppBloc();
  final Widget child;

  static AppBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AppProvider>()).bloc;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return true;
  }
}
