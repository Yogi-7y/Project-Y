import 'dart:io';

void main() {
  final packagesDir = Directory('packages');
  if (!packagesDir.existsSync()) {
    print('Packages directory not found. Exiting.');
    return;
  }

  for (var packageDir in packagesDir.listSync(followLinks: false)) {
    if (packageDir is Directory) {
      final changelog = File('${packageDir.path}/CHANGELOG.md');
      formatChangelog(changelog);
    }
  }
}

void formatChangelog(File changelog) {
  if (!changelog.existsSync()) {
    print('${changelog.path} not found. Skipping.');
    return;
  }

  try {
    var content = changelog.readAsStringSync();

    // List of conventional commit types to convert to lowercase
    final conventionalTypes = [
      'FEAT',
      'FIX',
      'DOCS',
      'STYLE',
      'REFACTOR',
      'PERF',
      'TEST',
      'BUILD',
      'CI',
      'CHORE',
      'REVERT'
    ];

    final typePattern = conventionalTypes.join('|');

    final typeRegex = RegExp(r'\*\*(' + typePattern + r')\*\*:', caseSensitive: false);

    content = content.replaceAllMapped(typeRegex, (match) {
      return '**${match.group(1)!.toLowerCase()}**:';
    });

    content = content.replaceAll(RegExp(r'\s*\(\[.+?\]\(.+?\)\)'), '');

    content = content.split('\n').map((line) => line.trimRight()).join('\n');

    changelog.writeAsStringSync(content);
    print('Formatted ${changelog.path} successfully.');
  } catch (e) {
    print('An error occurred while formatting ${changelog.path}: $e');
    print(StackTrace.current);
  }
}
