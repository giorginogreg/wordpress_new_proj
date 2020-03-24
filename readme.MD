# Prerequisiti:
### Ambiente di sviluppo

+ Development server (solitamente il computer locale)
+ Staging server (server di collaudo)
+ Production server (server di produzione)

_Consigliato:_   
Lo staging server deve avere caratteristiche simili se non identiche al server di produzione (per lo meno per quanto riguarda la versione di __PHP__).


# Passaggio di un sito da produzione a locale

Quando passiamo un sito da produzione, dobbiamo fare attenzione alle seguenti operazioni.

#### Database

Una volta esportato il db da ambiente di produzione
dobbiamo effettuare le seguenti query:

__N.B.__ Ci sono da sostituire le seguenti variabili:
1. {PRODUCTION_SITE} -> sito in produzione. Se non sei sicuro, controlla il precedente parametro nella tabella {PREFISSO TABELLE}options, dove l'option_name è = 'home'
1. {DEV_SITE} -> Host utilizzato (di solito 127.0.0.1/{cartella} __senza / (slash)__ finale )

 ```
UPDATE ses_posts SET guid = REPLACE(guid, '{PRODUCTION_SITE}', '{DEV_SITE}');
UPDATE ses_options SET option_value = replace(option_value, '{PRODUCTION_SITE}', '{DEV_SITE}') WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE ses_posts SET post_content = replace(post_content, '{PRODUCTION_SITE}', '{DEV_SITE}');
UPDATE ses_postmeta SET meta_value = replace(meta_value,'{PRODUCTION_SITE}','{DEV_SITE}');

 ```

---

#### Wp-config

---

#### .htaccess

Il file __non__ deve essere aggiunto alla repository perchè potrebbe subire modifiche durante l'utilizzo di WP.

In ambiente locale è possibile utilizzare l'htaccess di esempio nella cartella __*/htaccess/.htaccess.sample*__

Esso contiene una riga utile per utilizzare tutti i contenuti della cartella wp-content/* prendendoli da produzione.

## Nota Bene!
Se si utilizza un htaccess fornito dagli esempi su internet, modificare i parametri di esempio come quanto segue:

```
# BEGIN WordPress

RewriteEngine On
RewriteBase /{path_progetto/}
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /{path_progetto/}index.php [L]

# END WordPress
```

La variabile {path_progetto/} risulterà vuota se il progetto è __direttamente__ sotto la root del webserver (es. su windows abbiamo wamp64/www/{root_webserver} se usiamo wamp come webserver, oppure xampp/htdocs/{root_webserver}), altrimenti se nella root abbiamo una o più cartelle innestate, tutte quelle cartelle rappresenteranno la variabile.

Ricordarsi di mettere uno slash finale.

---

## Se il sito in produzione non è su git

# Pensa, ricontrolla mille volte prima di fare il first commit, tutti i file errati che verranno inseriti appesantiranno la repository inutilmente!

Effettua prima un backup di tutto il file system, e di tutto il database.

E' consigliato clonare il progetto e testare le modifiche in locale, prima di metterle in produzione.

* #### Inizializzare repository sul sito in produzione
 (_git_ deve essere stato già installato)
```
git init
```
* #### .gitignore
  Creare il file .gitignore, e aggiungere sotto forma di espressioni regolari le cartelle di cui non è necessario mantenere il tracciamento (es. vedi foto -- NON ICONE o img necessarie -- , file binari, eseguibili, mp3, dati ecc.)

  Come file di base, è possibile utilizzare il .gitignore.sample all'interno della cartella _/gitignore_, rinominandolo in _.gitignore_.

  Spesso si vengono a creare dei file pesanti che non dovrebbero essere utili. Per un check di questi, possiamo lanciare da shell ssh sul server questo comando (dopo esserci portati nella root del file system -- solitamente in /var/www/html):

   ```
find . -type f -size +2M \( ! -iname "*.php" ! -iname "*.js" ! -iname "*.css" ! -iname "*.html" \);
   ```  

   Questo comando trova nella cartella attuale e nelle sottocartelle i file più grandi di 2M.

   Questo comando invece esclude dalla ricerca i file php, js ecc.

   Una volta individuati i file da voler mantenere o ignorare nel primo commit, li aggiungiamo al .gitignore utilizzato di default.


* #### Git add

  __Solo quando si è sicuri di tutti i file che verranno aggiunti alla repository__ (e che quindi verranno presi da altre persone) lanciare il seguente comando per trasferire tutti i file ad eccezione di quelli nel gitignore nella staging area.

   ```
  cd {root fs} && git add .
   ```

* #### Pushare la repo in remoto

  Creare repository git remota su github (se non esistente) con account aziendale (vedi grifo server per credenziali)
