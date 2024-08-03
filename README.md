# Mealyjevi avtomati

Projekt vsebuje implementacijo Mealyjevega avtomata in njegovo aplikacijo na preprost sprehod po dvodimenzionalni mreži, kjer je izhod smer neba. 

Mealyjev avtomat začne v enem izmed možnih stanj, nato pa glede na trenutno stanje in trenutni vhod preide v neko novo stanje in ob tem sproducira nek izhod. Če ob pregledu celotnega niza konča v enem od sprejemnih stanj, je z nizom ukazov uporabnik uspešno prišel na cilj, sicer neuspešno.

Avtomat se implementira na primeru sprehoda po dvodimenzionalni mreži, kjer se uporabnik z nizom ukazov sestavljenim iz "N" (naredi en korak naprejnaprej), "D" (na mestu se obrni na desno) in "L" (na mestu se obrni na levo) poskuša prebiti do cilja, ki se nahaja v zgornji desni točki mreže (max_x, max_y). Slednje koordinate ima uporabnik možnost spreminjati, začetno stanje, pa je toča $(0,0)$ in obrnjenost na sever. Izhod avtomata je smer neba, proti kateri smo obrnjeni.


## Definicija Mealyjevega avtomata

Mealyjev avtomat je nabor $(\Sigma, Q, q_0, F, \delta)$, kjer so:

- $\Sigma$ množica simbolov oz. abeceda,
- $Q$ množica stanj,
- $q_0 \in Q$ začetno stanje,
- $F \subseteq Q$ množica sprejemnih stanj in
- $\delta : Q \times \Sigma \to Q$ prehodna funkcija.
- $\lambda : Q \times \Sigma \to \Gamma$ izhodna funkcija
- $\Gamma$ množica izhodov


## Navodila za uporabo
Tekstovni vmesnik zaženemo z vnosom naslednjih korakov v terminal:
#1. cd pot_do_projekta
#2. dune build
#3. dune exec ./tekstovniVmesnik.exe 


Če OCamla nimate nameščenega, lahko še vedno preizkusite tekstovni vmesnik prek ene od spletnih implementacij OCamla, najbolje <http://ocaml.besson.link/>, ki podpira branje s konzole. V tem primeru si na vrh datoteke `tekstovniVmesnik.ml` dodajte še vrstice

```ocaml
module Avtomat = struct
    (* celotna vsebina datoteke avtomat.ml *)
end
```

### Tekstovni vmesnik
Tekstovni vmesnik ob zagonu uporabniku ponuja štiri možnosti:
1) izpiši stanja avtomata - ta možnost ponudi pregled nas vsemi stanji avtomata. Pri tem začetno stanje označi z "->", sprejemna stanja pa z "+".
2) začni sprehod - ta možnost uporabnika pozove k vnosu niza ukazov sestavljenim iz "N", "D" in "L", ki jih bo obravnaval.
3) nastavi na začetno stanje 
4) nastavi dimenzije mreže



### Spletni vmesnik

TODO

## Implementacija

### Struktura datotek

TODO

### `avtomat.ml`

TODO

### `model.ml`

TODO
