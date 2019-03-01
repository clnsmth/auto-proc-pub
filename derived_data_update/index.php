<?php // index.php

#$filename = '/var/www/lter/sites/default/files/data/edi/tests/edi_253/data/taxa_counts_qcd.csv';
#$dirname = '/var/www/lter/sites/default/files/data/edi/tests/php_directed/taxa_counts_qcd.csv';

if (file_exists('taxa_counts_qcd.csv')) {
	echo 'The file exists';
} else {
	echo 'The file does not exist';
}

copy('taxa_counts_qcd.csv', 'test.csv') or die('Could not copy');
echo 'File succesfully copied';
#shell_exec('cp $filename $dirname');


#if (file_exists('/var/www/lter/sites/default/files/data/edi/tests/php_directed')) {
#	echo 'The destination directory exists';
#} else {
#	echo 'The destination directory does not exist';
#}


?>
