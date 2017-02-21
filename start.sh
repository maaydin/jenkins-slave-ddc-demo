#!/bin/bash
set -e
export HTTP_PROXY=${http_proxy}
export HTTPS_PROXY=${https_proxy}

if [[ ! -z ${ucp_address} ]]
    then
        AUTHTOKEN=$(curl -sk -d '{"username":"'"${ucp_user}"'","password":"'"${ucp_pass}"'"}' https://${ucp_address}/auth/login | awk -F "\"" '{print $4}');
        curl -k -H "Authorization: Bearer $AUTHTOKEN" --retry 3 --retry-delay 5  https://${ucp_address}/api/clientbundle -o bundle.zip;
        unzip bundle.zip;
        eval $(<env.sh);
fi

curl -v --retry 10 --retry-delay 6  -o /opt/jenkins/slave.jar ${jenkins_url}jnlpJars/slave.jar

if [[ ! -z ${secret} ]]
	then
		java -Xms32m -Xmx128m -jar /opt/jenkins/slave.jar -jnlpUrl ${jenkins_url}computer/${node_name}/slave-agent.jnlp -secret ${secret}
else
	java -Xms32m -Xmx128m -jar /opt/jenkins/slave.jar -jnlpUrl ${jenkins_url}computer/${node_name}/slave-agent.jnlp
fi