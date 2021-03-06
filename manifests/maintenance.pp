class dokuwiki::maintenance (
  $farmer_dir             = $::dokuwiki::params::farmer_dir,
  $user                 = $::dokuwiki::params::user,
  $group                = $::dokuwiki::params::group,
  $clean_enable         = $::dokuwiki::params::clean_enable,
  $clean_retention_days = $::dokuwiki::params::clean_retention_days,
) {

  # Setup the directory to hold maintenance scripts
  $script_dir = "${farmer_dir}/scripts"
  file { $script_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  # Enable the Cleanup Maintenance Scripts
  if $clean_enable {
    file { "${script_dir}/cleanup.sh":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0754',
      content => epp('dokuwiki/cleanup.sh.epp', {
        'farmer_dir'             => $farmer_dir,
        'clean_retention_days' => $clean_retention_days
      }),
    }
    cron { 'dokuwiki_cleanup':
      ensure  => present,
      command => "${script_dir}/cleanup.sh",
      user    => $user,
      hour    => 0,
      minute  => 7,
    }
  }
  # Disalbe the Cleanup Maintenance Scripts
  else {
    file { "${script_dir}/cleanup.sh":
      ensure => absent,
    }
    cron { 'dokuwiki_cleanup':
      ensure  => absent,
      command => "${script_dir}/cleanup.sh",
      user    => $user,
      hour    => 0,
      minute  => 7,
    }

  }
}
