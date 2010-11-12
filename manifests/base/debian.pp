class subversion::base::debian {
  include subversion::base
  package{'subversion-tools':
    ensure => present;
  }
}
