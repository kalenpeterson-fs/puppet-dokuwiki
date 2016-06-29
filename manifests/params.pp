class dokuwiki::params {
 
  $web_root = "/srv/www"
  $dat_root = "/var/dokuwiki"
  $doku_user = 'dokuwiki'
  $doku_source = "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
  $doku_install = "${dat_root}/dokuwiki.tar.gz"

  case $::osfamily {
    'RedHat': {
      $required_packages = [ 'httpd', 'php' ]
    }
    Default: {
      fail("Module kpeterson-dokuwiki doesn't support ${::osfamily}")
    }
  }
}
