class subversion::repository::basepath {
  file{'/srv/svn':
    ensure => directory,
    owner => root, group => 0, mode => 0755;
  }
}
