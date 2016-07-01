# Class: dokuwiki
# ===========================
#
# Full description of class dokuwiki here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'dokuwiki':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class dokuwiki (
  $web_root             = $::dokuwiki::params::web_root,
  $dat_root             = $::dokuwiki::params::dat_root,
  $user                 = $::dokuwiki::params::user,
  $group                = $::dokuwiki::params::group,
  $doku_source          = $::dokuwiki::params::doku_source,
  $doku_install         = $::dokuwiki::params::doku_install,
  $conf_title           = undef,
  $conf_lang            = $::dokuwiki::params::conf_lang,
  $conf_license         = $::dokuwiki::params::conf_license,
  $conf_useacl          = $::dokuwiki::params::conf_useacl,
  $conf_authtype        = $::dokuwiki::params::conf_authtype,
  $conf_superuser       = $::dokuwiki::params::conf_superuser,
  $conf_disableactions  = $::dokuwiki::params::conf_disableactions,
  $conf_users           = $::dokuwiki::params::conf_users,
  $conf_acl             = $::dokuwiki::params::conf_acl,
  $clean_enable         = $::dokuwiki::params::clean_enable,
  $clean_retention_days = $::dokuwiki::params::clean_retention_days,
) inherits dokuwiki::params {
  class { '::dokuwiki::install': 
    web_root          => $web_root,
    dat_root          => $dat_root,
    doku_source       => $doku_source,
    user              => $user,
    group             => $group,
    doku_install      => $doku_install,
  } ->
  class { '::dokuwiki::config': 
    web_root            => $web_root,
    dat_root            => $dat_root,
    user                => $user,
    group               => $group,
    conf_title          => $conf_title,
    conf_lang           => $conf_lang,
    conf_license        => $conf_license,
    conf_useacl         => $conf_useacl,
    conf_authtype       => $conf_authtype,
    conf_superuser      => $conf_superuser,
    conf_disableactions => $conf_disableactions,
    conf_users          => $conf_users,
    conf_acl            => $conf_acl,
  } ->
  class { '::dokuwiki::maintenance':
    dat_root             => $dat_root,
    user                 => $user,
    group                => $group,
    clean_enable         => $clean_enable,
    clean_retention_days => $clean_retention_days,
  }
}
