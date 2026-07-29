import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/pin_release_links.dart'
    show leftoverProblems, pinBranchUrls, pinChangelog, pinRelativeLinks, repositoryUrl;

const repo = 'https://github.com/werner-scholtz/kalender';
const tag = 'v9.9.9';

void main() {
  group('repositoryUrl', () {
    test('strips the trailing .git from the repository field', () {
      expect(repositoryUrl('name: kalender\nrepository: $repo.git\n'), repo);
    });
  });

  group('pinRelativeLinks', () {
    test('relative links become blob links on the tag and keep their anchors', () {
      expect(
        pinRelativeLinks('[views](doc/views.md#views) and [license](LICENSE)', repo, tag),
        '[views]($repo/blob/$tag/doc/views.md#views) and [license]($repo/blob/$tag/LICENSE)',
      );
    });

    test('relative images become raw links on the tag', () {
      expect(
        pinRelativeLinks('![banner](readme_assets/banner.png)', repo, tag),
        '![banner](https://raw.githubusercontent.com/werner-scholtz/kalender/$tag/readme_assets/banner.png)',
      );
    });

    test('anchor-only table of contents links are left alone', () {
      const toc = '- [Features](#features)';
      expect(pinRelativeLinks(toc, repo, tag), toc);
    });

    test('absolute links are left alone', () {
      const absolute = '[demo](https://werner-scholtz.github.io/kalender/)';
      expect(pinRelativeLinks(absolute, repo, tag), absolute);
    });
  });

  group('pinBranchUrls', () {
    test('the banner image is re-pinned from main to the tag', () {
      expect(
        pinBranchUrls(
          '<img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/banner.png">',
          repo,
          tag,
        ),
        '<img src="https://raw.githubusercontent.com/werner-scholtz/kalender/$tag/readme_assets/banner.png">',
      );
    });

    test('tree/main example links are re-pinned to the tag', () {
      expect(
        pinBranchUrls('[example]($repo/tree/main/examples/web_demo)', repo, tag),
        '[example]($repo/tree/$tag/examples/web_demo)',
      );
    });
  });

  group('pinChangelog', () {
    test('rewrites only the relative MIGRATION.md links', () {
      const line = 'See [MIGRATION.md](MIGRATION.md#v023x--v0240) for the mapping. [#372]($repo/pull/372)';
      final result = pinChangelog(line, repo, tag);
      expect(result, contains(']($repo/blob/$tag/MIGRATION.md#v023x--v0240)'));
      expect(result, contains('[#372]($repo/pull/372)'));
    });

    test('historical blob/main and release branch links are untouched', () {
      const historical = '[a]($repo/blob/main/lib/src/calendar_view.dart) [b]($repo/blob/main-0.4.2/CHANGELOG.md)';
      expect(pinChangelog(historical, repo, tag), historical);
    });
  });

  group('leftoverProblems', () {
    test('reports a leftover relative link with its line number', () {
      final problems = leftoverProblems('README.md', 'fine\n[stray](doc/views.md)', repo, allowMainRefs: false);
      expect(problems, hasLength(1));
      expect(problems.single, startsWith('README.md:2:'));
    });

    test('reports a main branch reference unless allowed', () {
      const content = '[a]($repo/blob/main/doc/views.md)';
      expect(leftoverProblems('README.md', content, repo, allowMainRefs: false), hasLength(1));
      expect(leftoverProblems('CHANGELOG.md', content, repo, allowMainRefs: true), isEmpty);
    });
  });

  group('repository files', () {
    test('the real README, example README and CHANGELOG rewrite cleanly', () {
      final repoUrl = repositoryUrl(File('pubspec.yaml').readAsStringSync());

      final readme = pinRelativeLinks(pinBranchUrls(File('README.md').readAsStringSync(), repoUrl, tag), repoUrl, tag);
      expect(leftoverProblems('README.md', readme, repoUrl, allowMainRefs: false), isEmpty);

      final example = pinBranchUrls(File('example/README.md').readAsStringSync(), repoUrl, tag);
      expect(leftoverProblems('example/README.md', example, repoUrl, allowMainRefs: false), isEmpty);

      final changelog = pinChangelog(File('CHANGELOG.md').readAsStringSync(), repoUrl, tag);
      expect(leftoverProblems('CHANGELOG.md', changelog, repoUrl, allowMainRefs: true), isEmpty);
    });
  });
}
