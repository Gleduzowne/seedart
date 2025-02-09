import 'package:args/args.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
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
      'script',
      abbr: 's',
      help: 'Path to animation script file',
      mandatory: true,
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
    )
    ..addMultiOption(
      'params',
      abbr: 'p',
      help: 'Animation parameters in key=value format',
      splitCommas: true,
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: seedart -s <script_path> [options]');
  print(argParser.usage);
  print('\nExample:');
  print('  seedart -s examples/rotating_cube.dart -o cube.mp4 -d 10 --fps 60');
}

Map<String, dynamic> parseParams(List<String> params) {
  final Map<String, dynamic> result = {};
  for (final param in params) {
    final parts = param.split('=');
    if (parts.length == 2) {
      final key = parts[0];
      final value = parts[1];
      // Try to parse as number if possible
      if (double.tryParse(value) != null) {
        result[key] = double.parse(value);
      } else {
        result[key] = value;
      }
    }
  }
  return result;
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

    final scriptPath = results['script'];
    if (!File(scriptPath).existsSync()) {
      throw FormatException('Script file not found: $scriptPath');
    }

    // Parse animation parameters
    final int width = int.parse(results['width']);
    final int height = int.parse(results['height']);
    final int fps = int.parse(results['fps']);
    final int durationSeconds = int.parse(results['duration']);
    final String outputPath = results['output'];
    final params = parseParams(results['params'] ?? []);

    if (verbose) {
      print('[VERBOSE] Rendering animation:');
      print('Script: $scriptPath');
      print('Resolution: ${width}x$height');
      print('FPS: $fps');
      print('Duration: ${durationSeconds}s');
      print('Output: $outputPath');
      if (params.isNotEmpty) {
        print('Parameters: $params');
      }
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

    await engine.renderAnimation(
      scriptPath: scriptPath,
      duration: Duration(seconds: durationSeconds),
      params: params,
    );
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(parser);
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
