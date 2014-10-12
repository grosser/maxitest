Full featured Minitest

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

Features
========
 - Ctrl+c stops tests and prints failures
 - print copy pastable rerun instructions on failure via [minitest-line](https://github.com/judofyr/minitest-line)
 - multiple before & after blocks
 - `around { |t| Dir.chdir(...) { t.call }` via [minitest-around](https://github.com/splattael/minitest-around)
 - colors by default via [minitest-rg](https://github.com/blowmage/minitest-rg)
 - `mtest` executable to run test by line number and by folder via [testrbl](https://github.com/grosser/testrbl)
 - `let!`
 - `order_dependent!` to make your tests run in given order
 - `context` for more expression

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
 - make ctrl+c fix it's own gem

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/maxitest.png)](https://travis-ci.org/grosser/maxitest)
