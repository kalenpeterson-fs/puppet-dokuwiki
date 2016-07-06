# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppetlabs.com/guides/tests_smoke.html
#

class { '::dokuwiki':
  conf_title   => 'Farmer Wiki',
  clean_enable => false,
}

::dokuwiki::animal { 'pig': }
::dokuwiki::animal { 'dog': }
::dokuwiki::animal { 'cat':
  conf_users => [
    {
      login        => 'kalen',
      passwordhash => '$1$TLe1AqBY$FMt74HsbIz6HWJ.9I7Mh20',
      realname     => 'Kalen Peterson',
      email        => 'kpeterson@.net',
      groups       => [ 'admin', 'user' ],
    }
  ],
}
::dokuwiki::animal { 'cow': 
  conf_useacl => '0',
}
