#!/usr/bin/bash

gitCheck() {
	git fetch --quiet
	local branchStatus="$(git status -sb)"
	~/dotfiles/zsh/scripts/messages.sh "warning" "$branchStatus"
	return 0
}

newBranch() {
	~/dotfiles/zsh/scripts/messages.sh "question" "Enter new branch name"
	read newbranch
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

	~/dotfiles/zsh/scripts/messages.sh "info" "Changing branch"
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

	if [ "$1" == "new" ] || [ "$1" == "New" ] || [ "$1" == "NEW" ]; then
		newBranch
		return $?
	fi

	local branches="$(git branch -l | sed 's/..//')"

	# Preselect if only one match in fzf
	local preselectTest="$(echo "$branches" | fzf --filter "$1" --select-1 --exit-0)"
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
			echo "$branches"
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

main "$1"
