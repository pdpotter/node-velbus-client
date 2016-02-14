gulp = require 'gulp'

browserify = require 'browserify'
buffer = require 'vinyl-buffer'
coffee = require 'gulp-coffee'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
source = require 'vinyl-source-stream'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'

gulp.task 'coffee-client', ->
  return gulp.src('coffee/client/**/*.coffee')
  .pipe(do plumber)
  .pipe(do coffee)
  .pipe(gulp.dest 'build/js')

gulp.task 'browserify', ['coffee-client'], ->
  return browserify({
    entries: 'build/js/app.js'
    debug: true
  })
  .bundle()
  .pipe(source 'app.min.js')
  .pipe(do buffer)
  .pipe(sourcemaps.init {loadMaps: true})
  .pipe(do uglify)
  .pipe(sourcemaps.write '.')
  .pipe(gulp.dest 'public/js' )

gulp.task 'coffee-server', ->
  return gulp.src('coffee/server/**/*.coffee')
  .pipe(do plumber)
  .pipe(do coffee)
  .pipe(gulp.dest 'server')

gulp.task 'watch', ->
  gulp.watch ['coffee/client/**/*.coffee'], ['browserify']
  gulp.watch ['coffee/server/**/*.coffee'], ['coffee-server']

gulp.task 'bootbox', ->
  return gulp.src([
      'bower_components/bootbox.js/bootbox.js'
    ])
    .pipe(do uglify)
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest 'public/vendor/js')

gulp.task 'vendor-javascript', ->
  gulp.start 'bootbox'
  return gulp.src([
    'bower_components/jquery/dist/jquery.min.js'
    'bower_components/bootstrap/dist/js/bootstrap.min.js',
    'bower_components/bootstrap-toggle/js/bootstrap-toggle.min.js',
  ])
  .pipe(gulp.dest 'public/vendor/js')

gulp.task 'vendor-css', ->
  return gulp.src([
    'bower_components/bootstrap/dist/css/bootstrap.min.css'
    'bower_components/bootstrap-toggle/css/bootstrap-toggle.min.css',
  ])
  .pipe(gulp.dest 'public/vendor/css')

gulp.task 'vendor-fonts', ->
  return gulp.src([
    'bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.woff2'
  ])
  .pipe(gulp.dest 'public/vendor/fonts')

gulp.task 'vendor', ->
  gulp.start 'vendor-javascript'
  gulp.start 'vendor-css'
  gulp.start 'vendor-fonts'
