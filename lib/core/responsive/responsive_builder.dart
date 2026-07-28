import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

/// page level layout decision, based on MediaQuery (the whole screen's
/// width) , use this when a screen's SHAPE needs to change on a bigger
/// display , not just when something needs to scale up.
///
/// widget-level decisions (how much space THIS widget was actually given
/// by its parent) belong in LayoutBuilder, not here.
/// LayoutBuilder for widgets , MediaQuery for pages .
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= AppBreakpoints.tablet) {
      return (desktop ?? tablet ?? mobile)(context);
    }
    if (width >= AppBreakpoints.mobile) {
      return (tablet ?? mobile)(context);
    }
    return mobile(context);
  }
}