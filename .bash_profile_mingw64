export ANDROID_HOME=C:\\SDK

alias ebm="vim ~/.bash_profile_mingw64"
alias si="kill ; server && maven && integrations"
alias sic="kill ; server && maven && integrations && load_catalog_data"
alias sicw="kill ; server && maven && integrations && load_catalog_data && webclient"
alias siw="kill ; server && maven && integrations && webclient"
alias skw="kill ; server && maven && keycloak && webclient"
alias ss="kill ; server && maven"
alias sw="kill ; server && maven && webclient"
alias slw="kill ; server && maven && locking_tool && webclient"

kill() {
    heading "TERMINATING PROCESSES"
    taskkill //F //IM node.exe //IM java.exe
    # alternativa: wmic Path win32_process Where "CommandLine Like '%%java%%'" call terminate
}

server() {
    heading "INSTALLING FHIR SERVER"
    cd $(git rev-parse --show-toplevel)/services
    sedi 's/DC1-ORAC005/buc-proj001/' gradle.properties
    ./gradlew installServer
}

keycloak() {
    heading "STARTING KEYCLOAK SERVER"
    cd $(git rev-parse --show-toplevel)/keycloak
    ./gradlew installServer
}

depot() {
    heading "STARTING DEPOT SERVER"
    cd $(git rev-parse --show-toplevel)/services
    ./gradlew installServerDepot
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
    cd $(git rev-parse --show-toplevel)/integrations/datasource/src/test/resources/config/
    sedi 's/dc1-orac005/buc-proj001/' datasource.properties
    sedi 's/dc1-orac005/buc-proj001/' datasource-oracle.properties
    cd $(git rev-parse --show-toplevel)/integrations
    #./installServer.bat
    #./gradlew clean dbClean dbBootstrap installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
    #./gradlew clean installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
    ./gradlew installTestServer startTestServer
    #./gradlew clean dbClean installTestServer :signaturecentral:deploy :cpr:deploy startTestServer
}

locking_tool() {
    heading "STARTING LOCKING RESOURCES TOOL"
    pushd $(git rev-parse --show-toplevel)/services
    ./gradlew :installation:deployTest
    popd
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
