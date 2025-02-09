# Seedart

A headless Flutter-powered CLI animation engine for generating 2D and 3D animations through code. Runs anywhere with a CLI and FFmpeg installed.

## Prerequisites

- Dart SDK >=3.6.1
- FFmpeg installed on your system
- No GUI or platform-specific dependencies required

## Installation

```bash
dart pub global activate seedart
```

## Usage

Create an animation script:

```dart
// examples/rotating_cube.dart
import 'package:flutter/material.dart';

class RotatingCube extends StatelessWidget {
  final double animationValue;
  const RotatingCube({required this.animationValue});
  
  @override
  Widget build(BuildContext context) {
    // Animation logic here
  }
}
```

Run the animation:

```bash
seedart -s examples/rotating_cube.dart -o output.mp4 -d 5 --fps 60
```

## Options

- `-s, --script`: Animation script path (required)
- `-o, --output`: Output file path (default: output.mp4)
- `-d, --duration`: Animation duration in seconds (default: 5)
- `--fps`: Frames per second (default: 30)
- `-w, --width`: Output width in pixels (default: 1920)
- `--height`: Output height in pixels (default: 1080)
- `-p, --params`: Custom animation parameters (format: key=value)

## Examples

1. Generate a 10-second rotating cube animation:
```bash
seedart -s examples/rotating_cube.dart -o cube.mp4 -d 10 --fps 60
```

2. Pass custom parameters to your animation:
```bash
seedart -s examples/particle_system.dart -o particles.mp4 -p count=1000,speed=2.5
```

## Creating Animation Scripts

Animation scripts are Dart files that use Flutter widgets to define animations. They receive an `animationValue` parameter that ranges from 0.0 to 1.0 over the duration of the animation.
