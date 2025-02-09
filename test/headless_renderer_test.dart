import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:seedart/src/engine/headless_renderer.dart';
import 'package:seedart/src/engine/headless_binding.dart';

void main() {
  group('HeadlessRenderer', () {
    setUp(() {
      HeadlessFlutterBinding.ensureInitialized();
    });

    test('should initialize with correct dimensions', () {
      final renderer = HeadlessRenderer(width: 1920, height: 1080);
      expect(renderer.width, equals(1920));
      expect(renderer.height, equals(1080));
    });

    test('should render simple widget', () {
      final renderer = HeadlessRenderer(width: 100, height: 100);

      expect(
        () => renderer.render(
          Container(
            width: 100,
            height: 100,
            color: const Color(0xFF000000),
          ),
        ),
        returnsNormally,
      );
    });

    test('should cleanup resources on dispose', () {
      final renderer = HeadlessRenderer(width: 100, height: 100);
      renderer.render(Container());
      expect(() => renderer.dispose(), returnsNormally);
    });
  });
}
