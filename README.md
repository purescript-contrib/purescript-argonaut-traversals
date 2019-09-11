# purescript-argonaut-traversals

[![Latest release](http://img.shields.io/github/release/purescript-contrib/purescript-argonaut-traversals.svg)](https://github.com/purescript-contrib/purescript-argonaut-traversals/releases)
[![Build status](https://travis-ci.org/purescript-contrib/purescript-argonaut-traversals.svg?branch=master)](https://travis-ci.org/purescript-contrib/purescript-argonaut-traversals)
[![Pursuit](http://pursuit.purescript.org/packages/purescript-argonaut-traversals/badge)](http://pursuit.purescript.org/packages/purescript-argonaut-traversals/)
[![Maintainer: garyb](https://img.shields.io/badge/maintainer-garyb-lightgrey.svg)](http://github.com/garyb)
[![Maintainer: thomashoneyman](https://img.shields.io/badge/maintainer-thomashoneyman-lightgrey.svg)](http://github.com/thomashoneyman)

[Argonaut](https://github.com/purescript-contrib/purescript-argonaut) is a collection of libraries for working with JSON in PureScript. `argonaut-traversals` defines prisms, traversals, and zipper for the Argonaut `Json` type.

## Installation

This library is bundled as part of [Argonaut](https://github.com/purescript-contrib/purescript-argonaut) and can be installed via that library. To install just `argonaut-traversals`:

```sh
# with Spago
spago install argonaut-traversals

# with Bower
bower install purescript-argonaut-traversals
```

## Documentation

Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-argonaut-traversals). You may also be interested in other libraries in the Argonaut ecosystem:

- [purescript-argonaut-core](https://github.com/purescript-contrib/purescript-argonaut-core) defines the `Json` type, along with basic parsing, printing, and folding functions
- [purescript-argonaut-codecs](https://github.com/purescript-contrib/purescript-argonaut-codecs) provides codecs based on `EncodeJson` and `DecodeJson` type classes, along with instances for common data types and combinators for encoding and decoding `Json` values.
- [purescript-codec-argonaut](https://github.com/garyb/purescript-codec-argonaut) supports an alternative approach for codecs, which are based on profunctors instead of type classes.
- [purescript-argonaut-generic](https://github.com/purescript-contrib/purescript-argonaut-generic) supports generic encoding and decoding for any type with a `Generic` instance.

## Contributing

Read the [contribution guidelines](https://github.com/purescript-contrib/purescript-argonaut-traversals/blob/master/.github/contributing.md) to get started and see helpful related resources.
