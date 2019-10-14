export ANDROID_HOME=C:\\SDK

alias emulator='./emulator.exe'
alias adb='./adb.exe'

kill_java_node() {
    heading "Terminating Processes"
    taskkill //F //IM node.exe //IM java.exe
}

fhirserver() {
    heading "Starting FHIR Server"
    pushd $(git rev-parse --show-toplevel)/services
    sedi 's/DC1-ORAC005/buc-proj001/' gradle.properties
    ./gradlew installServer
    popd
}

keycloak() {
    heading "Starting Keycloak Server"
    pushd $(git rev-parse --show-toplevel)/keycloak
    ./gradlew installServer
    popd
}

depot() {
    heading "Starting Depot Server"
    pushd $(git rev-parse --show-toplevel)/services
    ./gradlew installServerDepot
    popd
}

client() {
    android
}

webclient() {
    heading "Starting Web Client"
    pushd $(git rev-parse --show-toplevel)/webclient/cura_vanilla
    sedi 's/DC1-ORAC005/buc-proj001/' gradle.properties
    sedi 's/da_DK/en_US/' src/main/assets/angular/app.js
    ./gradlew fullBootRun
}

integrations() {
    heading "Starting Integrations Server"
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
    heading "Starting Locking Resources Tool"
    pushd $(git rev-parse --show-toplevel)/services
    ./gradlew :installation:deployTest
    popd
}


ss() {
	heading "Welcome to Cura Build Script"
	echo "Type letters to include each corresponding target:"
	echo ""
	echo "  S  =>  FHIR Server"
    echo "  W  =>  Web Client"
    echo "  K  =>  Keycloak"
	echo "  L  =>  Locking Tool"
	echo "  I  =>  Integrations"
	echo ""
	echo "Press x to exit"
	echo ""
		
	read -p "Input selection: " sel
	
	if [[ $sel == *"x"* ]]; then
		echo "No valid input. Exiting..."
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
		echo "Start building"
		eval $gen
	fi
}

load_catalog_data() {
    heading "Load Catalog Data"

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
