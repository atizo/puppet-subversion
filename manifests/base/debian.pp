class subversion::base::debian inherits subversion::base {
    package{'subversion-tools':
        ensure => present;
    }
}
