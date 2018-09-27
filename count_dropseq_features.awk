#!/usr/bin/awk -f

# Drop-seq pipeline feature counting script
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

# file:    count_dropseq_features.awk
# created: 2018-09-27
# author:  Marcel Schilling <marcel.schilling@mdc-berlin.de>
# license: GNU Affero General Public License Version 3 (GNU AGPL v3)
# purpose: count reads by features in SAM stream generated by Drop-seq pipeline
#          (STDIN to STDOUT)


#########
# usage #
#########

# samtools view <input.bam> | count_dropseq_features.awk | sort -k2,2nr | column -t


######################################
# change log (reverse chronological) #
######################################

# 2018-09-27: initial version


##############
# background #
##############

# This script is based on the following email:

# From: Tamas Sztanka-Toth <tamasryszard.sztanka-toth@mdc-berlin.de>
# To: Marcel Schilling <marcel.schilling@mdc-berlin.de>
# Date: Thu, 27 Sep 2018 13:19:34 +0200
# Subject: read type counting expressions
# 
# sambamba view
# /data/local/murphy/projects/kettenmann_microglia/WT_1.my_clean.bam \
# | grep -c "XF:Z:INTRONIC"
# 
# sambamba view
# /data/local/murphy/projects/kettenmann_microglia/WT_1.my_clean.bam \
# | grep -c "XF:Z:INTERGENIC"
# 
# sambamba view
# /data/local/murphy/projects/kettenmann_microglia/WT_1.my_clean.bam \
# | grep -v GE:Z | grep -c "XF:Z:UTR"
# 
# sambamba view
# /data/local/murphy/projects/kettenmann_microglia/WT_1.my_clean.bam \
# | grep -v GE:Z | grep -c "XF:Z:CODING"

# Additionally, this script assumes that the "GE:Z" flag is mutually exclusive
# with the "XF:Z:INTRONIC" & "XF:Z:INTERGENIC" flags


##############
# parameters #
##############

BEGIN {

  # Split TSV (i.e. SAM) into two parts: up to the "XF:Z:..." flag and after.
  # This will remove the "XF:Z:" part from the 2nd field, such that it starts
  # with the corresponding feature.
  FS = "\tXF:Z:"

  # Output TSV.
  OFS = "\t"

  # count "GE:Z" tags as gene features
  ge_feature = "GENE"

  # alignments without "GE:Z:" and "XF:Z:"tags as unknown features
  no_feature = "UNKNOWN"
}


################
# tag counting #
################

# count "GE:Z:" tags
/\tGE:Z:/ {
  ++c[ge_feature]

  # don't double-count reads
  next
}

# count alignments without "GE:Z:" and "XF:Z:" tags
NF < 2 {
  ++c[no_feature]

  # don't double-count reads
  next
}

# for reads lacking gene assignment but with feature assignment:
{
  # discard remaining tags
  sub("\t.*", "", $2)

  # count feature tag
  ++c[$2]
}


##########
# output #
##########

# iterate over all features and print with corresponding counts
END {
  for (f in c) {
    print f, c[f]
  }
}