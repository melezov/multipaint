<?php

define('BASE_DIR', __DIR__.'/../../../src/client/php');
define('APP_DIR', __DIR__.'/../app');

function accept($dir, $file) {
    switch ($file) {
        case 'composer.json':
        case 'composer.lock':
        return false;
    }

    if ($file[0] === '.')
        return false;

    if (substr_compare($file, '.log', -4) === 0)
        return false;

    return $dir.DIRECTORY_SEPARATOR.$file;
}

function listFiles($base) {
    $base = realpath($base);
    $length = strlen($base);

    $files = array();
    $dirs = array($base);

    while (($current = array_shift($dirs)) !== null) {
        $tmp_files = array();
        $tmp_dirs = array();

        $dir = opendir($current);
        while (($file = readdir($dir)) !== false) {
            if ($file === '.' || $file === '..') continue;
            if (($path = accept($current, $file)) === false) {
                $path = $current.DIRECTORY_SEPARATOR.$file;
                echo "Skipping $path ...".PHP_EOL;
                continue;
            }

            if (is_dir($path)) {
                $tmp_dirs[] = $path;
            } else {
                if (strncmp($path, $base, $length) !== 0)
                    throw new Exception("Path '$path' does not start with '$base'");
                $rel = substr($path, $length + 1);
                $tmp_files[$rel] = $path;
            }
        }
        closedir($dir);

        ksort($tmp_files);
        $files += $tmp_files;

        sort($tmp_dirs);
        $dirs = array_merge($dirs, $tmp_dirs);
    }

    return $files;
}

$phar = new Phar(APP_DIR.'/client.phar');
$phar->setStub('<?php __HALT_COMPILER();');

$files = listFiles(BASE_DIR);
foreach($files as $name => $path) {
    $phar[$name] = file_get_contents($path);
}

exit(0);
