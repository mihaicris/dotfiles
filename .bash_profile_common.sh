pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

heading() {
    echo -e "\n\033[7m\033[034m$@\033[0m\n"
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

rra() {
    unskipAll
    unstage
    discard
    gclean
    status
}

rraa() {
    unskipAll
    unstage
    discard
    gclean
    recreate_files
    status
}

prune() {
    heading 'Prune branches'
    git remote prune origin
}

fetch() {
    heading 'Fetch remotes'
    git fetch --prune --all
}

status() {
    heading 'Status'
    git status
    echo ""
}

unstage() {
    files=`git diff --name-only --cached`
    if [[ ${#files} -gt 0 ]]; then
        heading 'Unstage local changes'
        echo $files
        echo ""
        git reset HEAD --quiet
    fi
}

discard() {
    pushd $(git rev-parse --show-toplevel)
    files=`git diff --name-only`
    if [[ ${#files} -gt 0 ]]; then
        heading 'Discard local changes'
        echo "$files"
        git checkout . --quiet
    fi
    popd
}

gclean() {
    pushd $(git rev-parse --show-toplevel)
    files=`git clean -xdfn -e Carthage/`
    if [[ ${#files} -gt 0 ]]; then
        heading 'Clean ignored files'
        git clean -xdf -e Carthage/
    fi
    popd
}

recreate_files() {
	heading 'Recreate all files'
	pushd $(git rev-parse --show-toplevel)
	git rm --cached -r .
	git reset --hard
	popd
}

unskipAll() {
    files=`git ls-files -v | grep '^S' | cut -d ' ' -f 2`
    if [[ ${#files} -gt 0 ]]; then
        heading 'Reactivate skipped files from git'
        echo "$files"
        echo ""
        git ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git update-index --no-skip-worktree
    fi
}

skip() {
    git update-index --skip-worktree "$@"
}

unskip() {
    git update-index --no-skip-worktree "$@"
}

hh() {
    heading "Detach HEAD to previous commit"
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
                echo -e "\nCould not checkout branch\033[34m$branch_name\033[0m.\n"
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
    heading "Publish artifacts to local Maven"
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

android() {
    maven
    endpoint_android
    android_patches
}

android_patches() {
    heading "Apply patches to Android code"
    pushd $(git rev-parse --show-toplevel)/client/core/src/main/java/com/systematic/cura/client/core/service/security
    sedi 's/assertTimeZone(tenantService/\/\/assertTimeZone(tenantService/' LoginService.java
    skip LoginService.java
    popd
}

endpoint() {
    if [ -z "$1" ]; then
        server_endpoint="pc-6384"
    else
        server_endpoint=$1
    fi

    endpoint_ios $server_endpoint
    endpoint_android $server_endpoint
}

endpoint_ios() {
    heading "Change iOS endpoint server to: $server_endpoint"

    if [ -z "$1" ]; then
        server_endpoint="pc-6384"
    else
        server_endpoint=$1
    fi

    root_folder=$(git rev-parse --show-toplevel)
    pushd $root_folder
    echo "http://172.20.17.12/CURA/$server_endpoint" > ios/LocalConfiguration/config.default.txt
    popd
    skip $root_folder/ios/LocalConfiguration/config.default.txt
 }

endpoint_android() {
    heading "Change Android endpoint server to: $server_endpoint"

    if [ -z "$1" ]; then
        server_endpoint="pc-6384"
    else
        server_endpoint=$1
    fi

    root_folder=$(git rev-parse --show-toplevel)
    pushd $root_folder
    sedi "s/\(CURA\/\)\" \+ InetAddress.*/\1$server_endpoint\"/" client/androidmodules.gradle
    popd
    skip $root_folder/client/androidmodules.gradle
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
