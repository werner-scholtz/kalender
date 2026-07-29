// Rewrites the repository links in README.md, example/README.md and CHANGELOG.md
// to point at a release tag instead of the main branch.
//
// pub.dev renders these files from the published archive and resolves their
// repository links against the default branch, so the page of an old version
// links to newer documentation. The publish workflow runs this script before
// packaging so every published version keeps linking to its own documentation.
// The rewrite only touches the working tree, nothing is committed.
//
// Usage: dart run tool/pin_release_links.dart v0.24.0
//
// Restore with: git checkout -- README.md example/README.md CHANGELOG.md

import 'dart:io';

/// A relative markdown image, capturing the alt text, path and anchor.
final relativeImage = RegExp(r'!\[([^\]]*)\]\((?!https?://|#)([^)#\s]+)(#[^)]*)?\)');

/// A relative markdown link, capturing the path and anchor.
final relativeLink = RegExp(r'\]\((?!https?://|#)([^)#\s]+)(#[^)]*)?\)');

/// The repository URL from [pubspec], without a trailing `.git`.
String repositoryUrl(String pubspec) {
  final match = RegExp(r'^repository:\s*(.+?)(?:\.git)?\s*$', multiLine: true).firstMatch(pubspec);
  if (match == null) throw const FormatException('pubspec.yaml has no repository field');
  return match.group(1)!;
}

/// Rewrites relative links to `blob/<tag>` URLs and relative images to raw
/// URLs on the tag, matching how pub.dev resolves each kind.
String pinRelativeLinks(String content, String repoUrl, String tag) {
  final rawBase = repoUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
  return content
      .replaceAllMapped(relativeImage, (m) => '![${m[1]}]($rawBase/$tag/${m[2]}${m[3] ?? ''})')
      .replaceAllMapped(relativeLink, (m) => ']($repoUrl/blob/$tag/${m[1]}${m[2] ?? ''})');
}

/// Rewrites absolute URLs that reference the main branch to the tag.
String pinBranchUrls(String content, String repoUrl, String tag) {
  final rawBase = repoUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
  return content
      .replaceAll('$rawBase/main/', '$rawBase/$tag/')
      .replaceAll('$repoUrl/tree/main/', '$repoUrl/tree/$tag/')
      .replaceAll('$repoUrl/blob/main/', '$repoUrl/blob/$tag/');
}

/// Rewrites only the relative MIGRATION.md links. The changelog's historical
/// entries reference the main branch on purpose, so they must stay untouched.
String pinChangelog(String content, String repoUrl, String tag) {
  return content.replaceAllMapped(
    RegExp(r'\]\(MIGRATION\.md(#[^)]*)?\)'),
    (m) => ']($repoUrl/blob/$tag/MIGRATION.md${m[1] ?? ''})',
  );
}

/// Lines in [content] that still carry a relative link, or a main branch
/// reference unless [allowMainRefs] is set.
List<String> leftoverProblems(String path, String content, String repoUrl, {required bool allowMainRefs}) {
  final rawBase = repoUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
  final mainRefs = ['$repoUrl/blob/main/', '$repoUrl/tree/main/', '$rawBase/main/'];
  final problems = <String>[];
  final lines = content.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (relativeImage.hasMatch(line) || relativeLink.hasMatch(line)) {
      problems.add('$path:${i + 1}: a relative link survived the rewrite: $line');
    }
    if (!allowMainRefs && mainRefs.any(line.contains)) {
      problems.add('$path:${i + 1}: a link still references the main branch: $line');
    }
  }
  return problems;
}

void main(List<String> args) {
  if (args.length != 1 || !RegExp(r'^v\d+\.\d+\.\d+').hasMatch(args.first)) {
    stderr.writeln('Usage: dart run tool/pin_release_links.dart <tag>');
    stderr.writeln('The tag must look like v1.2.3, a pre-release suffix is allowed.');
    exit(64);
  }
  final tag = args.first;
  final repoUrl = repositoryUrl(File('pubspec.yaml').readAsStringSync());

  final rewrites = <String, String Function(String)>{
    'README.md': (content) => pinRelativeLinks(pinBranchUrls(content, repoUrl, tag), repoUrl, tag),
    'example/README.md': (content) => pinBranchUrls(content, repoUrl, tag),
    'CHANGELOG.md': (content) => pinChangelog(content, repoUrl, tag),
  };

  final problems = <String>[];
  for (final entry in rewrites.entries) {
    final file = File(entry.key);
    final rewritten = entry.value(file.readAsStringSync());
    file.writeAsStringSync(rewritten);
    problems.addAll(leftoverProblems(entry.key, rewritten, repoUrl, allowMainRefs: entry.key == 'CHANGELOG.md'));
    stdout.writeln('Pinned ${entry.key} to $tag');
  }

  if (problems.isNotEmpty) {
    problems.forEach(stderr.writeln);
    exit(1);
  }
}
