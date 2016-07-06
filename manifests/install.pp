class dokuwiki::install (
  $web_root     = $::dokuwiki::params::web_root,
  $farmer_dir   = $::dokuwiki::params::farmer_root,
  $doku_source  = $::dokuwiki::params::doku_source,
  $user         = $::dokuwiki::params::user,
  $group        = $::dokuwiki::params::group,
  $doku_install = $::dokuwiki::params::doku_install,
) {

  # Install Packages
  $required_packages = $::dokuwiki::params::required_packages
  package { $required_packages:
    ensure => installed,
  }

  # Setup to the Dokuwiki User
  user { $user:
    ensure => present,
    home   => $web_root,
    gid    => $group,
    system => true,
  }

  # Setup the Webroot location
  file { [ $web_root, $farmer_dir ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    before  => Exec['extract_farmer_dir'],
    require => User[$user],
  }

  # Get the newest DokuWiki Package
  file { $doku_install:
    ensure   => file,
    source   => $doku_source,
    checksum => 'md5',
    require  => File[$web_root],
  }

  # Install the the DokuWiki web files to the web root
  exec { 'extract_farmer_dir':
    command     => "/usr/bin/tar -xf ${doku_install} -C ${$farmer_dir} --strip-components=1 \
                    --exclude='dokuwiki*/install.php'",
    subscribe   => File[$doku_install],
    refreshonly => true,
  }

  # Ensure Permissions
  exec { 'chown_farmer_dir':
      command     => "/usr/bin/chown -R ${user}:${group} '${farmer_dir}'",
      subscribe   => Exec["extract_farmer_dir"],
      refreshonly => true,
  }
}
