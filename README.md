Simonyi címtár
==============

Simonyi Károly Szakkollégium tagokat és beszámolókat nyilvántartó rendszere

[![Build Status](https://travis-ci.org/kir-dev/simonyi-cimtar.png?branch=master)](https://travis-ci.org/kir-dev/simonyi-cimtar)

Fejlesztői környezet összeállítása
----------------------------------

1. szerezz Ruby-t: [hivatalos oldal](http://www.ruby-lang.org/en/)

    Érdemes valami ruby menedzselő környezetet szerezni.
    pl [rvm](https://rvm.io/) vagy [chruby](https://github.com/postmodern/chruby)

2. legyen bundler a gépen
        
        $ gem install bundler

3. szükséges függőségek telepítése

        $ # csak azokat telepítsd, amikre a fejlesztéshez szükség van
        $ bundle install --without production migration

    TODO: virdb setuphoz utasítások. PÉK idevonatkozó doksiját linkelni

    Ha virdb-ből is szeretnél usereket importálni, akkor telepítsd a
    következő csomagokat és a migration csoportot is:

        $ sudo apt-get install libldap2-dev libsasl2-dev
        $ bundle install --without production
        

4. hozzd létre az adatbázist

        $ # legyen configurációs fájlod
        $ cp config/database.yml.sqlite-example config/database.yml
        $ rake db:migrate   # hozd letre az adatbazist
        $ rake db:seed      # legyen par teszt adatod is

5. futtasd le a teszteket
    
        $ rake db:test:prepare
        $ rake test

6. `$ rails server`

7. profit

Deploy
------

_TODO: utasitasok elesiteshez_

Éles telepítéskor mindenképp:

    # a config/initializers/secret_token.rb fájlban lévőt lecserélni ennek a kimenetére:
    $ rake secret


Tesztek futtatása
-----------------

A [spork](https://github.com/sporkrb/spork) gemet használjuk,
hogy a tesztelés során felgyorsítsuk az alkalmazás betöltődését.
A spork szervert indítsuk el a `$ spork` paranccsal.

A tesztek futtatásához használjuk a `testdrb` parancsot:

    # unit tesztek futtatása
    $ testdrb -Itest test/unit/*.rb

A sporkot megkerülni a `rake test` és társai segítségével lehet. Például

    # unit tesztek futtatása spork nélkül
    $ rake test:units

**FONTOS**: nem minden fájl töltődik újra a teszt futtatások között.
pl a test_helper.rb változtatása esetén újra kell indítani a spork szervert.
