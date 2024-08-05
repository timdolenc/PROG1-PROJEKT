# Mealyjevi avtomati

Projekt vsebuje implementacijo Mealyjevega avtomata in njegovo aplikacijo na preprost sprehod po dvodimenzionalni mreži, kjer je izhod smer neba. 

Mealyjev avtomat začne v enem izmed možnih stanj, nato pa glede na trenutno stanje in trenutni vhod preide v neko novo stanje in ob tem sproducira nek izhod. Če ob pregledu celotnega niza konča v enem od sprejemnih stanj, je z nizom ukazov uporabnik uspešno prišel na cilj, sicer neuspešno.

Avtomat se implementira na primeru sprehoda po dvodimenzionalni mreži, kjer se uporabnik z nizom ukazov sestavljenim iz "N" (naredi en korak naprejnaprej), "D" (na mestu se obrni na desno) in "L" (na mestu se obrni na levo) poskuša prebiti do cilja, ki se nahaja v zgornji desni točki mreže (max_x, max_y). Slednje koordinate ima uporabnik možnost spreminjati, začetno stanje (točka $(0,0)$ in obrnjenost na sever) pa je fiksno. Izhod avtomata je smer neba, proti kateri smo obrnjeni.


## Definicija Mealyjevega avtomata

Mealyjev avtomat je nabor $(\Sigma, Q, q_0, F, \delta, \lambda, \Gamma)$, kjer so:

- $\Sigma$ množica simbolov oz. abeceda,
- $Q$ množica stanj,
- $q_0 \in Q$ začetno stanje,
- $F \subseteq Q$ množica sprejemnih stanj in
- $\delta : Q \times \Sigma \to Q$ prehodna funkcija.
- $\lambda : Q \times \Sigma \to \Gamma$ izhodna funkcija
- $\Gamma$ množica izhodov


## Navodila za uporabo
Tekstovni vmesnik zaženemo z vnosom naslednjih korakov v terminal:
1) cd pot_do_projekta
2) dune build
3) dune exec ./tekstovniVmesnik.exe 



### Tekstovni vmesnik
Tekstovni vmesnik ob zagonu uporabniku ponuja štiri možnosti:
1) izpiši stanja avtomata - ta možnost ponudi pregled nas vsemi stanji avtomata. Pri tem začetno stanje označi z "->", sprejemna stanja pa z "+".
2) začni sprehod - ta možnost uporabnika pozove k vnosu niza ukazov sestavljenim iz "N", "D" in "L", ki jih bo obravnaval.
3) nastavi na začetno stanje - vrne avtomat v začetno stanje (S, 0, 0)
4) nastavi dimenzije mreže - Možnost spreminjanja max_x in max_y.

   



### Spletni vmesnik

TODO

## Implementacija

### Struktura datotek

Projekt je organiziran v naslednje mape in datoteke:

- `src/definicije/`
  - `avtomat.ml`: Implementacija Mealyjevega avtomata.
  - `avtomat.mli`: Vmesnik za Mealyjev avtomat.
  - `stanje.ml`: Implementacija stanj.
  - `stanje.mli`: Vmesnik za stanja.
- `src/tekstovniVmesnik/`
  - `tekstovniVmesnik.ml`: Implementacija tekstovnega vmesnika.

### `avtomat.ml`

Datoteka `avtomat.ml` vsebuje implementacijo Mealyjevega avtomata, vključno s prehodno in izhodno funkcijo. Avtomat je definiran z naslednjimi tipi in funkcijami:

- `type t`: Tip, ki predstavlja avtomat.
- `prazen_avtomat`: Funkcija za ustvarjanje praznega avtomata.
- `dodaj_nesprejemno_stanje`: Funkcija za dodajanje nesprejemnega stanja.
- `dodaj_sprejemno_stanje`: Funkcija za dodajanje sprejemnega stanja.
- `dodaj_prehod`: Funkcija za dodajanje prehoda med stanji.
- `prehodna_funkcija`: Funkcija, ki določa prehod med stanji glede na vhod.
- `zacetno_stanje`: Funkcija za pridobivanje začetnega stanja.
- `seznam_stanj`: Funkcija za pridobivanje seznama vseh stanj.
- `seznam_prehodov`: Funkcija za pridobivanje seznama vseh prehodov.
- `je_sprejemno_stanje`: Funkcija za preverjanje, ali je stanje sprejemno.
- `premik_na_koordinate`: Funkcija za ustvarjanje avtomata za premikanje po koordinatnem sistemu.
- `generiraj_vsa_stanja`: Funkcija za generiranje vseh možnih stanj na mreži.
- `generiraj_vse_prehode`: Funkcija za generiranje vseh možnih prehodov.


### `stanje.ml`

Datoteka `stanje.ml` vsebuje definicijo tipa stanja in funkcije za delo s stanji, ki vključujejo smer neba in koordinate na dvodimenzionalni mreži.

- `type smer_neba`: Definicija tipa za smer neba (S, J, V, Z).
- `type t`: Definicija tipa stanja, ki vsebuje smer neba, x in y koordinate.
- `iz_komponent`: Funkcija za ustvarjanje stanja iz posameznih komponent (smer, x, y).
- `iz_niza`: Funkcija za ustvarjanje stanja iz niza v obliki "smer,x,y".
- `v_niz`: Funkcija za pretvorbo stanja v niz v obliki "smer,x,y".
- `smer`: Funkcija, ki vrne smer stanja.
- `koordinate`: Funkcija, ki vrne koordinate stanja.

### `tekstovniVmesnik.ml`

Datoteka `tekstovniVmesnik.ml` vsebuje implementacijo tekstovnega vmesnika za interakcijo z avtomatom. Vključuje funkcije za izpis možnosti, izpis avtomata, branje niza ukazov, izpis rezultata, nastavitev dimenzij mreže, in glavno zanko vmesnika.

- `type stanje_vmesnika`: Definicija možnih stanj vmesnika.
- `type model`: Definicija modela, ki vsebuje avtomat, trenutno stanje avtomata, trenutno stanje vmesnika, ter dimenzije mreže.
- `type msg`: Definicija sporočil, ki jih vmesnik uporablja za posodobitev stanja.
- `preberi_niz`: Funkcija za branje niza ukazov in izvajanje prehodov.
- `update`: Funkcija za posodobitev modela glede na prejeto sporočilo.
- `izpisi_moznosti`: Funkcija za izpis možnosti vmesnika.
- `izpisi_avtomat`: Funkcija za izpis stanj avtomata.
- `beri_niz`: Funkcija za branje niza ukazov od uporabnika.
- `izpisi_rezultat`: Funkcija za izpis rezultata po branju niza.
- `nastavi_dimenzije`: Funkcija za nastavitev dimenzij mreže.
- `view`: Funkcija za upravljanje pogleda vmesnika.
- `init`: Funkcija za inicializacijo modela.
- `loop`: Glavna zanka vmesnika.

