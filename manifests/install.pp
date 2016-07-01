class dokuwiki::install (
  $web_root     = $::dokuwiki::params::web_root,
  $dat_root     = $::dokuwiki::params::dat_root,
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
    home   => $dat_root,
    gid    => $group,
    system => true,
  }

  # Setup the Webroot location
  file { $web_root:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    before  => Exec['extract_web_root'],
    require => User[$user],
  }

  # Setup the Data/Conf Location
  file { $dat_root:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => User[$user],
  }

  # Get the newest DokuWiki Package
  file { $doku_install:
    ensure   => file,
    source   => $doku_source,
    checksum => 'md5',
    require  => File[$dat_root],
  }

  # Install the the DokuWiki web files to the web root
  exec { 'extract_web_root':
    command     => "/usr/bin/tar -xf ${doku_install} -C ${$web_root} --strip-components=1 \
                    --exclude='dokuwiki*/data' --exclude='dokuwiki*/conf' \
                    --exclude='dokuwiki*/bin' --exclude='dokuwiki*/install.php'",
    subscribe   => File[$doku_install],
    refreshonly => true,
  }
  
  # Initialize the data, conf, and bin dirs on initial install
  $dat_dirs = [ 'data', 'conf', 'bin' ]
  $dat_dirs.each |String $dir| {
    exec { "extract_dat_${dir}":
      command => "/usr/bin/tar -xf ${doku_install} -C ${dat_root} \
                  --strip-components=1 'dokuwiki*/${dir}'",
      subscribe   => File[$doku_install],
      refreshonly => true,
      onlyif      => "/usr/bin/test ! -d '{$dat_root}/$dir'",
    }
    exec { "chwon_dat_${dir}":
      command     => "/usr/bin/chown -R ${user}:${group} '${dat_root}/${dir}'",
      subscribe   => Exec["extract_dat_${dir}"],
      refreshonly => true,
    }
  }
}
