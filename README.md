# ManApps
Gestore grafico di collegamenti (“junctions”) tra directory su Windows, per passare rapidamente da una versione all’altra di più applicazioni o librerie in modo centralizzato.

## Scopo
Il programma legge un file di configurazione  (ManApps.cfg) che descrive varie applicazioni o componenti gestiti.  
Per ciascuno mostra una riga con il nome dell'applicazione, una ComboBox con un elenco di versioni disponibili ed un pulsante "Applica".  
Quando viene premuto Applica, crea una junction (collegamento simbolico / directory link) in Windows che punta alla versione selezionata.  
Inoltre salva le scelte correnti in un altro file (ManApps.ini) per ripristinarle al successivo avvio.  

## Configurazione
Ogni riga del file di configurazione rappresenta un applicativo __APP__:  
- dopo __":"__ __LINK__ è la directory che viene creata quando si preme il pulsante Applica.  
- dopo __">"__ __DIR__ è la directory che contiene le varie versioni dell'applicazione.  
- Dopo __"*"__  __BASE__ è l'inizio del nome della direcotry che contiene una versione e dev'essere comune a tutte le versioni.  
- Dopo la __"@"__ separate da  __"|"__ le versioni disponibili.  

Una riga che inizia con __"#"__ viene ignorata e considerata come commento.  

Esempio di file ManApps.cfg:  

```
#APP   : LINK   > DIR        * BASE          @ v1 | v1 | v3
Git    : git    > git-lst    * git-          @ 2.39.1 | 2.51.0.2
Go     : go     > go-lst     * go-           @ 1.23.2 | 1.24.1 | 1.25.2
...
...
```

## Compilazione
Per compilare il programma in Windows è stato utilizzato [w64devkit](https://github.com/skeeto/w64devkit).  

Si possono usare i segunti comandi:  

    windres res\ManApps.rc -O coff -o ManApps.o
    g++ -Wall -O2 -mwindows src\ManApps.cpp ManApps.o -o ManApps.exe

Oppure il classico makefile

    make

## Utilizzo
Si copia l'eseguibile nella direcotry principale dove sono presenti le directory che contengo le varie versioni.  
Si crea il file di configurazione (ManApps.cfg) dove sono censiti gli applicativi.  
Si esegue il programma per creare i collegamenti.  
Inserire i collegamenti nel proprio path secondo le varie modalità richieste dagli applicativi utilizzati.  

## Rigraziamenti
Se ti è piaciuto questo repository: [offrimi un caffè virtuale](https://ko-fi.com/erebox_github).