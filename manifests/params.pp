class dokuwiki::params {
 
  $web_root             = "/srv/www/vhost/dokuwiki"
  $dat_root             = "/var/dokuwiki"
  $user                 = 'dokuwiki'
  $group                = 'dokuwiki'
  $doku_source          = "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
  $doku_install         = "${dat_root}/dokuwiki.tar.gz"

  $conf_lang            = 'en'
  $conf_license         = '0'
  $conf_useacl          = 1
  $conf_authtype        = 'authplain'
  $conf_superuser       = 'admin'
  $conf_disableactions  = 'register'

  $clean_enable         = false
  $clean_retention_days = '180'

  # Set of default users for installation
  $conf_users = [
    {
      login        => 'admin',
      passwordhash => '$1$zD6vnrRC$hB6HLLRJh5GJDA8KH2891.',
      realname     => 'Default Admin User',
      email        => 'admin@default.com',
      groups       => [ 'admin', 'user' ],
    },
    {
      login        => 'user',
      passwordhash => '$1$roWCBNLS$J6qd.B/YsasYQAY/0SLF30',
      realname     => 'Default User',
      email        => 'user@default.com',
      groups       => [ 'user' ],
    }
  ]

  # A restrictive default ACL to use
  $conf_acl = [
    {
      page => '*',
      user => '@ALL',
      perm => '0',
    },
    {
      page => '*',
      user => '@user',
      perm => '8',
    }
  ]


  case $::osfamily {
    'RedHat': {
      $required_packages = [ 'php' ]
    }
    Default: {
      fail("Module kpeterson-dokuwiki doesn't support ${::osfamily}")
    }
  }
}
