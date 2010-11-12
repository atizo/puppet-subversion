# Serve subversion-based code from a local location.  The prupose of this
# define is to check out a revision from a subversion repository and keep 
# it up to date, especially useful for providing data to your Puppet server.
#
# Example usage:
#   subversion::working_copy{'/dist':
#       url => "https://reductivelabs.com/svn/dist",
#       user => "puppet",
#       password => "mypassword"
#   }

define subversion::working_copy(
  $url,
  $username = undef,
  $password = undef,
  $target = undef,
  $update = true
) {
  require subversion
  file{$name:
    ensure => directory,
    owner => root, group => root, mode => 0755;
  }
  if $username and $password {
    $svncmd = "/usr/bin/svn co --non-interactive --username $username --password '$password' $url $target"
  } else {
    $svncmd = "/usr/bin/svn co --non-interactive $url $target"
  }
  exec{"subversion-checkout-working_copy-$name":
    cwd => $name,
    command => $svncmd,
    creates => "$name/.svn",
    require => [
      Package['subversion'],
      File[$name],
    ],
  }
  if $update {
    exec{"subversion-update-working_copy-$name":
      cwd => $name,
      command => "/usr/bin/svn update",
      onlyif => "/usr/bin/svn status -u --non-interactive | /bin/grep '*'",
      require => [
        Package['subversion'],
        Exec["subversion-checkout-working_copy-$name"],
      ],
    }
  }
}
