Simonyi címtár
==============

Simonyi Károly Szakkollégium tagokat és beszámolókat nyilvántartó rendszere

Fejlesztői környezet összeállítása
----------------------------------

1. szerezz Ruby-t: [hivatalos oldal](http://www.ruby-lang.org/en/)

    Érdemes valami ruby menedzselő környezetet szerezni.
    pl [rvm](https://rvm.io/) vagy [chruby](https://github.com/postmodern/chruby)

2. legyen bundler a gépen
        
        $ gem install bundler

3. szükséges függőségek telepítése

        # csak azokat telepítsd, amikre a fejlesztéshez szükség van
        $ bundle install --without production

4. `$ rails server`

5. profit

Tesztek futtatása
-----------------

A [spork](https://github.com/sporkrb/spork) gemet használjuk,
hogy a tesztelés során felgyorsítsuk az alkalmazás betöltődését.
A spork szervert indítsuk el a `$ spork` paranccsal.

unit testek futtatása:

    $ rake test:units

unit testek futtatása a spork megkerülésével

    $ rake test:units withoutspork=true

**FONTOS**: nem minden fájl töltődik újra a teszt futtatások között.
pl a test_helper.rb változtatása esetén újra kell indítani a spork szervert.