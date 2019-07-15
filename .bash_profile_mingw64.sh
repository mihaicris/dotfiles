export ANDROID_HOME=C:\\SDK

alias ebm="vim ~/.bash_profile_mingw64"

kill_java_node() {
    heading "TERMINATING PROCESSES"
    taskkill //F //IM node.exe //IM java.exe
}

fhirserver() {
    heading "INSTALLING FHIR SERVER"
    pushd $(git rev-parse --show-toplevel)/services
    sedi 's/DC1-ORAC005/buc-proj001/' gradle.properties
    ./gradlew installServer
    popd
}

keycloak() {
    heading "STARTING KEYCLOAK SERVER"
    pushd $(git rev-parse --show-toplevel)/keycloak
    ./gradlew installServer
    popd
}

depot() {
    heading "STARTING DEPOT SERVER"
    pushd $(git rev-parse --show-toplevel)/services
    ./gradlew installServerDepot
    popd
}

client() {
    android
}

webclient() {
    heading "STARTING WEB CLIENT"
    cd $(git rev-parse --show-toplevel)/webclient
    sedi 's/DC1-ORAC005/buc-proj001/' admin/gradle.properties
    sedi 's/DC1-ORAC005/buc-proj001/' depot/gradle.properties
    sedi 's/da_DK/en_US/' admin/src/main/assets/angular/app.js
    ./gradlew bootRun 
}

integrations() {
    heading "STARTING INTEGRATIONS SERVER"
    pushd $(git rev-parse --show-toplevel)/integrations/datasource/src/test/resources/config/
    sedi 's/dc1-orac005/buc-proj001/' datasource.properties
    sedi 's/dc1-orac005/buc-proj001/' datasource-oracle.properties
    pushd $(git rev-parse --show-toplevel)/integrations
    #./installServer.bat
    #./gradlew clean dbClean dbBootstrap installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
    #./gradlew clean installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
    ./gradlew installTestServer startTestServer
    #./gradlew clean dbClean installTestServer :signaturecentral:deploy :cpr:deploy startTestServer
    popd
    popd
}

locking_tool() {
    heading "STARTING LOCKING RESOURCES TOOL"
    pushd $(git rev-parse --show-toplevel)/services
    ./gradlew :installation:deployTest
    popd
}


ss() {
	heading "WELCOME TO CURA BUILD SCRIPT"
	echo "Type letters to start each corresponding target:"
	echo ""
	echo "  k  =>  KEYCLOAK"
	echo "  s  =>  FHIR SERVER"
	echo "  l  =>  LOCKING TOOL"
	echo "  i  =>  INTEGRATIONS"
	echo "  w  =>  WEB CLIENT"
	echo ""
	echo "Press x to exit"
	echo ""
		
	read -p "Input selection: " sel
	
	if [ -z "$sel" ]; then
		echo "No input. EXIT"
	else 
		echo ""
		gen="kill_java_node ; echo ''"
		if [[ $sel == *"k"* ]]; then
			gen="${gen} && keycloak"
		fi
		
		if [[ $sel == *"s"* ]]; then
			gen="${gen} && fhirserver"
		fi
		
		if [[ $sel == *"l"* ]]; then
			gen="${gen} && locking_tool"
		fi
		
		if [[ $sel == *"i"* ]]; then
			gen="${gen} && integrations"
		fi
		
		if [[ $sel == *"w"* ]]; then
			gen="${gen} && webclient"
		fi
		echo "Start building..."
		eval $gen
	fi
}

load_catalog_data() {
    heading "LOAD CATALOG DATA"

    cd $(git rev-parse --show-toplevel)/integrations/build/eap/jboss-eap-7.0/standalone/deployments/

    echo "Task: Undeploy CPR module"
    cd ../deployments/
    rm cpr.war.deployed
    while [ ! -f cpr.war.undeployed ]; do sleep 1; done

    echo "Task: Patch CPR environment properties"
    cd ../properties/
    sedi 's/SKRS_MAX_RECORDS_PER_ITERATION=100/SKRS_MAX_RECORDS_PER_ITERATION=2000/' cpr-environment.properties
    sedi 's/SKRS_MAX_RECORDS_PER_TRIGGERING=100/SKRS_MAX_RECORDS_PER_TRIGGERING=-1/' cpr-environment.properties

    echo "Task: Redeploy CPR module"
    cd ../deployments/
    rm cpr.war.undeployed
    while [ ! -f cpr.war.deployed ]; do sleep 1; done

    echo "Task: Load Catalog Data"
    curl "http://localhost:8100/cpr/forceSkrsImport/"

    cd $(git rev-parse --show-toplevel)/
    echo "Done."
}
