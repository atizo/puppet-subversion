# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# forked by Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

define subversion::repository(
    $basepath,
    $default_layout,
    $owner,
    $group,
    $mode,
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
        command => "/usr/bin/svnadmin create $repository_path",
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
            command => "/usr/bin/svn mkdir file://$repository_path/{trunk,tags,branches} -m 'initial layout'",
            refreshonly => true,
            require => File[$repository_path],
            subscribe => Exec["subversion-create-repository-$name"],
        }
    }
    if $owner {
        File[$repository_path]{
            owner => $owner,
        }
        Exec["subversion-create-default_layout-$name"]{
            owner => $owner,
        }
    } 
    if $group {
        File[$repository_path]{
            group => $group,
        }
        Exec["subversion-create-default_layout-$name"]{
            group => $group,
        }
    } 
    if $mode {
        File[$repository_path]{
            mode => $mode,
        }
    } 
}
