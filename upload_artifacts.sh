#!/bin/bash

# Please Go to the folder whose all contents you want to upload and execute the script.

# following will be the output files generated
files="output.out"
releasefiles="./release.out"
snapshotfiles="./snapshot.out"

username="yourusername"
password="yourpassword"
nexusurl="http://localhost:8081/repository/maven-releases/com/"
snapshoturl="http://localhost:8081/repository/Snapshots/"
releaseurl="http://localhost:8081/repository/Releases/"

find . -name '*.*' -type f | cut -c 3- | grep "/" > $files
find . -name '*.*' -type f | cut -c 3- | grep "SNAPSHOT" | grep "/" > $snapshotfiles
find . -name '*.*' -type f | cut -c 3- | grep -v "SNAPSHOT" | grep "/" > $releasefiles

while read i; do
   echo "upload $i to $nexusurl"
   curl -v -u $username:$password --upload-file $i "$nexusurl$i"
 done <$files
 
while read i; do
  echo "upload $i to $snapshoturl"
  curl -v -u $username:$password --upload-file $i "$snapshoturl$i"
done <$snapshotfiles

while read i; do
  echo "upload $i to $releaseurl"
  curl -v -u $username:$password --upload-file $i "$releaseurl$i"
done <$releasefiles
