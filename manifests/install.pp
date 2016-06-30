class dokuwiki::install {

  $web_root = $::dokuwiki::params::web_root
  $dat_root = $::dokuwiki::params::dat_root
  $doku_source = $::dokuwiki::params::doku_source
  $doku_user = $::dokuwiki::params::doku_user
  $doku_install = $::dokuwiki::params::doku_install
  $required_packages = $::dokuwiki::params::required_packages

  # Install Packages
  package { $required_packages:
    ensure => installed,
  }

  # Setup to the Doku User
  user { $doku_user:
    ensure => present,
    home   => $dat_root,
    system => true,
  }

  # Setup the Webroot location
  file { $web_root:
    ensure  => directory,
    owner   => $doku_user,
    group   => $doku_user,
    mode    => '0755',
    before  => Exec['extract_dokuwiki'],
    require => User[$doku_user],
  }

  # Setup the Data/Conf Location
  file { $dat_root:
    ensure  => directory,
    owner   => $doku_user,
    group   => $doku_user,
    mode    => '0755',
    require => User[$doku_user],
  }

  # Get the newest DokuWiki Package
  file { $doku_install:
    ensure   => file,
    source   => $doku_source,
    checksum => 'md5',
    require  => File[$dat_root],
    before   => Exec['extract_dokuwiki'],
  }

  # Install the the DokuWiki Package and set permissions
  exec { 'extract_dokuwiki':
    command     => "/usr/bin/tar -xzf ${doku_install} -C ${$web_root} --strip-components=1",
    subscribe   => File[$doku_install],
    refreshonly => true,
  }
  

  # Initialize the data, conf, and bin dirs on install
  # then remove the source
  $dat_dirs = [ 'data', 'conf', 'bin' ]
  $dat_dirs.each |String $dir| {
    file { "${dat_root}/${dir}":
      ensure  => directory,
      owner   => $doku_user,
      group   => $doku_user,
      recurse => true,
      replace => false,
      source  => "file:${web_root}/${dir}",
      require => Exec['extract_dokuwiki'],
    }
  }

  # Post install cleanup
  $clean_files = [ 'install.php' ]
  $clean_files.each |String $file| {
    file { "${web_root}/${file}":
      ensure  => absent,
      force   => true,
      require => Exec['extract_dokuwiki'],
    }
  }

}
