UUID=$(sudo dmidecode | grep UUID)
result = $("/usr/local/informatica-cloud/infaagent/jre/bin/java" -jar "/usr/local/informatica-cloud/infaagent/InfaCloudExtProvision.jar" "cloudUsername" "$1" "cloudEmail" "$2" "cloudPassword" "$3" "firstName" "$4" "lastName" "$5" "title" "$6" "orgName" "$7" "phone" "$8" "connectorUUIDs" "$9" "identifier" "$(UUID)" "orgAddress" "$(UUID)")
status=$result | jq -r '.status'
msg=$result | jq -r '.msg'
echo "Status: $status"
echo "Msg: $msg"
if ["$status" = "success"]
then
cd /usr/local/informatica-cloud/infaagent/apps/main/agentcore
./infaagent startup
cd /usr/local/informatica-cloud/infaagent/apps/main/agentcore
./consoleAgentManager.sh configure 
else 
rm "/usr/local/informatica-cloud/infaagent/InfaCloudExtProvision.jar"
shutdown -P now
fi
