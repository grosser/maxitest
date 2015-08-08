Minitest + all the features you always wanted.

![Failure](https://dl.dropboxusercontent.com/u/2670385/Web/maxitest-failure.png)

Features
========
 - **Ctrl+c** stops tests and prints failures
 - **pastable rerun snippet** for failures
 - multiple before & after blocks
 - **around** blocks `around { |t| Dir.chdir(...) { t.call } }`
 - `before/after/around :all` blocks
 - **red-green** output
 - `mtest` executable to **run by line number** and by folder
 - full backtrace for errors and assertions with verbose (`-v`)
 - `let!`
 - `let_all` execute once for all tests in a class and it's subclasses
 - `order_dependent!` to make your tests run in given order
 - `Maxitest.static_class_order = true` no longer sort tests class/sub-classes in random order
 - `context` for more expression
 - `pending { assert false }` is skip when it fails, but fails when it passes
 - implicit subject via `require 'maxitest/implicit_subject'`
 - `xit` to skip test (also does not call setup or teardown)

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
 - around hooks are run before any other hooks ... afaik only fixable via Fibers which leads to threading issues ... see https://github.com/splattael/minitest-around/pull/11
 - `before :all` / `after :all` / `around :all` are called once per subclass but should not https://github.com/jeremyevans/minitest-hooks/issues/8
 - `before :all` / `after :all` / `around :all` are called for empty classes but should not https://github.com/jeremyevans/minitest-hooks/issues/7

Author
======
 - running by line number from [minitest-line](https://github.com/judofyr/minitest-line)
 - hooks from [minitest-hooks](https://github.com/jeremyevans/minitest-hooks)
 - mtest from [testrbl](https://github.com/grosser/testrbl)
 - red-green from [minitest-rg](https://github.com/blowmage/minitest-rg)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/maxitest.png)](https://travis-ci.org/grosser/maxitest)
