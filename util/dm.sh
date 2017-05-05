#!/bin/bash
#
# Simple Documaker menu control using dialog
#
DOCKER_CONTAINER_DB=6562bd2a823b
DOCKER_CONTAINER_WLS=21533abbd85f
DOCKER_CONTAINER_FACTORY=237b7d2742b6
#
# Here be dragons.
#
SCRIPT=$0
INPUT=/tmp/menu.sh.$$
STATE=
VMNAME=
OUTPUT=/tmp/output.sh.$$
OUTPUT1=/tmp/output1.sh.$$

trap "rm $OUTPUT1; rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM
function goDocker(){
	command -v dock >/dev/null 2>&1 || { echo >&2 "It looks like you don't have dock. See https://github.com/calittle/docker. Aborting."; exit 1; }
        dock;
        mainmenu;
}
function checkContainer(){
	STATE=$(docker inspect --format='{{.State.Status}}' $1)
	if [ $STATE != "running" ]; then
                dialog --color --title "WARNING" --msgbox "Container $1 appears to be \Zb\Z1${STATE}\Zn.\nInvoking Docker Command Center." 8 75
		goDocker;
        else
                dialog --title "Container Status" --msgbox "$2 Container is ${STATE}." 5 55
        fi
}
function pickcontainer(){
	docker ps -f "status=running" --format "{{.ID}} \"{{.Names}}-RUNNING\"" > $OUTPUT
        docker ps -f "status=paused" --format "{{.ID}} \"{{.Names}}-PAUSED\"" >> $OUTPUT
        docker ps -f "status=exited" --format "{{.ID}} \"{{.Names}}-EXITED\"" >> $OUTPUT
        dialog --clear --backtitle "Docker Command Menu" --title "[ Container Control Panel: List Containers ]" --menu "Select a Container to control" 25 75 10 $(<"${OUTPUT}") 2>"${INPUT}"
        VMNAME=$(<"${INPUT}")
}

function setValue(){
	if [ $2 = "1" ]; then
		MENUNOTE="Looks like the container set for ${1} does not exist.\nWant to set that now?" 
	elif [ $2 = "2" ]; then
		MENUNOTE="Want to set ${1} now?"
	else
		MENUNOTE="Looks like you haven't set the ${1} value.\nWant to set that now?"
	fi

	dialog --title "Confirm" --yesno "$MENUNOTE" 8 75

	if [ $? = 0 ]; then
		pickcontainer                
		dialog --title "INFO" --msgbox "Selected container: ${VMNAME}" 5 55
		sed -i.bak "s/^$1=.*/$1=$VMNAME/" $0
	        exec $0	
        #else
        #       dialog --title "WARNING" --msgbox "Please edit this script and set the ${1} value." 8 75
        fi
}
function checkSetup(){
	if [ 1$DOCKER_CONTAINER_DB = "1" ]; then
		setValue "DOCKER_CONTAINER_DB" 
	else
		docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_DB 
		if [ $? = "1" ]; then
			setValue "DOCKER_CONTAINER_DB" 1
		fi
	fi
	if [ 1$DOCKER_CONTAINER_WLS = "1" ]; then
                setValue "DOCKER_CONTAINER_WLS" 
	else
		docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_WLS
		if [ $? = "1" ]; then
                        setValue "DOCKER_CONTAINER_WLS" 1
                fi
	fi
	if [ 1$DOCKER_CONTAINER_FACTORY = "1" ]; then
		setValue "DOCKER_CONTAINER_FACTORY"
	else
		docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_FACTORY
                if [ $? = "1" ]; then
                        setValue "DOCKER_CONTAINER_FACTORY" 1
                fi
        fi
}
function changemenu(){
	dialog --clear --backtitle "Documaker Command Center" --title "[ Documaker Control Center Settings ]" --menu "Change a setting:" 25 55 10 Database "Change Database container ID" AppServer "Change AppServer container ID" Factory "Change Factory container ID" Return "Return to main menu" 2>"${INPUT}"
	menuitem=$(<"${INPUT}")
	case $menuitem in
		Database) setValue "DOCKER_CONTAINER_DB" 2;;
		AppServer) setValue "DOCKER_CONTAINER_WLS" 2;;
		Factory) setValue "DOCKER_CONTAINER_FACTORY" 2;;
		Return) mainmenu;;
		*) mainmenu;;
	esac
}
function mainmenu(){

	checkSetup;

	DBSTATE=$(docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_DB)
	WLSSTATE=$(docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_WLS)
	FACTORYSTATE=$(docker inspect --format='{{.State.Status}}' $DOCKER_CONTAINER_FACTORY)


	if [ $DBSTATE != "running" ]; then
		DBSTATE="Database container is \Zb\Z1$DBSTATE\Zn."
	else
		DBSTATE="Database container is $DBSTATE.\n"
	fi
        if [ $WLSSTATE != "running" ]; then
                WLSSTATE="AppServer is \Zb\Z1$WLSSTATE\Zn."
        else
                WLSSTATE="AppServer is $WLSSTATE.\n"	
	fi
        if [ $FACTORYSTATE != "running" ]; then
               FACTORYSTATE="Factory is \Zb\Z1$FACTORYSTATE\Zn."
        else
               FACTORYSTATE="Factory is $FACTORYSTATE.\n"
	fi	
	dialog --colors --clear --backtitle "Documaker Command Center" --title "[ Documaker Control Center ]" --menu "${DBSTATE}${WLSSTATE}${FACTORYSTATE}\n\nSelect an operation:" 25 55 10 Database "Check DB Status" AppServer "Check WLS Status" Factory "Check DocFactory" Change "Change Settings" Docker "Go to Docker Command" Exit "Exit" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")
	case $menuitem in
		Database) checkContainer $DOCKER_CONTAINER_DB Database;;
		AppServer) checkContainer $DOCKER_CONTAINER_WLS AppServer;;		
		Factory) checkContainer $DOCKER_CONTAINER_FACTORY Factory;;
		Docker) goDocker;;
		Change) changemenu;;
		Exit) break;;
		*) break;;
	esac
		
}

while true
do
       mainmenu;
done

# if temp files found, delete em
[ -f $OUTPUT1 ] && rm $OUTPUT1
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
