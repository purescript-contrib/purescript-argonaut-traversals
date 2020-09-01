{ name = "argonaut-traversals"
, dependencies =
  [ "argonaut-codecs"
  , "argonaut-core"
  , "console"
  , "effect"
  , "profunctor-lenses"
  , "psci-support"
  , "quickcheck"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
