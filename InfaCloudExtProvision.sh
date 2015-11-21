uuid=$(sudo dmidecode | grep UUID)
/root/infaagent/jre/bin/java -jar /root/infaagent/CloudExtProvisionClient.jar "cloudUsername" "$1" "cloudPassword" "$2" "connectorUUIDs" "$3" "identifier" "$uuid"
