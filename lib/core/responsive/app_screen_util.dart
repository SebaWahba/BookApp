import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rotation-safe ScreenUtil setup.
///
/// A fixed portrait designSize breaks on rotation — a landscape screen
/// compared against a portrait frame inflates every .w/.h/.sp value by
/// ~2.27x. The fix: rotate the reference frame with orientation, and cap
/// the scale factor (~1.15x) by inflating the effective design size.
/// Past that cap, layout structure (ResponsiveBuilder/LayoutBuilder)
/// should change instead of continuing to scale a phone design up.
class AppScreenUtil extends StatelessWidget {
  const AppScreenUtil({
    super.key,
    required this.child,
    this.portraitDesignSize = const Size(375, 812),
    this.maxScaleFactor = 1.15,
  });

  final Widget child;
  final Size portraitDesignSize;
  final double maxScaleFactor;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isLandscape = screenSize.width > screenSize.height;

    final baseDesignSize = isLandscape
        ? Size(portraitDesignSize.height, portraitDesignSize.width)
        : portraitDesignSize;

    final minDesignWidth = screenSize.width / maxScaleFactor;
    final minDesignHeight = screenSize.height / maxScaleFactor;

    final effectiveDesignSize = Size(
      baseDesignSize.width < minDesignWidth
          ? minDesignWidth
          : baseDesignSize.width,
      baseDesignSize.height < minDesignHeight
          ? minDesignHeight
          : baseDesignSize.height,
    );

    return ScreenUtilInit(
      designSize: effectiveDesignSize,
      minTextAdapt: true,
      builder: (_, _) => child,
    );
  }
}
