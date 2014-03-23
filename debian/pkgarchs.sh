#!/bin/sh
#
# Copyright © 2008 Jonas Smedegaard <dr@jones.dk>
# Description: Resolves supported archs of a Debian package
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307 USA.
#
# Depends: devscripts

set -e

defaultsuite="unstable"
currentsuite="`dpkg-parsechangelog | grep ^Distribution: | awk '{print $2}'`"

pkg="$1"
suite="${2:-$currentsuite}"

case "$suite" in
    UNRELEASED|"")
	echo >&2 "WARNING: bad suite \"$suite\", using \"$defaultsuite\" instead."
	suite="$defaultsuite"
	;;
esac

echo >&2 "INFO: Resolving architectures for package \"$pkg\" through rmadison Internet request."
rmadison -s "$suite" "$pkg" \
	| awk -F'|' '{ print $4 }' \
	| sed 's/ //g;s/,/\n/g' \
	| LANG=C sort \
	| tr '\n' ' ' \
	| sed 's/ $/\n/'
