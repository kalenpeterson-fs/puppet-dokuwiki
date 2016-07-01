class dokuwiki::config ( 
  $web_root             = $::dokuwiki::params::web_root,
  $dat_root             = $::dokuwiki::params::dat_root,
  $user                 = $::dokuwiki::params::user,
  $group                = $::dokuwiki::params::group,
  $conf_title           = undef,
  $conf_lang            = $::dokuwiki::params::conf_lang,
  $conf_license         = $::dokuwiki::params::conf_license,
  $conf_useacl          = $::dokuwiki::params::conf_useacl,
  $conf_authtype        = $::dokuwiki::params::conf_authtype,
  $conf_superuser       = $::dokuwiki::params::conf_superuser,
  $conf_disableactions  = $::dokuwiki::params::conf_disableactions,
  $conf_users           = $::dokuwiki::params::conf_users,
  $conf_acl             = $::dokuwiki::params::conf_acl,
) {

  $conf_dir = "${dat_root}/conf"
  $data_dir = "${dat_root}/data"

  # Manage the Preload file
  # This configures where the /conf dir is
  file { "${web_root}/inc/preload.php":
    ensure  => file,
    content => epp('dokuwiki/preload.php.epp', {'conf_dir' => $conf_dir}),
    owner   => $user,
    group   => $group,
    mode    => '0664',
  }

  # Manage the Local file
  # This is the primary config file for DokuWiki
  file { "${dat_root}/conf/local.php":
    ensure  => file,
    content => template('dokuwiki/local.php.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
  
  # Manage the Auth file
  # This is the defaul authentication meathod
  file { "${dat_root}/conf/users.auth.php":
    ensure  => file,
    content => epp('dokuwiki/users.auth.php.epp', {'conf_users' => $conf_users}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }

  # Manage the ACL File
  # This will grant users permissiont to areas of the wiki
  file { "${dat_root}/conf/acl.auth.php":
    ensure  => file,
    content => epp('dokuwiki/acl.auth.php.epp', {'conf_acl' => $conf_acl}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
}
