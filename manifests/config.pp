class dokuwiki::config {

  $web_root = $::dokuwiki::params::web_root
  $dat_root = $::dokuwiki::params::dat_root
  $conf_dir = "${dat_root}/conf"
  $data_dir = "${dat_root}/data"
  $doku_user = $::dokuwiki::params::doku_user

  # DokuWiki Config Options
  $conf_title = $::dokuwiki::params::conf_title
  $conf_lang = $::dokuwiki::params::conf_lang
  $conf_license = $::dokuwiki::params::conf_license
  $conf_useacl = $::dokuwiki::params::conf_useacl
  $conf_authtype = $::dokuwiki::params::conf_authtype
  $conf_superuser = $::dokuwiki::params::conf_superuser
  $conf_disableactions = $::dokuwiki::params::conf_disableactions
  $conf_users = $::dokuwiki::params::conf_users


  # Manage the Preload file
  # This configures where the /conf dir is
  file { "${web_root}/inc/preload.php":
    ensure  => file,
    content => epp('dokuwiki/preload.php.epp', {'conf_dir' => $conf_dir}),
    owner   => $doku_user,
    group   => $doku_user,
    mode    => '0664',
  }

  # Manage the Local file
  # This is the primary config file for DokuWiki
  file { "${dat_root}/conf/local.php":
    ensure  => file,
    content => template('dokuwiki/local.php.erb'),
    owner   => $doku_user,
    group   => $doku_user,
    mode    => '0640',
  }
  
  # Manage the Auth file
  # This is the defaul authentication meathod
  file { "${dat_root}/conf/users.auth.php":
    ensure  => file,
    content => epp('dokuwiki/users.auth.php.epp', {'conf_users' => $conf_users}),
    owner   => $doku_user,
    group   => $doku_user,
    mode    => '0640',
  }
}
