#!/usr/bin/env bash

#
# bigger than 1g and older than 7 mo
#

set -euo pipefail

readonly WHEN="${1:-"7 months ago"}"
readonly SIZE_THRESH="${1:-1G}"
readonly DATE="$(date --date "${WHEN}" +"%Y%m%d")"
TMPDIR="${SFHOME:-/opt/starfish}/tmp"

echo -n "Number and size of files larger than ${SIZE_THRESH} and last accessed, created or modified more than ${WHEN}: "
sf query nobackup1b: -h --size "${SIZE_THRESH}-99999T" --atime "19000101-${DATE}" --ctime "19000101-${DATE}" --mtime "19000101-${DATE}" --csv | tee "${TMPDIR}/sf-camtime-${WHEN}-${SIZE_THRESH}.csv" | awk -F'\t' '{count+=1;total+=$8}END{printf "%d files, %d bytes\n",count,total}'

odirroot=/nfs/cnhlab003/cnh/oldfiles
odirsuff=`date +"%Y/%m/%d/nobackup1b"`
mkdir -p ${odirroot}"/"${odirsuff}
cp  "${TMPDIR}/sf-camtime-${WHEN}-${SIZE_THRESH}.csv" ${odirroot}"/"${odirsuff}
cat "${TMPDIR}/sf-camtime-${WHEN}-${SIZE_THRESH}.csv" | awk -F'\t' '{print $7, "user="$8, $14, "/"$18"/"$19}' | sort -k2,2 | sed s/'"'//g > ${odirroot}"/"${odirsuff}/oldf1g7mo.txt
