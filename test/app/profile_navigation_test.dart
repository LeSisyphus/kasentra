import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/app.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/features/profile/presentation/screens/profile_form_screen.dart';

void main() {
  testWidgets('profile setup action opens profile form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeBusinessProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const KasentraApp(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));

    await tester.pumpAndSettle();

    expect(find.text('Siapkan Profil Usaha'), findsOneWidget);

    await tester.tap(find.text('Siapkan Profil Usaha'));

    await tester.pumpAndSettle();

    expect(find.byType(ProfileFormScreen), findsOneWidget);

    expect(find.text('Simpan Profil Usaha'), findsOneWidget);
  });
}
