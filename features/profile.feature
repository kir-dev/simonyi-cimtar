# Ha a rendszerben még nem létező profillal lépünk be
#   - helyi felhasználó létrehozódik
#   - minden adatom megjelenik
#   - később: körtagságaim beíródnak

Feature: Profiles of members
  In order to see data of people in the application
  As an SSO user with the right membership in VIR

# Saját profil megtekintése
#   - minden adatom megjelenik

# Más profil megtekintése
#   - adatok megjelennek
#   - csak a jogosultságnak megfelelő adatok látszódnak

# Saját profil szerkesztése
#   - a szerkesztett adat elmentődik
#   - átlag mentése - mellette látszik a legutóbbi frissítés időpontja
#   - social profil hozzáadása
#   - social profil törlése
#   - adat láthatóságának megváltoztatása

# Más profil szerkesztése felhasználóként (sikertelen)

# Más profil szerkesztése szuperadminként (sikeres)
#   - a szerkesztett adat elmentődik
#   - átlag mentése - mellette látszik a legutóbbi frissítés időpontja
#   - social profil törlése

# Követelmények változása az aktívság megállapításához
# 3 követelmény: átlag (számolt), közösség, szakma (kettőnek kell teljesülnie -> aktív)

# Egyik követelmény sem teljesül (inaktív)

# Teljesül: átlag (inaktív)

# Teljesül: közösség (inaktív)

# Teljesül: szakma (inaktív)

# Teljesül: átlag és közösség (aktív)

# Teljesül: átlag és szakma (aktív)

# Teljesül: közösség és szakma (aktív)

# Felhasználó törlése felhasználóként (sikertelen)

# Felhasználó törlése adminként (sikeres)