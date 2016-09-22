UUID="$(sudo dmidecode | grep 'UUID' | sed -e 's/.*: //')"
result="$(/usr/local/informatica-cloud/infaagent/jre/bin/java -jar /usr/local/informatica-cloud/infaagent/InfaCloudExtProvision.jar "cloudUsername" "$1" "cloudEmail" "$2" "cloudPassword" "$3" "firstName" "$4" "lastName" "$5" "title" "$6" "orgName" "$7" "phone" "$8" "connectorUUIDs" "$9" "identifier" "${UUID}" "orgAddress" "${UUID}")"
status=$(echo "${result}" | jq '.response.status' | sed "s/\"//g")
msg=$(echo "${result}" | jq '.response.msg'| sed "s/\"//g")
echo "Status: ${status}"
echo "Msg: ${msg}"
if [[ ${status} = "success" ]]
then
	rm "/usr/local/informatica-cloud/infaagent/InfaCloudExtProvision.jar"
	cd /usr/local/informatica-cloud/infaagent/apps/agentcore
	./infaagent startup &&
	./consoleAgentManager.sh configure "$1" "$3"
else
	rm "/usr/local/informatica-cloud/infaagent/InfaCloudExtProvision.jar"
	shutdown -P now
fi
