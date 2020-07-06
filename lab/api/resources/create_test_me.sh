#!/bin/bash

#set -x

######################################################################################
# This script is only meant to be used as a test script to create a ME for each vendor
######################################################################################

USER="ncroot"
PASSWORD="ubiqube"
OPERATOR="TST"
OPERATOR_NAME="my_tenant"

MAN_ID=$1
MOD_ID=$2
ME_NAME=$3


RESPONSE=`curl -s -H 'Content-Type: application/json' -XPOST http://127.0.0.1/ubi-api-rest/auth/token -d '{"username":"ncroot", "password":"ubiqube" }'`
if [ -z "$RESPONSE" ]
then
      echo "Authentication API error"
      exit 1
fi
TOKEN=$(php -r 'echo json_decode($argv[1])->token;' "$RESPONSE")

echo "-------------------------------------------------------"
echo "CREATE $OPERATOR TENANT AND CUSTOMER my_subtenant"
echo "-------------------------------------------------------"

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/operator/$OPERATOR?name=$OPERATOR_NAME"
echo
curl -s -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" -XPOST "http://127.0.0.1/ubi-api-rest/customer/$OPERATOR?name=my_subtenant&reference=my_subtenant" -d '{"name":"my_subtenant"}'
echo
CUSTLIST=`curl -s -H "Content-Type:application/json" -H "Authorization: Bearer "$TOKEN -XGET http://127.0.0.1/ubi-api-rest/lookup/customers`

IFS='"' # set delimiter
read -ra ADDR <<< "$CUSTLIST" # str is read into an array as tokens separated by IFS
for i in "${ADDR[@]}"; do # access each element of array
    if [[ $i == TSTA* ]]  
    then  
	CUSTID=$i
    fi
done

echo $CUSTID


echo "--------------------------------------------------"
echo "ATTACH WORKFLOWS TO CUSTOMER $CUSTID"  
echo "--------------------------------------------------"

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/$CUSTID/service/attach?uri=Process/SelfDemoSetup/SelfDemoSetup.xml"



echo "--------------------------------------------------"
echo "CREATE DEMO DEVICES"
echo "--------------------------------------------------"
CUSTIDONLY=${CUSTID//BLRA}



echo "### Netconf Generic "
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "Netconf Generic",  "model_id": "18072500", "manufacturer_id": "18072500",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### PaloAlto VA "
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "PaloAltoVA",  "model_id": "134", "manufacturer_id": "28",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### PaloAlto Chassis "
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "PaloAltoChassis,  "model_id": "135", "manufacturer_id": "28",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### PaloAlto Vsys "
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "PaloAltoVsys,  "model_id": "136", "manufacturer_id": "28",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'


exit 0


echo "### Fortigate "
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "Fortigate",  "model_id": "15102617", "manufacturer_id": "17",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### Fortiwaf"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "Fortiwaf",  "model_id": "15031001", "manufacturer_id": "17",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'



echo "### OneAccess Netconf"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "OneAccess_Netconf",  "model_id": "16010411", "manufacturer_id": "25",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### OneAccess Whitebox"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "OneAccess_Netconf",  "model_id": "16010402", "manufacturer_id": "25",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "### OneAccess Generic"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "managed_device_name": "OneAccess_Netconf",  "model_id": "110", "manufacturer_id": "25",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",    "device_ip_address": "192.168.1.1",  "login": "msa" }'



echo "### pfSense"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "manufacturer_id": "200425",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "managed_device_name": "pfsense",  "model_id": "200425",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### Checkpoint"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "manufacturer_id": "18082900",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "managed_device_name": "checkpoint_R80",  "model_id": "18082900",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### REST Generic"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{  "manufacturer_id": "191119",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "managed_device_name": "REST_generic",  "model_id": "191119",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### AWS Generic"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "AWS_gen",  "model_id": "17010301", "manufacturer_id": "17010301",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### ADVA NC"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "ADVA NC",  "model_id": "18100200", "manufacturer_id": "18100200",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### F5_BIGIP"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "F5_BIGIP",  "model_id": "50001", "manufacturer_id": "50000",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Virtuora NC"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Virtuora_NC",  "model_id": "18100100", "manufacturer_id": "18100100",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa" }'

echo "#### Cisco WSA"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_WSA",  "model_id": "95", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Cisco ESA"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_ESA",  "model_id": "112", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Cisco Catalyste IOS"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_Catalyst_IOS",  "model_id": "104", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### SDN Cisco APIC"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "SDN_Cisco_APIC",  "model_id": "133", "manufacturer_id": "27",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Cisco Nexus 9000"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_Nexus_9000",  "model_id": "201", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Cisco ISR"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_ISR",  "model_id": "113", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Cisco ASA"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Cisco_ASA",  "model_id": "15010202", "manufacturer_id": "1",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Fortinet VA"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Fortinet_VA",  "model_id": "15102617", "manufacturer_id": "17",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### Rancher CMP"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "Rancher CMP",  "model_id": "18081001", "manufacturer_id": "18081001",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### HP5900"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "HP5900",  "model_id": "17071302", "manufacturer_id": "17071301",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### HP2530"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "HP2530",  "model_id": "17071301", "manufacturer_id": "17071301",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### NEC_IX"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "NEC_IX",  "model_id": "18120401", "manufacturer_id": "70000",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'

echo "#### NEC_NFA"
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer "$TOKEN -XPOST "http://127.0.0.1/ubi-api-rest/orchestration/service/execute/status/$CUSTID/?serviceName=Process/SelfDemoSetup/SelfDemoSetup&processName=Process%2FSelfDemoSetup%2FCreate_ME" \
    -d '{ "managed_device_name": "NEC_NFA",  "model_id": "17111602", "manufacturer_id": "70000",  "password": "ubiqube",  "snmpCommunity": "ubiqube",  "password_admin": "aaaa",  "managementInterface": "eth0",  "device_ip_address": "192.168.1.1",  "login": "msa"}'


echo