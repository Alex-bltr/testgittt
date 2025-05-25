<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wpmaindb' );

/** Database username */
define( 'DB_USER', 'wpusr' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '372KaXpwjP||~E(u[|{sw4sQU}O ]eQj16oi99k}~C3W=DZV]h|@&mF+}runcaS/' );
define( 'SECURE_AUTH_KEY',  '4GS%W.:2#GyjhR)(f3z=>C| !ecA:?&)6c%Ne5RRrN<QO(gPv5#]KAD .0&:z7zW' );
define( 'LOGGED_IN_KEY',    'Kg{.WOiT2oI9OxM7?dE#c]*}_2=[2pF@q}mBqDJ>nl/g_)-iVlk->torH9J>E>` ' );
define( 'NONCE_KEY',        'zALe*,lV3A>[IjSht`~2{SXx{|yb[Xj<yp;#LTm9Qc[WYMN95^-XKg2kg.;N[:zh' );
define( 'AUTH_SALT',        '=m<*g}K.S0{6C+;V|B{Jpn^Xa35Z}E&_YfS66gY*T>|?9e3jO;Sx3e_4NO=L#3Y2' );
define( 'SECURE_AUTH_SALT', 'h)S/#P3UYskG8r<txqJn;n;Le]f2f!=Ka]mAxG}ipDl@C4]hc[}?aYRmc,:T78vM' );
define( 'LOGGED_IN_SALT',   'ZFs6%4ZpmoVE tuLKQgKfF9H[N_ V~k4pW{Yn3l:T=acK,zB)7T/(N+vEoPmet+_' );
define( 'NONCE_SALT',       'X`rp8(--x}(67U:B_%Ew|h,(PKY54B8-x9Q)wYIt.4NVIbEsaVS7fdFd=t5fP:K]' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';