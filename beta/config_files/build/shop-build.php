<?php

include '/var/www/html/config/config.inc.php';

//
// Add one employee per installed language
//

echo PHP_EOL.'* Adding one employee per language...'.PHP_EOL;
foreach (Language::getLanguages() as $language)
{
    $employee = new Employee();
    $employee->id_profile = 1;
    $employee->email = 'demo'. $language['iso_code'] .'@prestashop.com';
    $employee->id_lang = $language['id_lang'];
    $employee->passwd = Tools::encrypt('prestashop_demo');
    $employee->active = 1;
    $employee->optin = 1;
    $employee->firstname = 'Demo';
    $employee->lastname = 'PrestaShop';
    $employee->stats_date_from = date('Y-m-d', strtotime('-1 month'));
    $employee->stats_date_to = date('Y-m-d');
    $employee->stats_compare_from = '0000-00-00';
    $employee->stats_compare_to = '0000-00-00';
    $employee->stats_compare_option = 1;
    $employee->bo_theme = 'default';
    $employee->bo_css = 'admin-theme.css';
    $employee->bo_width = 0;
    $employee->bo_menu = 1;
    $employee->default_tab = 1;
    $employee->last_passwd_gen = date('Y-m-d H:i:s');
    $employee->add();
}

//
// Enable URL Rewriting
//

echo PHP_EOL.'* Enable url rewriting...'.PHP_EOL;
Configuration::updateValue('PS_REWRITING_SETTINGS', 1);
