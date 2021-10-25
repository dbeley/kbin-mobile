import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbin_mobile/providers/filters_provider.dart';
import 'package:kbin_mobile/providers/settings_provider.dart';
import 'package:kbin_mobile/routes/router.gr.dart';
import 'package:provider/provider.dart';

class NavBarMiddle extends StatefulWidget {
  final String? title;
  final String? magazine;
  final double? fontSize;
  final PageRouteInfo? route;
  final Type? provider;

  const NavBarMiddle(
      {Key? key,
      this.title,
      this.magazine,
      this.fontSize,
      this.route,
      this.provider})
      : super(key: key);

  @override
  _NavBarMiddleState createState() => _NavBarMiddleState();
}

class _NavBarMiddleState extends State<NavBarMiddle> {
  late SettingsProvider _settings;

  @override
  void initState() {
    super.initState();

    _settings = Provider.of<SettingsProvider>(context, listen: false);
    _settings.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FiltersProvider>(builder: (context, filters, child) {
      return CupertinoButton(
        onPressed: () => showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Anuluj'),
            ),
            title: const Text('Jakie magazyny wyświetlić?'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: Text(
                    filters.screenView ?? widget.magazine ?? 'Losowy magazyn',
                    style: TextStyle(
                        fontWeight: filters.screenView != null
                            ? FontWeight.bold
                            : FontWeight.normal)),
                onPressed: () {
                  if (widget.magazine != null) {
                    filters.setScreenView(widget.magazine!);
                  }

                  context.router.popUntilRoot();
                  context.router.push(SceneRoute(route: widget.route ?? const EntriesRoute()));
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Wszystkie',
                    style: TextStyle(
                        fontWeight: filters.screenView == null
                            ? FontWeight.bold
                            : FontWeight.normal)),
                onPressed: () {
                  filters.clearScreenView();

                  context.router.popUntilRoot();
                  context.router.push(SceneRoute(route: widget.route ?? const EntriesRoute()));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Subskrybowane'),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                child: const Text('Moderowane'),
                onPressed: () {},
              ),
            ],
          ),
        ),
        child: Text(
          widget.title ?? filters.screenView ?? widget.magazine ?? _settings.instance ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize ?? 25,
              color: Colors.black),
        ),
      );
    });
  }
}
