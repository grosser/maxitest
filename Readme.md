Minitest + all the features you always wanted.

![Failure](https://dl.dropboxusercontent.com/u/2670385/Web/maxitest-failure.png)

Features
========
 - **Ctrl+c** stops tests and prints failures
 - **pastable rerun snippet** for failures
 - multiple before & after blocks
 - **around** blocks `around { |t| Dir.chdir(...) { t.call } }`
 - **red-green** output
 - `mtest` executable to **run by line number** and by folder
 - `let!`
 - `order_dependent!` to make your tests run in given order
 - `context` for more expression
 - `pending { assert false }` is skip when it fails, but fails when it passes
 - implicit subject via `require 'maxitest/implicit_subject'`

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
