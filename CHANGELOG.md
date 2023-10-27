# Next
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
