class dokuwiki::params {
 
  $web_root     = "/srv/www/vhost/dokuwiki"
  $dat_root     = "/var/dokuwiki"
  $doku_user    = 'dokuwiki'
  $doku_source  = "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
  $doku_install = "${dat_root}/dokuwiki.tar.gz"

  $conf_title = 'My Wiki'
  $conf_lang = 'en'
  $conf_license = '0'
  $conf_useacl = 1
  $conf_authtype = 'authplain'
  $conf_superuser = 'kpeterson'
  $conf_disableactions = 'register'

  $conf_users = [
    {
      login        => 'admin',
      passwordhash => '$1$wZJKCSes$fQ2SOfz/3/lmK729rLryq.',
      realname     => 'Default Admin User',
      email        => 'admin@default.com',
      groups       => [ 'admin', 'user' ],
    },
    {
      login        => 'user',
      passwordhash => '$1$wZJKCSes$fQ2SOfz/3/lmK729rLryq.',
      realname     => 'Default User',
      email        => 'user@default.com',
      groups       => [ 'user' ],
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
