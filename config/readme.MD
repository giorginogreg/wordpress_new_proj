### Configurazione settings wp

#### wp-config.php

Scarica il [wp-config-sample.php](/wp-config-sample.php) nella root del sito, rinominandolo in _wp-config.php_

Una volta rinominato il file, bisogna modificare gli _environments_, commentando nell'array quelli non necessari.

###### _(Opzionale)_
Aggiungere eventuali parametri globali per ogni environment. Ad esempio è possibile aggiungere il prefisso delle tabelle
```
$table_prefix = 'wp_';

```

Per poter utilizzare configurazioni diverse per ogni ambiente, bisognerà creare i rispettivi file di configurazione.

Copiare quindi la cartella _wp-config/_ all'interno della root.
All'interno è possibile trovare i vari file di configurazione per ogni ambiente.

Sarà necessario un solo file corrispondente all'ambiente di lavoro attuale.

E.G. (environment = sviluppo)
* Copiare il file _'wp-db-{environment}.php'_, assicurandosi che {environment} coincida con quello specificato all'interno del wp-config.
* Al suo interno inserire le credenziali per l'ambiente, e generare le chiavi univoche per ogni ambiente recandosi sul [sito](https://api.wordpress.org/secret-key/1.1/salt/) di WordPress apposito.


###### _(Opzionale)_

Inserire eventuali variabili necessarie per il solo ambiente di lavoro.
