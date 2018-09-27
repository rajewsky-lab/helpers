#!/usr/bin/perl

# frequency table generation script
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

# file:      table.pl
# created:   2018-09-27
# author(s): Filippos Klironomos <fklirono@gmx.de> [FK],
#            Marcel Schilling <marcel.schilling@mdc-berlin.de> [MS]
# license:   GNU Affero General Public License Version 3 (GNU AGPL v3)
# purpose:   mimick R's `table` function treating TSV columns as vectors
#            (STDIN to STDOUT)


#########
# usage #
#########

# see $usage below


######################################
# change log (reverse chronological) #
######################################

# 2018-09-27: added license & comment boilerplate [MS]
#             initial version [FK]


##############
# background #
##############

# This script was written by Filippos some time ago and included in this
# repository based on the following email:

# From: Filippos Klironomos <fklirono@gmx.de>
# To: Marcel Schilling <marcel@schilling-home.net>
# Date: Thu, 27 Sep 2018 16:13:52 +0200
# Subject: Re: table.pl
# 
# sure, add it to the repo, use this GMX address.
# 
# Cheers,
# 
# F:-)
# 
# 
# 
# On 09/27/2018 04:05 PM, Marcel Schilling wrote:
# > Hey Filippos,
# >
# > In /data/rajewsky/code, I found table.pl created by me.
# > I think I got it from you. Dave initiated
# > https://github.com/rajewsky-lab/helpers and I wonder if you'd be fine
# > having it there (under AGPL-3.0)?
# > I would take care of commenting it, I'd just need to know which email
# > address of yours you'd like it to be commited with.
# >
# > Cheers,
# > Marcel


#########################
# original script by FK #
#########################

use Getopt::Long;

my $usage="
tabulate values extracted from given column of file1, ...

usage: $0 --simple -c/--column= [default:1] -s/--separator= [default:'\\t'] file1, ...

Example: $0 -c 5 -s ',' file.csv
";

my $col=1;  #  column to read from [one-based]
my $sep="\t";  #  separator to use to determine the column
my $simple="";  #  report only 'value TAB multiplicity' without header or : separator
GetOptions('c|column=i' => \$col, 's|separator=s' => \$sep, 'simple' => \$simple);

if ( -t STDIN && !@ARGV ){die $usage}  #  no input and no pipe is provided, STDIN will wait for input from the terminal

my %v;  #  hash to hold the values extracted as keys

while(<>){  #  open piped STDIN or @ARGV 
  chomp;
  $v{(split(/$sep/, $_))[$col-1]}++;  #  split line by $sep and extract $col-1 (zero-based) as key, increasing its value by one in the hash
}

my @v_s = sort { $a <=> $b } keys %v;  

printf "%6s  : %6s\n", "value", "multiplicity" unless ($simple);
print "--------:-------------\n" unless ($simple);
foreach (@v_s){ 
  if ($simple){
    printf "%s\t%s\n", $_, $v{$_}
  } else {
    printf "%1s\t:\t%1s\n", $_, $v{$_}
  }
}

