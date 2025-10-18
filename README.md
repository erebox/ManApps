# ManApps
Gestore grafico di collegamenti (“junctions”) tra directory su Windows, per passare rapidamente da una versione all’altra di più applicazioni o librerie in modo centralizzato.

## Scopo
Il programma legge un file di configurazione JSON (ManApps.json) che descrive varie applicazioni o componenti gestiti.  
Per ciascuno mostra una riga con il nome dell'applicazione, una ComboBox con un elenco di versioni disponibili ed un pulsante "Applica".  
Quando viene premuto Applica, crea una junction (collegamento simbolico / directory link) in Windows che punta alla versione selezionata.  
Inoltre salva le scelte correnti in un altro file JSON (ManApps.state.json) per ripristinarle al successivo avvio.  

- __"link"__ è la directory che viene creata da applica.  
- __"dir"__ è la directory che contine le varie versioni dell'applicazione.  
- __"base"__ è l'inizio del nome della direcotry che contiene una versione e dev'essere comune a  tutte le versioni.  
- __"list"__ è l'elenco delle versioni disponibili.  

Esempio di file ManApps.json:  

```
	"Go": {
		"link": "go",
		"dir": "go-lst",
		"base": "go-",
		"list": ["1.23.2", "1.25.2"]
	},
	"Java": {
		"link": "java",
		"dir": "java-lst",
		"base": "java-",
		"list": ["8u441","11.0.26","17.0.14","21.0.7"]
	},
	"Node": {
		"link": "node",
		"dir": "node-lst",
		"base": "node-v",
		"list": ["20.19.5","22.20.0","24.9.0"]
	},
	"PHP": {
		"link": "php",
		"dir": "php-lst",
		"base": "php-",
		"list": ["8.1.32","8.2.28","8.3.21","8.4.7"]
	},
	...
```

## Compilazione
Per compilare il programma in Windows è stato utilizzato [w64devkit](https://github.com/skeeto/w64devkit).  

Prima di compilare è necessario avere tra i sorgenti il file [json.hpp](https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp) per la gestione dei JSON.  
Si possono usare i segunti comandi:  

    windres res\ManApps.rc -O coff -o obj\ManApps.o
    g++ -Wall -O2 -mwindows src\ManApps.cpp obj\ManApps.o -o bin\ManApps.exe

Oppure il classico makefile

    make

## Utilizzo
Si copia l'eseguibile nella direcotry principale dove sono presenti le directory che contengo le varie versioni.  
Si crea il file di configurazione (ManApps.json) dove sono censiti gli applicativi.  
Si esegue il programma per creare i collegamenti.  
Inserire i collegamenti nel proprio path secondo le varie modalità richieste dagli applicativi utilizzati.  

## Rigraziamenti
Un grazie a [Niels Lohmann](https://github.com/nlohmann) per aver fatto la libreria [JSON for Modern C++](https://github.com/nlohmann/json).  

E se ti è piaciuto questo repository [Offrimi un caffè virtuale](https://ko-fi.com/erebox_github).