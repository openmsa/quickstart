#!/bin/bash
#set -x

PROG=$(basename $0)

DEV_BRANCH=default_dev_branch
DEFAULT_BRANCH=2.2.0GA

install_license() {

    echo "-------------------------------------------------------"
    echo "INSTALL EVAL LICENSE"
    echo "-------------------------------------------------------"
    if [ -z "$1"  ]
    then
        /usr/bin/install_license.sh
        if [ $? -ne 0 ]; then
            exit 1
        fi
    else
        echo "skipping license installation"
    fi
}

init_intall() {
    
    git config --global alias.lg "log --graph --pretty=format:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(bold blue)<%an>%C(reset) %C(green)(%ar)%C(reset)' --abbrev-commit --date=relative"; \
    git config --global push.default simple; \
    
    mkdir -p /opt/fmc_entities; \
    mkdir -p /opt/fmc_repository/CommandDefinition; \
    mkdir -p /opt/fmc_repository/CommandDefinition/microservices; \
    mkdir -p /opt/fmc_repository/Configuration; \
    mkdir -p /opt/fmc_repository/Datafiles; \
    mkdir -p /opt/fmc_repository/Documentation; \
    mkdir -p /opt/fmc_repository/Firmware; \
    mkdir -p /opt/fmc_repository/License; \
    mkdir -p /opt/fmc_repository/Process; \

    chown -R ncuser.ncuser /opt/fmc_repository /opt/fmc_entities
    
}


update_github_repo() {
    echo "-------------------------------------------------------------------------------"
    echo " Update the github repositories "
    echo "-------------------------------------------------------------------------------"
    git config --global user.email devops@openmsa.co
    cd /opt/devops ; 
    echo ">> https://github.com/openmsa/Adapters.git "
    if [ -d OpenMSA_Adapters ]; 
    then 
        cd OpenMSA_Adapters
        ## get current branch and store in variable CURRENT_BR
        CURRENT_BR=`git rev-parse --abbrev-ref HEAD`
        echo "> Current working branch: $CURRENT_BR"
        git stash;
        echo "> Check out $DEFAULT_BRANCH and getting the latest code"
        git checkout $DEFAULT_BRANCH;
        git pull;
        echo "> Back to working branch"
        git checkout $CURRENT_BR
        git stash pop
    else 
        git clone https://github.com/openmsa/Adapters.git OpenMSA_Adapters
        cd OpenMSA_Adapters
        git checkout $DEFAULT_BRANCH;
        echo "> Create a new developement branch: $DEV_BRANCH based on $DEFAULT_BRANCH"
        git checkout -b $DEV_BRANCH
    fi;
    ### MS ###
    echo ">> https://github.com/openmsa/Microservices.git "
    cd /opt/fmc_repository ; 
    if [ -d OpenMSA_MS ]; 
    then  
        cd OpenMSA_MS; 
        ## get current branch and store in variable CURRENT_BR
        CURRENT_BR=`git rev-parse --abbrev-ref HEAD`
        echo "> Current working branch: $CURRENT_BR"
        git stash;
        echo "> Check out $DEFAULT_BRANCH and getting the latest code"
        git checkout $DEFAULT_BRANCH;
        git pull;
        echo "> Back to working branch"
        git checkout $CURRENT_BR
        git stash pop
    else 
        git clone https://github.com/openmsa/Microservices.git OpenMSA_MS
        cd OpenMSA_MS
        git checkout $DEFAULT_BRANCH;
        echo "> Create a new developement branch: $DEV_BRANCH based on $DEFAULT_BRANCH"
        git checkout -b $DEV_BRANCH
    fi;
    ### WF ###
    echo ">> https://github.com/openmsa/Workflows.git "
    cd /opt/fmc_repository ; 
    if [ -d OpenMSA_WF ]; 
    then 
        cd OpenMSA_WF;
        ## get current branch and store in variable CURRENT_BR
        CURRENT_BR=`git rev-parse --abbrev-ref HEAD`
        echo "> Current working branch: $CURRENT_BR"
        git stash;
        echo "> Check out $DEFAULT_BRANCH and getting the latest code"
        git checkout $DEFAULT_BRANCH;
        git pull;
        echo "> Back to working branch"
        git checkout $CURRENT_BR
        git stash pop
    else 
        git clone https://github.com/openmsa/Workflows.git OpenMSA_WF; 
        cd OpenMSA_WF;
        git checkout $DEFAULT_BRANCH;
        echo "> Create a new developement branch: $DEV_BRANCH based on $DEFAULT_BRANCH"
        git checkout -b $DEV_BRANCH
    fi ; 
    ### Etsi-Mano ###
    echo ">> https://github.com/openmsa/etsi-mano.git "
    cd /opt/fmc_repository ; 
    if [ -d OpenMSA_MANO ]; 
    then 
        cd OpenMSA_MANO; 
        git pull; 
    else 
        git clone https://github.com/openmsa/etsi-mano.git OpenMSA_MANO; 
        cd OpenMSA_MANO; 
    fi ; 
    cd -; 
    echo ">> Install the quickstart from https://github.com/ubiqube/quickstart.git"
    cd /opt/fmc_repository ; 
    if [ -d /opt/fmc_repository/quickstart ]; 
    then 
        cd quickstart; 
        git stash;
        git checkout $DEFAULT_BRANCH;
        git pull;
    else 
        git clone https://github.com/ubiqube/quickstart.git quickstart; 
        cd quickstart; 
        git checkout $DEFAULT_BRANCH;
    fi ;
}

uninstall_adapter() {
    DEVICE_DIR=$1
    echo "-------------------------------------------------------------------------------"
    echo " Uninstall $DEVICE_DIR adapter source code from github repo "
    echo "-------------------------------------------------------------------------------"
    /opt/devops/OpenMSA_Adapters/bin/da_installer uninstall /opt/devops/OpenMSA_Adapters/adapters/$DEVICE_DIR
}

#
# $2 : installation mode: DEV_MODE = create symlink / USER_MODE = copy code
#
install_adapter() {
    DEVICE_DIR=$1
    MODE=$2
    echo "-------------------------------------------------------------------------------"
    echo " Install $DEVICE_DIR adapter source code from github repo "
    echo "-------------------------------------------------------------------------------"

    /opt/devops/OpenMSA_Adapters/bin/da_installer install /opt/devops/OpenMSA_Adapters/adapters/$DEVICE_DIR $MODE
    echo "DONE"

}

install_microservices () {
    
    echo "-------------------------------------------------------------------------------"
    echo " Install some MS from OpenMSA github repo"
    echo "-------------------------------------------------------------------------------"
    cd /opt/fmc_repository/CommandDefinition/; 
    echo "  >> ADVA"
    ln -fsn ../OpenMSA_MS/ADVA ADVA; ln -fsn ../OpenMSA_MS/.meta_ADVA .meta_ADVA; 
    echo "  >> ANSIBLE"
    ln -fsn ../OpenMSA_MS/ANSIBLE ANSIBLE; ln -fsn ../OpenMSA_MS/.meta_ANSIBLE .meta_ANSIBLE; 
    echo "  >> AWS"
    ln -fsn ../OpenMSA_MS/AWS AWS; ln -fsn ../OpenMSA_MS/.meta_AWS .meta_AWS; 
    echo "  >> CHECKPOINT"
    ln -fsn ../OpenMSA_MS/CHECKPOINT CHECKPOINT; ln -fsn ../OpenMSA_MS/.meta_CHECKPOINT .meta_CHECKPOINT; 
    echo "  >> CISCO"
    ln -fsn ../OpenMSA_MS/CISCO CISCO; ln -fsn ../OpenMSA_MS/.meta_CISCO .meta_CISCO; 
    echo "  >> CITRIX"
    ln -fsn ../OpenMSA_MS/CITRIX CITRIX; ln -fsn ../OpenMSA_MS/.meta_CITRIX .meta_CITRIX; 
    echo "  >> FLEXIWAN"
    ln -fsn ../OpenMSA_MS/FLEXIWAN FLEXIWAN; ln -fsn ../OpenMSA_MS/.meta_FLEXIWAN .meta_FLEXIWAN; 
    echo "  >> FORTINET"
    ln -fsn ../OpenMSA_MS/FORTINET FORTINET; ln -fsn ../OpenMSA_MS/.meta_FORTINET .meta_FORTINET; 
    echo "  >> JUNIPER"
    ln -fsn ../OpenMSA_MS/JUNIPER JUNIPER; ln -fsn ../OpenMSA_MS/.meta_JUNIPER .meta_JUNIPER;
    rm -rf  JUNIPER/SSG
    echo "  >> LINUX"
    ln -fsn ../OpenMSA_MS/LINUX LINUX; ln -fsn ../OpenMSA_MS/.meta_LINUX .meta_LINUX; 
    echo "  >> MIKROTIK"
    ln -fsn ../OpenMSA_MS/MIKROTIK MIKROTIK; ln -fsn ../OpenMSA_MS/.meta_MIKROTIK .meta_MIKROTIK; 
    echo "  >> OPENSTACK"
    ln -fsn ../OpenMSA_MS/OPENSTACK OPENSTACK; ln -fsn ../OpenMSA_MS/.meta_OPENSTACK .meta_OPENSTACK; 
    echo "  >> ONEACCESS"
    ln -fsn ../OpenMSA_MS/ONEACCESS ONEACCESS; ln -fsn ../OpenMSA_MS/.meta_ONEACCESS .meta_ONEACCESS; 
    echo "  >> PALOALTO"
    ln -fsn ../OpenMSA_MS/PALOALTO PALOALTO; ln -fsn ../OpenMSA_MS/.meta_PALOALTO .meta_PALOALTO; 
    echo "  >> PFSENSE"
    ln -fsn ../OpenMSA_MS/PFSENSE PFSENSE; ln -fsn ../OpenMSA_MS/.meta_PFSENSE .meta_PFSENSE; 
    echo "  >> REDFISHAPI"
    ln -fsn ../OpenMSA_MS/REDFISHAPI REDFISHAPI; ln -fsn ../OpenMSA_MS/.meta_REDFISHAPI .meta_REDFISHAPI; 
    echo "  >> REST"
    ln -fsn ../OpenMSA_MS/REST REST; ln -fsn ../OpenMSA_MS/.meta_REST .meta_REST; 
    echo "  >> ETSI-MANO"
    ln -fsn ../OpenMSA_MS/NFVO NFVO;  ln -fsn ../OpenMSA_MS/.meta_NFVO .meta_NFVO
    ln -fsn ../OpenMSA_MS/VNFM VNFM; ln -fsn ../OpenMSA_MS/.meta_VNFM .meta_VNFM
    ln -fsn ../OpenMSA_MS/KUBERNETES KUBERNETES; ln -fsn ../OpenMSA_MS/.meta_KUBERNETES .meta_KUBERNETES
    echo "  >> NETBOX"
    ln -fsn ../OpenMSA_MS/NETBOX NETBOX; ln -fsn ../OpenMSA_MS/.meta_NETBOX .meta_NETBOX; 

    echo "DONE"

}

install_workflows() {

    echo "-------------------------------------------------------------------------------"
    echo " Install some WF from OpenMSA github github repository"
    echo "-------------------------------------------------------------------------------"
    cd /opt/fmc_repository/Process; \
    echo "  >> WF references and libs"
    ln -fsn ../OpenMSA_WF/Reference Reference; \
    ln -fsn ../OpenMSA_WF/.meta_Reference .meta_Reference; \
    echo "  >> WF tutorials"
    ln -fsn ../OpenMSA_WF/Tutorials Tutorials; \
    ln -fsn ../OpenMSA_WF/.meta_Tutorials .meta_Tutorials; \
    echo "  >> BIOS_Automation"
    ln -fsn ../OpenMSA_WF/BIOS_Automation BIOS_Automation
    ln -fsn ../OpenMSA_WF/.meta_BIOS_Automation .meta_BIOS_Automation
 #   echo "  >> ETSI-MANO"
 #   ln -fsn ../OpenMSA_MANO/WORKFLOWS/ETSI-MANO ETSI-MANO
 #   ln -fsn ../OpenMSA_MANO/WORKFLOWS/.meta_ETSI-MANO .meta_ETSI-MANO
    echo "  >> Private Cloud - Openstack"
    ln -fsn ../OpenMSA_WF/Private_Cloud Private_Cloud
    ln -fsn ../OpenMSA_WF/.meta_Private_Cloud .meta_Private_Cloud
    echo "  >> Ansible"
    ln -fsn ../OpenMSA_WF/Ansible Ansible
    ln -fsn ../OpenMSA_WF/.meta_Ansible .meta_Ansible
    echo "  >> Public Cloud - AWS"
    ln -fsn ../OpenMSA_WF/Public_Cloud Public_Cloud
    ln -fsn ../OpenMSA_WF/.meta_Public_Cloud .meta_Public_Cloud
    echo "  >> Topology"
    ln -fsn ../OpenMSA_WF/Topology Topology
    ln -fsn ../OpenMSA_WF/.meta_Topology .meta_Topology
    echo "  >> MSA / Utils"
    ln -fsn ../OpenMSA_WF/Utils/Manage_Device_Conf_Variables Manage_Device_Conf_Variables
    ln -fsn ../OpenMSA_WF/Utils/.meta_Manage_Device_Conf_Variables .meta_Manage_Device_Conf_Variables


    echo "-------------------------------------------------------------------------------"
    echo " Install mini lab setup WF from quickstart github repository"
    echo "-------------------------------------------------------------------------------"
    ln -fsn ../quickstart/lab/msa_dev/resources/libraries/workflows/SelfDemoSetup SelfDemoSetup; \
    ln -fsn ../quickstart/lab/msa_dev/resources/libraries/workflows/.meta_SelfDemoSetup .meta_SelfDemoSetup; \

    echo "DONE"

}

install_adapters() {
    #install_adapter a10_thunder
    install_adapter a10_thunder_axapi
    install_adapter adtran_generic
    install_adapter adva_nc
    install_adapter ansible_generic
    install_adapter aws_generic
    install_adapter brocade_vyatta
    install_adapter catalyst_ios
    install_adapter checkpoint_r80
    install_adapter cisco_apic
    install_adapter cisco_asa_generic
    install_adapter cisco_asa_rest
    #install_adapter cisco_asr
    install_adapter cisco_isr
    #install_adapter cisco_nexus9000
    install_adapter citrix_adc
    install_adapter esa
    install_adapter f5_bigip
    install_adapter fortigate
    #install_adapter fortinet_fortianalyzer
    #install_adapter fortinet_fortimanager
    install_adapter fortinet_generic
    #install_adapter fortinet_jsonapi
    install_adapter fortiweb
    install_adapter fujitsu_ipcom
    install_adapter hp2530
    install_adapter hp5900
    install_adapter huawei_generic
    #install_adapter juniper_contrail
    install_adapter juniper_rest
    install_adapter juniper_srx
    install_adapter kubernetes_generic
    install_adapter linux_generic
    install_adapter mikrotik_generic
    install_adapter mon_checkpoint_fw
    install_adapter mon_cisco_asa
    install_adapter mon_cisco_ios
    install_adapter mon_fortinet_fortigate
    install_adapter mon_generic
    install_adapter nec_intersecvmlb
    install_adapter nec_intersecvmsg
    install_adapter nec_ix
    install_adapter nec_nfa
    install_adapter nec_pflow_p4_unc
    install_adapter nec_pflow_pfcscapi
    install_adapter netconf_generic
    install_adapter nfvo_generic
    install_adapter nokia_cloudband
    install_adapter nokia_vsd
    install_adapter oneaccess_lbb
    install_adapter oneaccess_netconf
    install_adapter oneaccess_whitebox
    install_adapter opendaylight
    install_adapter openstack_keystone_v3
    install_adapter paloalto
    install_adapter paloalto_chassis
    install_adapter paloalto_generic
    install_adapter paloalto_vsys
    install_adapter pfsense_fw
    install_adapter rancher_cmp
    install_adapter redfish_generic
    install_adapter rest_generic
    install_adapter rest_netbox
    #install_adapter stormshield
    install_adapter veex_rtu
    install_adapter versa_analytics
    install_adapter versa_appliance
    install_adapter versa_director
    install_adapter virtuora_nc
    install_adapter vmware_vsphere
    install_adapter vnfm_generic
    install_adapter wsa
}

finalize_install() {
    echo "-------------------------------------------------------------------------------"
    echo " Removing OneAccess Netconf MS definition with advanced variable types"
    echo "-------------------------------------------------------------------------------"
    rm -rf /opt/fmc_repository/OpenMSA_MS/ONEACCESS/Netconf/Advanced 
    rm -rf /opt/fmc_repository/OpenMSA_MS/ONEACCESS/Netconf/.meta_Advanced
    echo "DONE"

    echo "-------------------------------------------------------------------------------"
    echo " update file owner to ncuser.ncuser"
    echo "-------------------------------------------------------------------------------"
    chown -R ncuser:ncuser /opt/fmc_repository/*; \
    chown -R ncuser:ncuser /opt/fmc_repository/.meta_*; \
    chown -R ncuser.ncuser /opt/devops/OpenMSA_Adapters

    echo "DONE"

    echo "-------------------------------------------------------------------------------"
    echo " service restart"
    echo "-------------------------------------------------------------------------------"
    echo "  >> execute [sudo docker-compose restart msa_api] to restart the API service"
    echo "  >> execute [sudo docker-compose restart msa_sms] to restart the CoreEngine service"
    echo "DONE"
}

usage() {
	echo "usage: $PROG [all|ms|wf|da] [--no-lic]"
    echo "this script installs some librairies available @github.com/openmsa"
	echo
	echo "all (default): install everyting: worflows, microservices and adapters"
	echo "ms: install the microservices from https://github.com/openmsa/Microservices"
	echo "wf: install the worflows from https://github.com/openmsa/Workflows"
	echo "da: install the adapters from https://github.com/openmsa/Adapters"
    exit 0
}

main() {


	cmd=$1
    option=$2
	shift
	case $cmd in
		""|all)
            install_license $option
            init_intall
            update_github_repo
            install_microservices;
            install_workflows;
            install_adapters;
			;;
		ms)
            install_license  $option
            init_intall
            update_github_repo
			install_microservices 
			;;
		wf)
            install_license  $option
            init_intall
            update_github_repo
			install_workflows 
			;;
		da)
            install_license  $option
            init_intall
            update_github_repo
			install_adapters
			;;

		*)
            echo "Error: unknown command: $1"
            usage
			;;
	esac
    finalize_install
}


main "$@"
