// Rewrites the repository links in README.md, example/README.md, CHANGELOG.md and
// doc/*.md to point at a release tag instead of the main branch.
//
// pub.dev renders these files from the published archive and resolves their
// repository links against the default branch, so the page of an old version
// links to newer documentation. The publish workflow runs this script before
// packaging so every published version keeps linking to its own documentation.
// The rewrite only touches the working tree, nothing is committed.
//
// The guides under doc/ are only ever read on GitHub, where a relative link
// already resolves against whatever ref is being browsed. They therefore get the
// branch rewrite but not the relative rewrite, which prepends a root-relative
// prefix and would break `../README.md` and sibling links like `views.md`.
//
// Usage: dart run tool/pin_release_links.dart v0.24.0
//
// Restore with: git checkout -- README.md example/README.md CHANGELOG.md doc/

import 'dart:io';

/// A relative markdown image, capturing the alt text, path and anchor.
final relativeImage = RegExp(r'!\[([^\]]*)\]\((?!https?://|#)([^)#\s]+)(#[^)]*)?\)');

/// A relative markdown link, capturing the path and anchor.
final relativeLink = RegExp(r'\]\((?!https?://|#)([^)#\s]+)(#[^)]*)?\)');

/// An `<img>` tag, so its `src` can be inspected. The README centres images in
/// HTML rather than markdown, and those are invisible to [relativeImage].
final htmlImageTag = RegExp(r'<img\b[^>]*>');

/// A relative `src` on an HTML tag, capturing the path.
final relativeHtmlSrc = RegExp(r'src="(?!https?://|data:|#)([^"]+)"');

/// Whether [content] has an `<img>` tag whose `src` is relative.
bool hasRelativeHtmlImage(String content) {
  return htmlImageTag.allMatches(content).any((m) => relativeHtmlSrc.hasMatch(m[0]!));
}

/// The repository URL from [pubspec], without a trailing `.git`.
String repositoryUrl(String pubspec) {
  final match = RegExp(r'^repository:\s*(.+?)(?:\.git)?\s*$', multiLine: true).firstMatch(pubspec);
  if (match == null) throw const FormatException('pubspec.yaml has no repository field');
  return match.group(1)!;
}

/// The package name from [pubspec].
String packageName(String pubspec) {
  final match = RegExp(r'^name:\s*(\S+)\s*$', multiLine: true).firstMatch(pubspec);
  if (match == null) throw const FormatException('pubspec.yaml has no name field');
  return match.group(1)!;
}

/// Rewrites relative links to `blob/<tag>` URLs and relative images to raw
/// URLs on the tag, matching how pub.dev resolves each kind.
///
/// Images are rewritten in both markdown and `<img>` form. `readme_assets/` is
/// excluded from the published archive, so a relative image that survives is a
/// broken image on pub.dev.
String pinRelativeLinks(String content, String repoUrl, String tag) {
  final rawBase = repoUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
  return content
      .replaceAllMapped(relativeImage, (m) => '![${m[1]}]($rawBase/$tag/${m[2]}${m[3] ?? ''})')
      .replaceAllMapped(
        htmlImageTag,
        (m) => m[0]!.replaceAllMapped(relativeHtmlSrc, (src) => 'src="$rawBase/$tag/${src[1]}"'),
      )
      .replaceAllMapped(relativeLink, (m) => ']($repoUrl/blob/$tag/${m[1]}${m[2] ?? ''})');
}

/// A pub.dev API documentation link for [package] on the `latest` version.
RegExp pubDevLatest(String package) => RegExp('https://pub\\.dev/documentation/$package/latest/');

/// Rewrites this package's pub.dev API documentation links from `latest` to the
/// released version, so an old release links to the API it actually shipped.
///
/// Only [package] is rewritten. Another package's `latest` is correct as it
/// stands, because this tag says nothing about that package's versions.
String pinPubDevDocs(String content, String package, String tag) {
  final version = tag.startsWith('v') ? tag.substring(1) : tag;
  return content.replaceAll(pubDevLatest(package), 'https://pub.dev/documentation/$package/$version/');
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

/// Lines in [content] that still carry a relative link, or a link that floats to
/// the newest documentation rather than this release's.
///
/// Set [allowUnpinnedLinks] for files that keep such links on purpose, such as
/// the changelog's historical entries. Set [allowRelativeLinks] for files whose
/// relative links are deliberately kept, such as the guides under doc/.
List<String> leftoverProblems(
  String path,
  String content,
  String repoUrl, {
  required bool allowUnpinnedLinks,
  bool allowRelativeLinks = false,
  String package = 'kalender',
}) {
  final rawBase = repoUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
  final mainRefs = ['$repoUrl/blob/main/', '$repoUrl/tree/main/', '$rawBase/main/'];
  final latestDocs = pubDevLatest(package);
  final problems = <String>[];
  final lines = content.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (!allowRelativeLinks && (relativeImage.hasMatch(line) || relativeLink.hasMatch(line))) {
      problems.add('$path:${i + 1}: a relative link survived the rewrite: $line');
    }
    if (!allowRelativeLinks && hasRelativeHtmlImage(line)) {
      problems.add('$path:${i + 1}: a relative image survived the rewrite: $line');
    }
    if (!allowUnpinnedLinks && mainRefs.any(line.contains)) {
      problems.add('$path:${i + 1}: a link still references the main branch: $line');
    }
    if (!allowUnpinnedLinks && latestDocs.hasMatch(line)) {
      problems.add('$path:${i + 1}: a link still references the latest API docs: $line');
    }
  }
  return problems;
}

/// The guide files under doc/, sorted so a run is deterministic.
List<String> docFiles([Directory? directory]) {
  final dir = directory ?? Directory('doc');
  if (!dir.existsSync()) return const [];
  return dir.listSync().whereType<File>().map((file) => file.path).where((path) => path.endsWith('.md')).toList()
    ..sort();
}

void main(List<String> args) {
  if (args.length != 1 || !RegExp(r'^v\d+\.\d+\.\d+').hasMatch(args.first)) {
    stderr.writeln('Usage: dart run tool/pin_release_links.dart <tag>');
    stderr.writeln('The tag must look like v1.2.3, a pre-release suffix is allowed.');
    exit(64);
  }
  final tag = args.first;
  final pubspec = File('pubspec.yaml').readAsStringSync();
  final repoUrl = repositoryUrl(pubspec);
  final package = packageName(pubspec);

  /// Everything except the changelog, whose historical entries are pinned separately.
  String pinAll(String content) => pinPubDevDocs(pinBranchUrls(content, repoUrl, tag), package, tag);

  final rewrites = <({String path, String Function(String) rewrite, bool allowUnpinnedLinks, bool allowRelativeLinks})>[
    (
      path: 'README.md',
      rewrite: (content) => pinRelativeLinks(pinAll(content), repoUrl, tag),
      allowUnpinnedLinks: false,
      allowRelativeLinks: false,
    ),
    (path: 'example/README.md', rewrite: pinAll, allowUnpinnedLinks: false, allowRelativeLinks: false),
    (
      path: 'CHANGELOG.md',
      rewrite: (content) => pinChangelog(content, repoUrl, tag),
      allowUnpinnedLinks: true,
      allowRelativeLinks: false,
    ),
    for (final doc in docFiles()) (path: doc, rewrite: pinAll, allowUnpinnedLinks: false, allowRelativeLinks: true),
  ];

  final problems = <String>[];
  for (final entry in rewrites) {
    final file = File(entry.path);
    final rewritten = entry.rewrite(file.readAsStringSync());
    file.writeAsStringSync(rewritten);
    problems.addAll(
      leftoverProblems(
        entry.path,
        rewritten,
        repoUrl,
        allowUnpinnedLinks: entry.allowUnpinnedLinks,
        allowRelativeLinks: entry.allowRelativeLinks,
        package: package,
      ),
    );
    stdout.writeln('Pinned ${entry.path} to $tag');
  }

  if (problems.isNotEmpty) {
    problems.forEach(stderr.writeln);
    exit(1);
  }
}
