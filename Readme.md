Minitest + all the features you always wanted.

![Failure](assets/failure.png?raw=true)

Features
========
 - **Ctrl+c** stops tests and prints failures
 - **pastable rerun snippet** for failures (disabled/integrated on rails 5)
 - multiple before & after blocks
 - **around** blocks `around { |t| Dir.chdir(...) { t.call } }`
 - **red-green** output  (disabled/integrated on rails 5)
 - `mtest` executable to **run by line number** and by folder  (disabled/integrated on rails 5)
 - full backtrace for errors and assertions with verbose (`-v`)
 - `let!`
 - `let_all` execute once for all tests in a class and it's subclasses
 - `order_dependent!` to make your tests run in given order
 - `Maxitest.static_class_order = true` no longer sort tests class/sub-classes in random order
 - `context` for more expression
 - `pending { assert false }` is skip when it fails, but fails when it passes
 - implicit subject via `require 'maxitest/implicit_subject'`
 - `xit` to skip test (also does not call setup or teardown)
 - `require 'maxitest/timeout'` to make hanging tests fail after `Maxitest.timeout` seconds
 - `require 'maxitest/threads'` fail tests that leave extra threads running
 - `require 'maxitest/global_must'` (before autorun) disable deprecation on global `must_*`

Install
=======

```Bash
gem install maxitest
```

Usage
=====

```Ruby
require "maxitest/autorun"

... normal tests ...
```
Development
===========
 - everything vendored into 1 gem to avoid dependency madness
 - tested via rspec to avoid messing up our own tests by accident
 - fixes should go back to the original libraries
 - restrictive minitest dependency so nothing breaks by accident
 - ruby 1.9+
 - `rake update` to update all vendored gems

TODO
====
 - make ctrl+c fix its own gem
 - `before :all` / `after :all` / `around :all`
 - minitest 4 version for those stuck on rails 3

Author
======
 - running by line number from [minitest-line](https://github.com/judofyr/minitest-line)
 - around from [minitest-around](https://github.com/splattael/minitest-around)
 - mtest from [testrbl](https://github.com/grosser/testrbl)
 - red-green from [minitest-rg](https://github.com/blowmage/minitest-rg)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/maxitest.png)](https://travis-ci.org/grosser/maxitest)
