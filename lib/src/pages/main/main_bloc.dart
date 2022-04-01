import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';

class MainBloc extends BaseBloc {
  MainBloc() {
    AppBloc.instance.uploadDeviceToken();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
