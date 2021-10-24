import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbin_mobile/models/post_collection_model.dart';
import 'package:kbin_mobile/providers/posts_provider.dart';
import 'package:kbin_mobile/providers/settings_provider.dart';
import 'package:kbin_mobile/routes/router.gr.dart';
import 'package:kbin_mobile/widgets/loading_full.dart';
import 'package:kbin_mobile/widgets/nav_bar_leading.dart';
import 'package:kbin_mobile/widgets/nav_bar_middle.dart';
import 'package:kbin_mobile/widgets/post.dart';
import 'package:kbin_mobile/widgets/sort_options.dart';
import 'package:kbin_mobile/widgets/time_options.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late ScrollController _controller;
  late SettingsProvider settings;
  late PostsProvider posts;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    settings = Provider.of<SettingsProvider>(context, listen: false);
    settings.fetch();

    posts = Provider.of<PostsProvider>(context, listen: false);
    posts.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: const FittedBox(child: NavBarMiddle(route: PostsRoute())),
          leading: buildNavBarLeading(context),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              timeOptions(context, posts),
              sortOptions(context, posts)
            ],
          )),
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: buildPostList(context),
    );
  }

  Widget buildPostList(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, state, child) {
        if (!state.loading) {
          if (state.posts.isNotEmpty) {
            return CupertinoScrollbar(
              controller: _controller,
              isAlwaysShown: false,
              child: ListView.builder(
                  controller: _controller,
                  itemCount: state.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostCollectionItem post = state.posts[index];
                    return buildItem(context, post, index);
                  }),
            );
          } else {
            return Material(
              type: MaterialType.transparency,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  child: const Text('brak wpisów')),
            );
          }
        }

        return buildLoadingFull();
      },
    );
  }
}
