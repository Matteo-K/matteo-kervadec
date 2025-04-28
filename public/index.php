<?php

// use App\Kernel;

// require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

// return function (array $context) {
//     return new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
// };


// Affichage d'une liste des fichiers et répertoires dans le projet
echo "<h1>Liste des fichiers du projet</h1>";
echo "<pre>";

$dir = '/var/www/html'; // Le répertoire racine de ton projet dans le conteneur
$files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir));

foreach ($files as $file) {
    if (!$file->isDir()) {
        echo $file->getRealPath() . "<br>";
    }
}

echo "</pre>";
?>
