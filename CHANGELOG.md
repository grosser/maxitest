# Next

# v7.1.1
- fix backtrace cleaner not ignoring maxitest traces

# v7.1.0
- update vendored gems

# v7.0.0
- only support minitest 6 (which does not work with any released rails version)
- removed `mtest` binary, use `minitest` instead
- stoped using alias method chaining, so things might break if you have other minitest extensions
- use frozen strings everywhere

# v6.2.0
- test and unblock ruby 4

# v6.1.0
- test with minitest 5.26 and 5.27

# v6.0.1
- fix unused block warning for `xit` on ruby 3.4

# v6.0.0
- drop support for Ruby <=3.1 and minitest <5.20, test on ruby 3.4

# v5.8.0
- bin/rails test line bug

# v5.7.1
- support disabling interrupt handling to avoid minitest-reporters bug with MAXITEST_NO_INTERRUPT=true

# v5.7.0
- support minitest 5.25

# v5.6.0
- support minitest 5.24

# v5.5.0
- support minitest 5.23

# v5.4.0
- support minitest 5.20

# v5.3.1
- remove MiniTest usage to make Zeitwerk happy

# v5.3.0
- `pending "broken", if: ENV["CI"] do`
- `with_env`
- `capture_stderr` + `capture_stdout`
- hide maxitest backtraces by default

# v5.2.0
- support minitest 5.19

# v5.1.0
- support `before :all`
- block invalid `after :all` and `around :all`

# v5.0.0
- add minitest 5.14 support
- drop EOL rubies (<=2.7) and minitest versions
