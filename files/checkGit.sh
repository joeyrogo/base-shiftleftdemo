#!/bin/bash -l
#Force a rescan of the repo in order to get fresh results
curl -k -u $TL_USER:$TL_PASS -H 'Content-Type: application/json' -X POST https://$TL_CONSOLE/api/v1/coderepos/scan
sleep 5
REPOOUTPUT=$(curl -k -u $TL_USER:$TL_PASS \
  -H 'Content-Type: application/json' \
  https://$TL_CONSOLE/api/v1/coderepos?id=se-cloud-demo-service%2F<buildname>-evil.petclinic&limit=15&offset=0&project=Central+Console&reverse=true&sort=vulnerabilityRiskScore)
#in row nr 4. replace <buildname> with your buildname of your demo-build.yml file. 

#sed -n -e 's/^.*\(vulnerabilitiesCount\)/\1/p' | cut -f1 -d, | cut -f2- -d: > output.txt
VULN=$(echo $REPOOUTPUT | sed -n -e 's/^.*\(vulnerabilitiesCount\)/\1/p' | cut -f1 -d, | cut -f2- -d:)
#VULN=$(cat output.txt)

if (( $VULN == 0 )); then
   echo "No Code Repo Vulnerabilities!"
   exit 0
else
   echo "There are $VULN vulnerabilities on dependencies in Git"
   exit 1
fi
