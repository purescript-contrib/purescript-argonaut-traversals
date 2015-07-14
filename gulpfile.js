'use strict'

var gulp        = require('gulp')
  , purescript  = require('gulp-purescript')
  , run         = require('gulp-run')
  , runSequence = require('run-sequence')
  ;

function sequence() {
    var args = [].slice.apply(arguments);
    return function() {
        runSequence.apply(null, args);
    };
}

var sources = [
    'src/**/*.purs',
    'bower_components/purescript-*/src/**/*.purs'
];

var foreigns = [
    'src/**/*.js',
    'bower_components/purescript-*/src/**/*.js'
];

var testSources = [
    'test/**/*.purs'
];

var testForeigns = [
    'test/**/*.js'
];

gulp.task('docs', function() {
    return purescript.pscDocs({
        src: sources,
        docgen: {
            "Data.Argonaut.Prisms": "docs/Data/Argonaut/Prisms.md",
            "Data.Argonaut.Traversals": "docs/Data/Argonaut/Traversals.md",
            "Data.Argonaut.JCursor": "docs/Data/Argonaut/JCursor.md"
        }
    });
});


gulp.task('make', function() {
    return purescript.psc({
        src: sources,
        ffi: foreigns
    });
});

gulp.task('test-make', function() {
    return purescript.psc({
        src: sources.concat(testSources),
        ffi: foreigns.concat(testForeigns)
    });
});

gulp.task('test', ['test-make'], function() {
    return purescript.pscBundle({
        src: "output/**/*.js",
        main: "Test.Main",
        output: "dist/test.js"
    }).pipe(run('node dist/test.js'));
});


gulp.task("default", sequence("make", "docs"));
