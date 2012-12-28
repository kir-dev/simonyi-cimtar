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