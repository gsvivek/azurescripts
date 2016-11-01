UUID="$(sudo dmidecode | grep 'UUID' | sed -e 's/.*: //')"
result="$(/usr/local/infaagent/jre/bin/java -jar /usr/local/infaagent/InfaCloudExtProvision.jar "cloudUsername" "$1" "cloudEmail" "$2" "cloudPassword" "$3" "firstName" "$4" "lastName" "$5" "title" "$6" "orgName" "$7" "phone" "$8" "orgCountry" "$9" "orgState" "${10}" "connectorUUIDs" "${11}" "identifier" "${UUID}" "orgAddress" "${UUID}")"
status=$(echo "${result}" | jq '.response.status' | sed "s/\"//g")
msg=$(echo "${result}" | jq '.response.msg'| sed "s/\"//g")
echo "result: " ${result}
if [[ ${status} = "success" ]]
then
	echo "Registration successful on Informatica Cloud. Please login to the VM to use your Informatica Cloud subscription."
	rm "/usr/local/infaagent/InfaCloudExtProvision.jar"
	cd /usr/local/infaagent/apps/agentcore
	./infaagent startup
	sleep 10
	./consoleAgentManager.sh configure "$1" "$3"
else
	if [[ ${msg} = "UserAlreadyExists" ]] 
	then
		errorCode=195
	elif [[ ${msg} = "ConnectorActivationFailed" ]] 
	then
		errorCode=196
	else
		errorCode=200
	fi
	rm "/usr/local/infaagent/InfaCloudExtProvision.jar"
	exit ${errorCode}
fi