define subversion::repository(
  $owner,
  $group,
  $mode,
  $basepath = false,
  $default_layout = false,
  $recurse_permissions = true
) {
  include subversion

  if $basepath {
      $repository_path = "$basepath/$name"
  } else {
      require subversion::repository::basepath
      $repository_path = "/srv/svn/$name"
  }
  exec{"subversion-create-repository-$name":
    command => "svnadmin create $repository_path",
    creates => $repository_path,
    require => Package['subversion'],
    before => File[$repository_path],
  }
  file{$repository_path:
    backup => false,
    ensure => directory,
    recurse => $recurse_permissions,
  }
  if $default_layout {
    exec{"subversion-create-default_layout-$name":
      command => "svn mkdir file://$repository_path/{trunk,tags,branches} -m 'initial layout'",
      refreshonly => true,
      require => File[$repository_path],
      subscribe => Exec["subversion-create-repository-$name"],
    }
  }
  if $owner {
    File[$repository_path]{
      owner => $owner,
    }
    if $default_layout {
      Exec["subversion-create-default_layout-$name"]{
        user => $owner,
      }
    }
  } 
  if $group {
    File[$repository_path]{
      group => $group,
    }
    if $default_layout {
      Exec["subversion-create-default_layout-$name"]{
        group => $group,
      }
    }
  } 
  if $mode {
    File[$repository_path]{
      mode => $mode,
    }
  } 
}
