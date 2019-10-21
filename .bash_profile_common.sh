pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

heading() {
    echo -e "\n\033[7m\033[034m$@\033[0m\n"
}

gr() {
	if $(git rev-parse &>/dev/null ); then 
		heading 'Changing to git root folder'
		cd $(git rev-parse --show-toplevel)
		echo "Done."
	else
		echo 'Not a git repository.'
	fi
}

ggfa() {
    prune
    fetch
    status
}

rr() {
    unstage
    discard
    status
}

rrr() {
    unskipAll
    unstage
    discard
    status
}

rrrr() {
    unskipAll
    unstage
    discard
    clean_untracked
    status
}

rrrrr() {
    unskipAll
    unstage
    discard
    gclean
    status
}

prune() {
    heading 'Pruning branches'
    git remote prune origin
}

fetch() {
    heading 'Fetching remotes'
    git fetch --prune --all --tags
}

status() {
    heading 'Status'
    git status
    echo ""
}

unstage() {
    heading 'Unstaging local changes'
    files=`git diff --name-only --cached`
    if [[ ${#files} -gt 0 ]]; then
        git diff --name-only --cached | cat
        echo ""
        git reset HEAD --quiet
    else
        echo -e "* Nothing to unstage."
    fi
}

discard() {
    heading 'Discarding local changes'
    pushd $(git rev-parse --show-toplevel)
    files=`git diff --name-only`
    if [[ ${#files} -gt 0 ]]; then
        git diff --name-only | cat
        git checkout . --quiet
    else
        echo -e "* Nothing to discard."
    fi
    popd
}

clean_untracked() {
    heading 'Cleaning untracked files'
    files=`git clean -fdn`
    if [[ ${#files} -gt 0 ]]; then
        git clean -fd
    else
        echo -e "* Nothing to clean."
    fi
}

gclean() {
    heading 'Cleaning ignored files'
    pushd $(git rev-parse --show-toplevel)
    files=`git clean -xdfn -e Carthage/`
    if [[ ${#files} -gt 0 ]]; then
        git clean -xdf -e Carthage/
    else
        echo -e "* Nothing to clean."
    fi
    popd
}

recreate_files() {
	heading 'Recreating all files'
	pushd $(git rev-parse --show-toplevel)
	git rm --cached -r .
	git reset --hard
	popd
}

unskipAll() {
    heading 'Reactivating skipped files from git'
    files=`git ls-files -v | grep '^S' | cut -d ' ' -f 2`
    if [[ ${#files} -gt 0 ]]; then
        git ls-files -v | grep '^S' | cut -d ' ' -f 2
        echo ""
        git ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git update-index --no-skip-worktree
    else 
        echo -e "* Nothing to reactivate."
    fi
}

skip() {
    git update-index --skip-worktree "$@"
}

unskip() {
    git update-index --no-skip-worktree "$@"
}

hh() {
    heading "Detaching HEAD to previous commit"
    git checkout HEAD~1
    echo ""
}

check() {
    heading 'Skipped files'
    git ls-files -v | grep '^S' | cut -d ' ' -f 2
    echo ""
}

sedi() {
    sed --version >/dev/null 2>&1 && sed -b -i -- "$@" || sed -i "" "$@"
}

ccb() {
    criteria="$@"
    prefix="origin/"

    if [ -z "$criteria" ]
    then
          echo -e "\n\033[92mPlease specifiy a string contained in the branch.\033[0m\n"
    else
        branch_name_remote=$(git branch -r | grep $criteria)
        count=`git branch -r | grep $criteria | wc -l`
        if [[ $count -lt 1 ]]; then
            echo -e "\nThere are no remote branches containing \033[91m$criteria\033[0m.\n"
            return 0
        fi

        if [[ $count -gt 1 ]]; then
            echo -e "\nThere are multiple branches containing \033[91m$criteria\033[0m:"
            echo -e "\033[34m"
            git branch -r | grep $criteria
            echo -e "\033[0m"
            return 0
        fi
        branch_name=`echo $branch_name_remote | sed 's/^origin\///'`
        isLocalBranch=`git branch | grep $branch_name`
        if [ ! -z "$isLocalBranch" ]
        then
            status=`git checkout -q $branch_name`
            status=$?
            if [ $status -eq 0 ] ; then
                echo -e "\nLocal branch \033[92m$branch_name\033[0m successfuly checked out.\n"
                return 0
            else
                echo -e "\nCould not checkout branch:\n\033[34m$branch_name\033[0m.\n"
                return 1
            fi
        else
            status=`git checkout -q -b $branch_name --track $branch_name_remote`
            status=$?
            if [ $status -eq 0 ] ; then
                echo -e "\nRemote branch \033[92m$branch_name\033[0m successfuly checked out locally.\n"
                return 0
            fi
        fi
    fi
}

devteam() {
    if [ -z "$1" ]; then
        team="S8V3V9GFN2"
    else
        team=$1
    fi
    pushd $(git rev-parse --show-toplevel)
    files=$(find . -name "project.pbxproj" | xargs)
    sedi "s/\(DEVELOPMENT_TEAM = \).*\;/\1$team\;/g" $files
    popd
}

maven() {
    heading "Publishing artifacts to local Maven"
    pushd $(git rev-parse --show-toplevel)/servicesapi
    chmod +x gradlew
    ./gradlew publishToMavenLocalApi
    popd
}

gen_swift() {
    pushd $(git rev-parse --show-toplevel)/ios/CuraFHIR/curacodegen/swift-services-api
    ./gradlew generateSwiftClasses
    popd
}

gen_java() {
    pushd $(git rev-parse --show-toplevel)/servicesapi
    ./gradlew generateJavaClasses
    popd
}

prepare_old() {
    gradlePermissions
    fixBrokenDependencies
    maven
    endpoint
    android_patches
}

android() {
    start_emulator
    gradlePermissions
    publish_to_maven
    endpoint
    android_patches
    install_android
}

start_emulator() {
    heading 'Starting emulator'
    pushd $ANDROID_HOME/emulator
    emulator -avd 'Pixel_C_API_28' &
    popd
}

install_android() {
    heading 'Install Android project'
    pushd $(git rev-parse --show-toplevel)/client
    ./gradlew installDebug
    popd
}

publish_to_maven() {
    pushd $(git rev-parse --show-toplevel)/servicesapi
    ./gradlew publishToMavenLocalApi
    popd
    pushd $(git rev-parse --show-toplevel)/coreproject
    ./gradlew publishToMavenLocal
    popd
}

gradlePermissions() {
    pushd $(git rev-parse --show-toplevel)
    find . -type f -name gradlew -print0 | xargs -0 chmod +x
    find . -type f -name gradlew -print0 | xargs -0 git update-index --skip-worktree
    popd
}

fixBrokenDependencies() {
    pushd $(git rev-parse --show-toplevel)/client
    ./gradlew fixBrokenDependencies
    popd
}

android_patches() {
    heading "Applying patches to Android code"
    file=$(git rev-parse --show-toplevel)/client/core/src/main/java/com/systematic/cura/client/core/service/security/LoginService.java
    sedi 's/assertTimeZone(tenantService/\/\/assertTimeZone(tenantService/' $file
    skip $file
    echo -e "* Patched file: \033[92m$file\033[0m"
}

endpoint() {
    heading "Changing endpoint server URL"
    if [ -z "$1" ]; then
        server_endpoint="pc-6384"
    else
        server_endpoint=$1
    fi

    root_folder=$(git rev-parse --show-toplevel)
    file=$root_folder/ios/LocalConfiguration/config.default.txt
    echo "http://172.20.17.12/CURA/$server_endpoint" > $file
    skip $file
    file=$root_folder/client/androidmodules.gradle
    unskip $file
    git checkout $file &>/dev/null
    sedi "s/\(CURA\/\)\" \+ InetAddress.*/\1$server_endpoint\"/" $file
    skip $file
    echo -e "* Changed endpoint server to: \033[92m$server_endpoint\033[0m"
    echo ""
}

transform_ts_to_mp4() {
    for a in *.ts; do
        ffmpeg -i "$a" -c copy "${a%.*}.mp4"
    done
}

features() {
    if [ -z "$1" ]; then
        author="Mihai Cristescu"
    else
        author=$1
    fi

    git log --all --author="$author" --oneline | grep -o -E "\[CURA-\d*\]" | sort | uniq
}

ff() {
    ggfa
    heading "Fast forwarding all worktrees"
    paths=$(git worktree list --porcelain  | grep worktree | awk '{print $2}')
    for path in $paths
    do
        echo -e "\033[92m* Fast forwarding \033[94m$path\033[0m\n"
        pushd $path
        isDetached=$(git symbolic-ref -q HEAD)
        if [[ -z $isDetached ]]; then
            echo -e "\033[91mSkipping (detached state).\033[0m\n"
        else
            git pull
            echo ""
        fi
        popd
    done
}

jira() {
    open https://support.systematic.com/secure/Dashboard.jspa
}

wiki() {
    open https://wiki/display/BOR
}

bit() {
    open https://bitbucket/dashboard
}

team() {
    open https://teamcity/project.html\?projectId=Cura
}

owa() {
    open https://outlook.office.com/mail/inbox
    open https://outlook.office.com/calendar/view/day
}



