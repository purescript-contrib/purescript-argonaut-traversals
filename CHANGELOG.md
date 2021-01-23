# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes (😱!!!):
- Added support for PureScript 0.14 and dropped support for all previous versions (#32)

New features:

Bugfixes:

Other improvements:
- Changed default branch to `main` from `master`
- Updated to comply with Contributors library guidelines by adding new issue and pull request templates, updating documentation, and migrating to Spago for local development and CI (#28, #31)

## [v8.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v8.0.0) - 2020-06-20

- Updated to use [`argonaut-codecs` v7.0.0](https://github.com/purescript-contrib/purescript-argonaut-codecs/releases/tag/v7.0.0), which introduces typed decoder errors. These errors provide richer information for processing and printing error messages in JSON libraries.

## [v7.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v7.0.0) - 2019-03-05

- Updated dependencies

## [v6.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v6.0.0) - 2018-12-03

- Updated `purescript-argonaut-codecs` dependency, now supporting generic encoding / decoding of records directly (@davezuch).

## [v4.1.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v4.1.0) - 2018-11-15

- Updated documentation and links (@justinwoo)

## [v5.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v5.0.0) - 2018-11-12

- Updated the `purescript-profunctor-lenses` dependency (@athanclark)

## [v4.0.1](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v4.0.1) - 2018-06-23

- Added metadata including contributor guidelines and pushed latest release to Pursuit

## [v4.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v4.0.0) - 2018-06-08

- Updated for 0.12

## [v3.1.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v3.1.0) - 2017-04-08

- Added `genJCursor`

## [v3.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v3.0.0) - 2017-04-08

- Updated for PureScript v0.11
- Updated the `Show` the instance for `JCursor` to print the structure, the pretty printer is now a separate function

## [v2.0.1](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v2.0.1) - 2016-11-17

- Fixed shadowed name warnings

## [v2.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v2.0.0) - 2016-10-22

- Updated dependencies

## [v1.0.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v1.0.0) - 2016-06-11

- Updated for the 1.0 core libraries.

## [v0.7.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.7.0) - 2016-01-15

- Updated for latest `purescript-argonaut-codecs`. **NOTE**: This changes Argonaut's encoding for `Either`s.

## [v0.6.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.6.0) - 2015-11-20

- Updated for latest `purescript-argonaut-codecs`
- Removed unused import

**Note**: this release requires PureScript 0.7.6 or newer.

## [v0.5.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.5.0) - 2015-11-05

- Updated dependencies

## [v0.4.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.4.0) - 2015-11-02

- Switched to `purescript-profunctor-lenses`

## [v0.3.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.3.0) - 2015-09-08

- Updated dependencies (#4)

## [v0.2.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.2.0) - 2015-08-19

- Updated dependencies for PureScript 0.7.3 (@zudov)

## [v0.1.0](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases/tag/v0.1.0) - 2015-07-14

- Initial release
