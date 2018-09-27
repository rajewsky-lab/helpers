#!/bin/bash

# pretty counts wrapper script
# Copyright (C) 2018  Marcel Schilling
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#######################
# general information #
#######################

# file:      pretty_counts.sh
# created:   2018-09-27
# author(s): Marcel Schilling <marcel.schilling@mdc-berlin.de>
# license:   GNU Affero General Public License Version 3 (GNU AGPL v3)
# purpose:   format 2-column TSV stream with counts in 2nd column (left-align
#            1st column, right-align 2nd column) (STDIN to STDOUT)


#########
# usage #
#########

# pretty_counts.sh < <input.tsv>


######################################
# change log (reverse chronological) #
######################################

# 2018-09-27: initial version


##############
# background #
##############

# This script was written as a helper for count_dropseq_features.awk.


####################
# column alignment #
####################

# align columns, intruduce <TAB> as anchor, invert lines, re-align, re-invert
column -t \
| sed 's/  \([^ ]\)/	\1/' \
| rev \
| column -t -s'	' \
| rev
