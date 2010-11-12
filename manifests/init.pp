#
# subversion module
#
# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# Copyright 2010, Atizo AG
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi simon.josi+puppet(at)atizo.com
# 
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class subversion {
  case $operatingsystem {
    debian,ubuntu: { include subversion::base::debian }
    default: { include subversion::base }
  }
}
