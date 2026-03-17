import 'package:flutter/material.dart';

class ModernRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> slivers;
  final ScrollPhysics? physics;

  const ModernRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.slivers,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white,
      color: Theme.of(context).primaryColor,
      elevation: 0,
      strokeWidth: 2.5,
      displacement: 40,
      child: CustomScrollView(physics: physics, slivers: slivers),
    );
  }
}

class ModernRefreshIndicatorList extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? emptyWidget;
  final ScrollPhysics? physics;
  final EdgeInsets padding;
  final IndexedWidgetBuilder? separatorBuilder;
  final double? itemExtent;

  const ModernRefreshIndicatorList({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyWidget,
    this.physics,
    this.padding = EdgeInsets.zero,
    this.separatorBuilder,
    this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white,
      color: primary,
      elevation: 0,
      strokeWidth: 2.5,
      displacement: 40,
      child: itemCount == 0 && emptyWidget != null
          ? ListView(
              physics:
                  physics ??
                  const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
              children: [emptyWidget!],
            )
          : separatorBuilder != null
          ? ListView.separated(
              physics:
                  physics ??
                  const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
              padding: padding,
              itemCount: itemCount,
              separatorBuilder: separatorBuilder!,
              itemBuilder: itemBuilder,
            )
          : ListView.builder(
              physics:
                  physics ??
                  const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
              padding: padding,
              itemCount: itemCount,
              itemExtent: itemExtent,
              itemBuilder: itemBuilder,
            ),
    );
  }
}
