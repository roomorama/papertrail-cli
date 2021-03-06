# papertrail Command-line tail & search client for Papertrail log management service

Small standalone [binary] to retrieve, search, and tail recent app
server log and system syslog messages from [Papertrail].

Supports optional Boolean search queries and polling for new events
(like "tail -f").  Example:

    papertrail -f "(www OR db) (nginx OR pgsql) -accepted"

Output is line-buffered so it can be fed into a pipe, like for grep.

The [SearchClient] class can be used by other apps to perform one-off
API searches or follow (tail) events matching a given query. Interface
may change.


## Quickstart

    $ [sudo] gem install papertrail-cli
    $ echo "username: your@account.com\npassword: yourpass" > ~/.papertrail.yml
    $ papertrail


## Installation

Install the gem ([RubyGems]), which includes a binary called "papertrail":

   $ [sudo] gem install papertrail-cli


## Configuration

Create ~/.papertrail.yml containing your credentials, or specify the
path to that file with -c. Example (from
examples/papertrail.yml.example):
    username: your@account.com
    password: yourpassword

You may want to alias "trail" to "papertrail", like:
    echo "alias trail=papertrail" >> ~/.bashrc


## Usage & Examples

    $ papertrail -h
    papertrail - command-line tail and search for Papertrail log management service
        -h, --help                       Show usage
        -f, --follow                     Continue running and print new events (off)
        -d, --delay SECONDS              Delay between refresh (30)
        -c, --configfile PATH            Path to config (~/.papertrail.yml)

    Usage: papertrail [-f] [-d seconds] [-c /path/to/papertrail.yml] [query]

    Examples:
      papertrail -f
      papertrail something
      papertrail 1.2.3 Failure
      papertrail -f "(www OR db) (nginx OR pgsql) -accepted"
      papertrail -f -d 10 "ns1 OR 'connection refused'"

    More: http://papertrailapp.com/


## Colorize

Pipe through [MultiTail] or [colortail]. For example:
    $ papertrail | multitail -c -j

For complete control, pipe through anything capable of inserting ANSI
control characters. Here's an example that colorizes 3 fields separately
- the first 15 characters for the date, a word for the hostname, and a
word for the program name:

    $ papertrail | perl -pe 's/^(.{15})(.)([\S]+)(.)([\S]+)/\e[1;31;43m\1\e[0m\2\e[1;31;43m\3\e[0m\4\e[1;31;43m\5\e[0m/g'

the "1;31;43" are bold (1), foreground red (31), background yellow (43),
and can be any ANSI [escape characters].


## Contribute

Bug report:

1. See whether the issue has already been reported:
   http://github.com/papertrail/papertrail-cli/issues/
2. If you don't find one, create an issue with a repro case.

Enhancement or fix:

1. Fork the project:
   http://github.com/papertrail/papertrail-cli
2. Make your changes with tests.
3. Commit the changes without changing the Rakefile or other files unrelated 
to your enhancement.
4. Send a pull request.

[binary]: https://github.com/papertrail/papertrail-cli/blob/master/bin/papertrail
[Papertrail]: http://papertrailapp.com/
[SearchClient]: https://github.com/papertrail/papertrail-cli/blob/master/lib/papertrail/search_client.rb
[RubyGems]: https://rubygems.org/gems/papertrail-cli
[MultiTail]: http://www.vanheusden.com/multitail/index.html
[colortail]: http://www.codaset.com/elubow/colortail
[escape characters]: http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
