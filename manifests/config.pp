class dokuwiki::config ( 
  $web_root             = $::dokuwiki::params::web_root,
  $farmer_dir           = $::dokuwiki::params::farmer_dir,
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

  # Manage the .htaccess file in web_root
  # This is what makes farms work
  file { "${web_root}/.htaccess":
    ensure  => file,
    content => epp('dokuwiki/webroot.htaccess.epp'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
  # Manage the .htaccess file in farmer_dir
  # This is what keeps everyting restrited
  file { "${farmer_dir}/.htaccess":
    ensure  => file,
    content => epp('dokuwiki/farmer.htaccess.epp'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
  # Manage the Preload file
  # This configures where the /conf dir is
  file { "${farmer_dir}/inc/preload.php":
    ensure  => file,
    content => epp('dokuwiki/preload.php.epp', { 'web_root' =>  $web_root }),
    owner   => $user,
    group   => $group,
    mode    => '0664',
  }

  # Manage the Local file
  # This is the primary config file for DokuWiki
  file { "${farmer_dir}/conf/local.php":
    ensure  => file,
    content => template('dokuwiki/local.php.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
  
  # Manage the Auth file
  # This is the defaul authentication meathod
  file { "${farmer_dir}/conf/users.auth.php":
    ensure  => file,
    content => epp('dokuwiki/users.auth.php.epp', {'conf_users' => $conf_users}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }

  # Manage the ACL File
  # This will grant users permissiont to areas of the wiki
  file { "${farmer_dir}/conf/acl.auth.php":
    ensure  => file,
    content => epp('dokuwiki/acl.auth.php.epp', {'conf_acl' => $conf_acl}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
}
