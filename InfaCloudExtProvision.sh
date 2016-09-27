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
	./infaagent startup &&
	./consoleAgentManager.sh configure "$1" "$3"
else
	>&2 echo "Error occurred while registering user on Informatica Cloud. VM has been shut down but not deallocated and you will incur charges. Please stop the VM from the Azure portal to stop incurring charges."
	if [[ ${msg} = "UserAlreadyExists" ]] 
	then
		>&2 echo "Error Details: User already exists with the username $1"
	elif [[ ${msg} = "ConnectorActivationFailed" ]] 
	then
		>&2 echo "Error Details: Connector activation failed."
	else
		>&2 echo "An unexpected error has occurred. Please try again later or contact support."
	fi
	rm "/usr/local/infaagent/InfaCloudExtProvision.jar"
	exit 195
fi