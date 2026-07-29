import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/pin_release_links.dart'
    show
        docFiles,
        leftoverProblems,
        packageName,
        pinBranchUrls,
        pinChangelog,
        pinPubDevDocs,
        pinRelativeLinks,
        repositoryUrl;

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

    test('a relative src on an img tag becomes a raw link on the tag', () {
      expect(
        pinRelativeLinks('<img src="readme_assets/desktop.png" alt="Week view" width="68%" />', repo, tag),
        '<img src="https://raw.githubusercontent.com/werner-scholtz/kalender/$tag/readme_assets/desktop.png" '
        'alt="Week view" width="68%" />',
      );
    });

    test('an absolute src on an img tag is left alone', () {
      const absolute = '<img src="https://img.shields.io/pub/v/kalender.svg" alt="pub.dev version">';
      expect(pinRelativeLinks(absolute, repo, tag), absolute);
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

  group('packageName', () {
    test('reads the name field', () {
      expect(packageName('name: kalender\nversion: 0.24.0\n'), 'kalender');
    });
  });

  group('pinPubDevDocs', () {
    test('latest becomes the released version, without the leading v', () {
      expect(
        pinPubDevDocs(
          'https://pub.dev/documentation/kalender/latest/kalender/EventsController-class.html',
          'kalender',
          tag,
        ),
        'https://pub.dev/documentation/kalender/9.9.9/kalender/EventsController-class.html',
      );
    });

    test("another package's latest is left alone, this tag says nothing about its versions", () {
      const other = 'https://pub.dev/documentation/timezone/latest/timezone/Location-class.html';
      expect(pinPubDevDocs(other, 'kalender', tag), other);
    });

    test('a pub.dev package page is left alone', () {
      const packagePage = 'https://pub.dev/packages/intl';
      expect(pinPubDevDocs(packagePage, 'kalender', tag), packagePage);
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
      final problems = leftoverProblems('README.md', 'fine\n[stray](doc/views.md)', repo, allowUnpinnedLinks: false);
      expect(problems, hasLength(1));
      expect(problems.single, startsWith('README.md:2:'));
    });

    test('reports a relative img src, which markdown image syntax does not cover', () {
      const content = '<img src="readme_assets/desktop.png" />';
      final problems = leftoverProblems('README.md', content, repo, allowUnpinnedLinks: false);
      expect(problems, hasLength(1));
      expect(problems.single, contains('a relative image survived the rewrite'));
    });

    test('reports a main branch reference unless allowed', () {
      const content = '[a]($repo/blob/main/doc/views.md)';
      expect(leftoverProblems('README.md', content, repo, allowUnpinnedLinks: false), hasLength(1));
      expect(leftoverProblems('CHANGELOG.md', content, repo, allowUnpinnedLinks: true), isEmpty);
    });

    test('a relative link is allowed when the file keeps them', () {
      const content = 'see [views](views.md#views)\nand the [index](../README.md)';
      expect(leftoverProblems('doc/events.md', content, repo, allowUnpinnedLinks: false), hasLength(2));
      expect(
        leftoverProblems('doc/events.md', content, repo, allowUnpinnedLinks: false, allowRelativeLinks: true),
        isEmpty,
      );
    });

    test('a main branch reference is still reported when relative links are allowed', () {
      const content = '[strategy]($repo/blob/main/examples/advanced_example/lib/layout_strategy.dart)';
      final problems =
          leftoverProblems('doc/layout.md', content, repo, allowUnpinnedLinks: false, allowRelativeLinks: true);
      expect(problems, hasLength(1));
      expect(problems.single, startsWith('doc/layout.md:1:'));
    });
  });

  group('docFiles', () {
    test('lists only markdown, sorted', () {
      final directory = Directory.systemTemp.createTempSync('doc_files_test');
      addTearDown(() => directory.deleteSync(recursive: true));
      File('${directory.path}/views.md').writeAsStringSync('');
      File('${directory.path}/appearance.md').writeAsStringSync('');
      File('${directory.path}/notes.txt').writeAsStringSync('');

      expect(
        docFiles(directory).map((path) => path.split(Platform.pathSeparator).last),
        ['appearance.md', 'views.md'],
      );
    });

    test('an absent directory yields nothing', () {
      expect(docFiles(Directory('doc_that_does_not_exist')), isEmpty);
    });

    test('finds the real guides', () {
      expect(docFiles(), isNotEmpty);
    });
  });

  group('repository files', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final repoUrl = repositoryUrl(pubspec);
    final package = packageName(pubspec);

    String pinAll(String content) => pinPubDevDocs(pinBranchUrls(content, repoUrl, tag), package, tag);

    test('the real README, example README and CHANGELOG rewrite cleanly', () {
      final readme = pinRelativeLinks(pinAll(File('README.md').readAsStringSync()), repoUrl, tag);
      expect(leftoverProblems('README.md', readme, repoUrl, allowUnpinnedLinks: false, package: package), isEmpty);

      final example = pinAll(File('example/README.md').readAsStringSync());
      expect(
        leftoverProblems('example/README.md', example, repoUrl, allowUnpinnedLinks: false, package: package),
        isEmpty,
      );

      final changelog = pinChangelog(File('CHANGELOG.md').readAsStringSync(), repoUrl, tag);
      expect(leftoverProblems('CHANGELOG.md', changelog, repoUrl, allowUnpinnedLinks: true, package: package), isEmpty);
    });

    test('the real guides rewrite cleanly and keep their relative links', () {
      for (final path in docFiles()) {
        final rewritten = pinAll(File(path).readAsStringSync());
        expect(
          leftoverProblems(
            path,
            rewritten,
            repoUrl,
            allowUnpinnedLinks: false,
            allowRelativeLinks: true,
            package: package,
          ),
          isEmpty,
          reason: '$path still has an unpinned link after the rewrite',
        );
      }
    });
  });
}
