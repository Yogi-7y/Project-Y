import 'dart:io';

void main() {
  try {
    final changelog = File('CHANGELOG.md');
    if (!changelog.existsSync()) {
      print('CHANGELOG.md not found. Skipping formatting.');
      return;
    }

    var content = changelog.readAsStringSync();

    final typesToLower = ['FEAT', 'FIX', 'DOCS', 'STYLE', 'REFACTOR', 'PERF', 'TEST', 'CHORE'];

    for (final type in typesToLower) {
      content = content.replaceAll('* **$type**:', '* **${type.toLowerCase()}**:');
    }

    changelog.writeAsStringSync(content);
    print('Changelog formatted successfully.');
  } catch (e) {
    print('An error occurred while formatting the changelog: $e');
    exit(1);
  }
}
