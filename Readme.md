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
 - let!
 - multiple before & after blocks
 - around
 - Ctrl+c to stop tests and print output
 - print copy pastable rerun instructions on failure
 - colors by default
 - `mtest` executable to run test by line number and by folder
 - `order_dependent!` to make your tests run in given order

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/maxitest.png)](https://travis-ci.org/grosser/maxitest)
