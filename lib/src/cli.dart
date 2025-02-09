import 'package:args/args.dart';
import 'package:flutter/widgets.dart';
import 'package:seedart/src/engine/animation_engine.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addOption(
      'width',
      abbr: 'w',
      help: 'Output width in pixels',
      defaultsTo: '1920',
    )
    ..addOption(
      'height',
      help: 'Output height in pixels',
      defaultsTo: '1080',
    )
    ..addOption(
      'fps',
      help: 'Frames per second',
      defaultsTo: '30',
    )
    ..addOption(
      'duration',
      abbr: 'd',
      help: 'Animation duration in seconds',
      defaultsTo: '5',
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output file path',
      defaultsTo: 'output.mp4',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart seedart.dart <flags> [arguments]');
  print(argParser.usage);
}

Future<void> runCLI(List<String> arguments) async {
  final parser = buildParser();
  try {
    final results = parser.parse(arguments);
    bool verbose = false;

    if (results['help'] == true) {
      printUsage(parser);
      return;
    }
    if (results['version'] == true) {
      print('seedart version: $version');
      return;
    }
    if (results['verbose'] == true) {
      verbose = true;
    }

    // Parse animation parameters
    final int width = int.parse(results['width']);
    final int height = int.parse(results['height']);
    final int fps = int.parse(results['fps']);
    final int durationSeconds = int.parse(results['duration']);
    final String outputPath = results['output'];

    if (verbose) {
      print('[VERBOSE] Rendering animation:');
      print('Resolution: ${width}x$height');
      print('FPS: $fps');
      print('Duration: ${durationSeconds}s');
      print('Output: $outputPath');
    }

    // Initialize Flutter binding
    WidgetsFlutterBinding.ensureInitialized();

    // Create and run animation engine
    final engine = AnimationEngine(
      width: width,
      height: height,
      fps: fps,
      outputPath: outputPath,
    );

    // Example animation - replace with actual scene
    await engine.renderAnimation(
      duration: Duration(seconds: durationSeconds),
      scene: Container(
        color: const Color(0xFF2196F3),
        child: const Center(
          child: FlutterLogo(size: 200),
        ),
      ),
    );
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(parser);
  }
}
