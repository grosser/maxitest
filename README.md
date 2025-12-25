Minitest + all the features you always wanted.
[![CI](https://github.com/grosser/maxitest/actions/workflows/actions.yml/badge.svg?branch=master)](https://github.com/grosser/maxitest/actions/workflows/actions.yml?query=branch%3Amaster)
[![Gem Version](https://badge.fury.io/rb/maxitest.svg)](https://badge.fury.io/rb/maxitest)

![Failure](assets/failure.png?raw=true)

Features
========
 - **Ctrl+c** stops tests and prints failures
 - **pastable rerun snippet** for failures (disabled/integrated on rails 5)
 - multiple before & after blocks
 - `before :all` blocks
 - **around** blocks `around { |t| Dir.chdir(...) { t.call } }`
 - **red-green** output  (disabled/integrated on rails 5)
 - full backtrace for errors and assertions with verbose (`-v`)
 - `let!`
 - `let_all` execute once for all tests in a class and it's subclasses
 - `order_dependent!` to make your tests run in given order
 - `Maxitest.static_class_order = true` no longer sort tests class/sub-classes in random order
 - `context` for more expression
 - `pending { assert false }` is skip when it fails, but fails when it passes
 - implicit subject via `require 'maxitest/implicit_subject'`
 - `xit` to skip test (also does not call setup or teardown)
 - `with_env` to change environment variables during test run
 - `capture_stdout` and `capture_stderr` to capture stdout or stderr but not both (like `capture_io` does)
 - `require 'maxitest/timeout'` to make hanging tests fail after `Maxitest.timeout` seconds
 - `require 'maxitest/threads'` fail tests that leave extra threads running
 - `require 'maxitest/global_must'` (before autorun) enable global `must_*` methods on all objects

Install
=======

```Bash
gem install maxitest
```

Usage
=====

```Ruby
require "maxitest/autorun"

# ... normal minitest tests ...
describe MyClass do
  describe "#my_method" do
    it "passes" do
      _(MyClass.new.my_method).must_equal 1
    end
  end
end
```

### pending

- `pending "need to fix" do` to show why something is pending
- `pending "need to fix", if: ENV["CI"] do` to only skip on CI (if something is supposed to work locally)

### with_env

Use during test: `with_env FOO: "bar do ...`
Use as `around` block: `with_env FOO: "bar"`

### context

Use as alias for `describe`

```ruby
describe "#my_method" do
  context "with bad state" do
    before { errors += 1 }
    it "fails" # ...
  end
end
```

### capture_stdout / capture_stderr

```ruby
output = capture_stdout { puts 1 }
_(output).must_equal "1\n"
```

### minitest-reporters

If [PR](https://github.com/minitest-reporters/minitest-reporters/pull/357) is not resolved,
disable Interrupt handling with `ENV["MAXITEST_NO_INTERRUPT"] = "true"` to avoid "stack level too deep" errors.

Development
===========
 - everything vendored into 1 gem to avoid dependency madness
 - tested via rspec to avoid messing up our own tests by accident
 - fixes should go back to the original libraries
 - restrictive minitest dependency so nothing breaks by accident
 - ruby >=3.0
 - `rake bundle` to update all vendored gems

Author
======
 - around from [minitest-around](https://github.com/splattael/minitest-around)
 - red-green from [minitest-rg](https://github.com/blowmage/minitest-rg)

[Michael Grosser](http://grosser.it)<br>
michael@grosser.it<br>
License: MIT
