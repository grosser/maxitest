# Next

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
