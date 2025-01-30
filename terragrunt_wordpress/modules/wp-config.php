<?php

$table_prefix = 'wp';

// ** MySQL settings - These should match your RDS details ** //
define( 'DB_NAME', 'mydatabaseDAD' );  
define( 'DB_USER', 'admin' );  
define( 'DB_PASSWORD', 'password123!' );  
define( 'DB_HOST', 'my-database-instance-dad.criuqg402mat.eu-west-3.rds.amazonaws.com' ); 


// ** Set memory limits, for example, 256MB ** //
define('WP_MEMORY_LIMIT', '256M');

// ** WordPress Database Charset and Collate type. ** //
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// ** WordPress URL Settings ** //
define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] );
define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] );

// ** Absolute path to the WordPress directory. ** //
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

// ** Sets up WordPress vars and included files. ** //
require_once(ABSPATH . 'wp-settings.php');
