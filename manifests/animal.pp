define dokuwiki::animal (
  $web_root             = $::dokuwiki::params::web_root,
  $farmer_dir           = $::dokuwiki::params::farmer_dir,
  $user                 = $::dokuwiki::params::user,
  $group                = $::dokuwiki::params::group,
  $animal_template      = $::dokuwiki::params::animal_template,
  $conf_lang            = $::dokuwiki::params::conf_lang,
  $conf_license         = $::dokuwiki::params::conf_license,
  $conf_useacl          = $::dokuwiki::params::conf_useacl,
  $conf_authtype        = $::dokuwiki::params::conf_authtype,
  $conf_superuser       = $::dokuwiki::params::conf_superuser,
  $conf_disableactions  = $::dokuwiki::params::conf_disableactions,
  $conf_users           = $::dokuwiki::params::conf_users,
  $conf_acl             = $::dokuwiki::params::conf_acl,
) {

  include ::dokuwiki
  $conf_title           = $name
  $animal_root = "${web_root}/${name}"

  # Implement the Aminal Template
  file { $animal_root:
    ensure  => directory,
    source  => $animal_template,
    owner   => $user,
    group   => $group,
    recurse => true,
  }

  # Manage local.protected.php
  file { "${animal_root}/conf/local.protected.php":
    ensure  => file,
    content => template('dokuwiki/animal/local.protected.php.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }

  # Manage the Auth file
  # This is the defaul authentication meathod
  file { "${animal_root}/conf/users.auth.php":
    ensure  => file,
    content => epp('dokuwiki/users.auth.php.epp', {'conf_users' => $conf_users}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }

  # Manage the ACL File
  # This will grant users permissiont to areas of the wiki
  file { "${animal_root}/conf/acl.auth.php":
    ensure  => file,
    content => epp('dokuwiki/acl.auth.php.epp', {'conf_acl' => $conf_acl}),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }

}
