# Ruby port of Nyancat CLI

A Ruby port of the original nyancat CLI by [Kevin Lange](https://github.com/klange/nyancat). Currently only supports xterm 256-color compatible terminals, likely doesn't work on Windows and lacks any finese or optimisation.

    $ gem install nyancat
    $ nyancat

For options, see --help

    $ nyancat --help
    Usage: nyancat [options]
    -s, --silent                     Don't play audio
    -f, --flavour FLAVOUR            Available flavours: original
    -t, --notime                     Don't show the time nyaned
    -l, --listen [PORT]              Run telnet server on PORT (default 21)

## Audio 

Very basic audio support is provided by using [mpg123](http://www.mpg123.de/). You'll need mpg123 installed and in your $PATH for audio to work.

## Telnet server

If run with `-l` or `--listen` and an optional port argument, a simple socket server will be started. The server will render a loop of the 'original' animation to connected clients using ANSI escaped text until any input from the client is received, upon which the connection is closed. The server does not currently implement the telnet protocol and simply spews ANSI text to the client. A proper telnet implementation is planned for the future.

Clients can connect to the server with a telnet client, though only xterm 256-color compatible terminals are supported.

	$ telnet nyan.andatche.com 21

## Licenses, References, etc.

The original source of the Nyancat animation is [prguitarman](http://www.prguitarman.com/index.php?id=348).

Original video: http://www.youtube.com/watch?v=QH2-TGUlwu4
Original Song: http://momolabo.lolipop.jp/nyancatsong/Nyan/

The code provided here is provided under the terms of the [NCSA license](http://en.wikipedia.org/wiki/University_of_Illinois/NCSA_Open_Source_License).
