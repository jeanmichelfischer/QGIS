#!/usr/bin/env bash
###########################################################################
#    sip_include.sh
#    ---------------------
#    Date                 : 21.06.2017
#    Copyright            : (C) 2017 by Denis Rouzaud
#    Email                : denis.rouzaud@gmail.com
###########################################################################
#                                                                         #
#   This program is free software; you can redistribute it and/or modify  #
#   it under the terms of the GNU General Public License as published by  #
#   the Free Software Foundation; either version 2 of the License, or     #
#   (at your option) any later version.                                   #
#                                                                         #
###########################################################################
set -e

DIR=$(git rev-parse --show-toplevel)

pushd ${DIR} > /dev/null

# GNU prefix command for mac os support (gsed, gsplit)
GP=
if [[ "$OSTYPE" =~ darwin* ]]; then
  GP=g
fi

modules=(core gui analysis server)
sources=(HDRS MOC_HDRS SRCS)

for module in "${modules[@]}"; do
  file=${DIR}/python/${module}/${module}_auto.sip
  echo "Creating python/${module}/${module}_auto.sip"
  echo "// Include auto-generated SIP files" > $file

  headers=$(
    for source in "${sources[@]}"; do
      echo "QGIS_${module^^}_${source}"
      ${GP}sed -r -n -e "/^\s*SET\s*\(QGIS_${module^^}_${source}/,/\)\$/{ /^\s*SET\s*\(QGIS_${module^^}_${source}/d; /\)\$/d; p; }" src/${module}/CMakeLists.txt | \
      ${GP}sed -r -e '/\.cc?$/d'     `# remove c and cc extensions` \
                  -e 's/\.cpp$/.h/'  `# rename cpp file as headers` \
                  -e '/^\s*\$\{CMAKE_(CURRENT_)?BINARY_DIR\}/d' \
                  -e '/^\s*#/d'      `# remove commented lines` \
                  -e 's/\$\{.*\}//g' `# remove CMake variable append` \
                  -e 's/^\s+//'      `# remove leading spaces` \
                  -e '/^\s*$/d'      `# remove blank lines`
    done | cat -n | sort -uk2 | sort -nk1 | cut -f2-  # remove duplicated lines without sorting
  )
  for header in ${headers}; do
    if [ ! -f src/${module}/$header ]; then
      # if no header, no sip file!
      #echo "src/${module}/$header not found"
      continue
    fi
    if ! egrep -xq '^(#define +)?SIP_NO_FILE' src/${module}/${header}; then
      sip=`${GP}sed -r 's/(.*)\.h$/\1.sip/' <<< ${header}`
      if_cond=`egrep -x '^(#define +)?SIP_IF_MODULE\((.*)\)$' src/${module}/${header} | \
       ${GP}sed -r -e 's/(#define +)?SIP_IF_MODULE\((.*)\)/%If (\2)/'`
      if [[ ! -z $if_cond ]]; then
        echo "$if_cond" >> $file
      fi
      echo "%Include $sip" >> $file
      if [[ ! -z $if_cond ]]; then
        echo "%End" >> $file
      fi
    fi
  done
done


popd > /dev/null
