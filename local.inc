<?php

$codendi_dir = '/usr/share/tuleap';
$tuleap_dir  = $codendi_dir;
$sys_custom_dir = "/etc/tuleap";
$db_config_file = $sys_custom_dir . "/conf/database.inc";
$sys_data_dir = "/var/lib/tuleap";
$codendi_cache_dir = '/var/tmp/tuleap_cache';
$sys_themeroot = $codendi_dir . '/src/www/themes';
$sys_custompluginsroot = $sys_custom_dir . "/plugins/";
$sys_incdir = $codendi_dir . '/site-content';
$sys_pluginsroot = $codendi_dir . '/plugins';
$sys_pluginspath = '/plugins';
$sys_custompluginspath = '/custom/plugins';
$htmlpurifier_dir = '/usr/share/htmlpurifier';
$jpgraph_dir = '/usr/share/jpgraph';
$sys_combined_dir = $codendi_cache_dir . '/combined';
$sys_custom_incdir = $sys_custom_dir . '/site-content';
$sys_custom_themeroot = $sys_custom_dir . "/themes";
$codendi_utils_prefix         = "/usr/share/tuleap/src/utils";
$tmp_dir = "/var/tmp";
$codendi_log        = "/var/log/tuleap";
$codendi_bin_prefix = "/usr/lib/tuleap/bin";
$sys_email_admin = 'root@localhost';
$sys_lf = "\n";

//NSCD
$unix_uid_add	= "20000";
$unix_gid_add	= "1000";
$sys_http_user  = "apache";
$sys_dbauth_user   = "dbauthuser";
$sys_dbauth_passwd = 'welcome0';

$sys_name = 'Tuleap Tests';
$sys_org_name = 'Tuleap';
$sys_cookie_prefix = 'TLP';
$sys_themedefault = 'Tuleap';
$sys_force_ssl  = 0;
$sys_password_lifetime = 10000000000000;
$sys_news_group = 46;

$sys_noreply = 'noreply@localhost';
$sys_default_domain = 'localhost';

$sys_lang = 'en_US';
$sys_supported_languages = 'en_US';

$sys_logger_level = 'debug';

$sys_rest_api_over_http = 0;

$DEBUG_MODE = 1;
