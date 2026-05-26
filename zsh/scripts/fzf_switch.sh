#!/usr/bin/bash

create=false

getFlags() {
	while getopts "c" flag; do
		case "${flag}" in
		c) create=true ;;
		esac
	done
}

gitCheck() {
	git fetch --quiet
	local branchStatus="$(git status -sb)"
	~/dotfiles/zsh/scripts/messages.sh "warning" "$branchStatus"
	return 0
}


filterBranchName() {
	echo "$1" | sed 's/\[[^]]*\]//g' | tr -s '-'
}

newBranchFromTicket() {
	local tickets=$(~/dotfiles/zsh/scripts/get_active_jira_tickets.php)

	# Preselect if only one match in fzf
	local preselectTest="$(echo "$tickets" | fzf --filter "$1" --select-1 --exit-0)"
	local preselectOptions="$(echo "$preselectTest" | wc -l)"
	if [ "$preselectOptions" -eq 1 ] && [ -n "$preselectTest" ]; then
		git switch -c "$preselectTest"
		return $?
	fi

	local newbranch=$(
		(
			echo "$tickets"
		) | fzf -q "$1"
	)
	newbranch=$(filterBranchName "$newbranch")
	if [ -z "$newbranch" ]; then
		~/dotfiles/zsh/scripts/messages.sh "error" "No ticket selected, aborting"
		return 1
	fi
	git switch -c $newbranch
	~/dotfiles/zsh/scripts/messages.sh "success" "Created and switched to new branch $newbranch"
	return 0
}

newBranch() {
	~/dotfiles/zsh/scripts/messages.sh "question" "Enter new branch name"
	read -e -i "$1" newbranch
	if [ -z "$newbranch" ]; then
		~/dotfiles/zsh/scripts/messages.sh "error" "No branch name provided, aborting"
		return 1
	fi
	git switch -c $newbranch
	~/dotfiles/zsh/scripts/messages.sh "success" "Created and switched to new branch $newbranch"
	return 0
}

changeBranch() {
	local branch="$1"
	if [ "$branch" == "New Branch" ]; then
		newBranch
		return $?
	fi
	if [ "$branch" == "From Ticket" ]; then
		newBranchFromTicket
		return $?
	fi

	~/dotfiles/zsh/scripts/messages.sh "info" "Changing branch"
	if [[ "$branch" == origin/* ]]; then
		branch="${branch#origin/}"
	fi
	git switch $branch --quiet
	if [ $? -ne 0 ]; then
		~/dotfiles/zsh/scripts/messages.sh "error" "Failed to switch to branch $branch"
		return 1
	fi
	~/dotfiles/zsh/scripts/messages.sh "success" "Switched to branch $branch"
	# gitCheck
	return 0
}

main() {
	# Try switch to catch exact match first
	if git switch "$1" --quiet >/dev/null 2>&1; then
		~/dotfiles/zsh/scripts/messages.sh "success" "Switched to branch $1"
		# gitCheck
		return 0
	fi

	if [ "$1" == "new" ] || [ "$1" == "New" ] || [ "$1" == "NEW" ] || [ "$1" == "-c" ]; then
		newBranch "$2"
		return $?
	fi

	if [ "$1" == "ticket" ] || [ "$1" == "Ticket" ] || [ "$1" == "TICKET" ] || [ "$1" == "-t" ]; then
		newBranchFromTicket "$2"
		return $?
	fi

	getFlags

	local branches="$(git branch -l | sed 's/..//')"
	local remotebranches="$(git branch -r | sed 's/..//')"

	# Preselect if only one match in fzf
	local preselectTest="$(
		(
			echo "$branches"
			echo "$remotebranches"
		) | fzf --filter "$1" --select-1 --exit-0)"
	local preselectOptions="$(echo "$preselectTest" | wc -l)"
	if [ "$preselectOptions" -eq 1 ] && [ -n "$preselectTest" ]; then
		changeBranch "$preselectTest"
		return $?
	fi

	local masterBranch="master"
	if git show-ref refs/head/$masterBranch; then
		masterBranch="main"
	fi

	# If no matches drop the user to a fuzzy find
	local branch="$(
		(
			echo "New Branch"
			echo "From Ticket"
			echo "$branches"
			echo "$remotebranches"
		) | fzf -q "$1" --preview "
  if [ {} = 'New Branch' ]; then
    echo '🍃 Create a new branch.\n\nPress Enter to continue…'
  else
    git diff --color=always $masterBranch..{} --stat
  fi
  "
	)"
	if [ -z "$branch" ]; then
		~/dotfiles/zsh/scripts/messages.sh "error" "No branch selected, aborting"
		return 1
	fi
	changeBranch "$branch"
	return 0
}

main "$1" "$2"
