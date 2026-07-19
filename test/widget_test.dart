import 'package:flutter_test/flutter_test.dart';
import 'package:bookapp/app.dart';
import 'package:bookapp/features/splash/presentation/views/splash_view.dart';

void main() {
  testWidgets('App builds and shows Splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BookApp());

    expect(find.byType(SplashView), findsOneWidget);

    // Let the 3-second delay in SplashView complete so no timer is left pending
    await tester.pump(const Duration(seconds: 4));
  });
}