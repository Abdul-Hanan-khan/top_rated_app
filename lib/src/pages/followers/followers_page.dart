import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/pages/followers/followers_bloc.dart';
import 'package:top_rated_app/src/pages/other_profile/OtherProfilePage.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/extensions/string_extension.dart';

class FollowersPage extends StatefulWidget {
  final bool isFollowers;

  FollowersPage({this.isFollowers = true});

  @override
  _FollowersPageState createState() => new _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  ThemeData theme;
  BuildContext _context;
  FollowersBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = new FollowersBloc(widget.isFollowers);
    bloc.error.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error".tr(), event);
    });
    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error".tr(), event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: _buildAppBar(context),
      body: Builder(
        builder: (context) {
          _context = context;
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.isFollowers ? "Followers".tr() : "Following".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<User>>(
        stream: bloc.followers,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.all(Dimens.margin_medium),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data[index];
                    return InkWell(
                      onTap: () async {
                        await pushPage(
                            context,
                            OtherProfilePage(
                              userId: user.id,
                              name: user.fullName,
                            ));
                        bloc.fetchData();
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.margin),
                          child: Text(
                            "${user.fullName.capitalized()}".tr(),
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                      ),
                    );
                  },
                );
        });
  }
}
