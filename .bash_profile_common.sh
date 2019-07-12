heading() {
    echo -e "\033[0;35m"
    echo -e "-----------------------------------"
    echo -e "$@"
    echo -e "-----------------------------------"
    echo -e "\033[0m"
}

prune() {
    heading 'Pruning branches'
    git remote prune origin 
}

fetch() {
    heading 'Fetching remotes'
    git fetch --prune --all 
}

status() {
	heading 'Status'
	git status
}

unstage() {
	heading 'Unstaging local changes'
	git reset HEAD
}

discard() {
	heading 'Discarding local changes'
	git checkout .
}

ggfa() {
	prune
	fetch
    status
}

rr() {
    unskipAll
	unstage
    discard
	status
}

check() {
	heading 'Skipped from git'
	git ls-files -v | grep '^S' | cut -d ' ' -f 2
    echo -e "\n"
}

unskipAll() {
    heading 'Unskipping all files'
    git ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git update-index --no-skip-worktree
}

skip() { 
	git update-index --skip-worktree "$@"
	status
}

unskip() { 
    git update-index --no-skip-worktree "$@"
    status
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

maven() {
    heading "PUBLISHING TO LOCAL MAVEN"
    pushd $(git rev-parse --show-toplevel)/servicesapi
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
	heading "APPLYING PATCHES TO ANDROID CODE"
    pushd $(git rev-parse --show-toplevel)/client/core/src/main/java/com/systematic/cura/client/core/service/security
    sedi 's/assertTimeZone(tenantService/\/\/assertTimeZone(tenantService/' LoginService.java
	popd
}