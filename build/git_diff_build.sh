#!/bin/bash

# =================================================
# Create helper functions
# =================================================
function copy_file_from_branch {
	local branch_name="$1"
	local file_name="$2"
	local dir_name="$(dirname "$file_name")"

	if [ ! -d "$dir_name" ]; then
		mkdir -p "$dir_name"
	fi

	git show "$branch_name":"$file_name" > "$file_name"
}

function create_directory {
	local dir_name="$1"
	local branch_src="$2"
	local branch_dest="$3"
	local diff_filter="$4"
	local files=""
	local i=""
	local output="${dir_name}_${branch_src//[^a-zA-Z0-9]/}_to_${branch_dest//[^a-zA-Z0-9]/}.txt"

	# Create our directory for storing the files
	mkdir "$dir_name"
	cd "$dir_name"

	# Get file list from git
	files="$(git diff "$branch_dest" "$branch_src" --name-only --diff-filter="$diff_filter")"

	# Loop through file list, grabbing each file from the 
	# correct branch in git, and writing it to disk
	echo "$files" | while read line; do
		copy_file_from_branch "$branch_src" "${line}"
	done

	# Now move back to the main directory, and write
	# some diagnostic info
	cd ..
	echo "============================================================" >> "$output"
	echo "==== CONTENTS OF $dir_name DIRECTORY:" >> "$output"
	echo "============================================================" >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --shortstat --diff-filter="$diff_filter" >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --numstat --diff-filter="$diff_filter" >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --dirstat --diff-filter="$diff_filter" >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --dirstat-by-file --diff-filter="$diff_filter" >> "$output"
	echo "" >> "$output"
	echo "============================================================" >> "$output"
	echo "==== INFO WITH NO DIFF FILTERS APPLIED:" >> "$output"
	echo "============================================================" >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --shortstat >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --numstat >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --dirstat >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --dirstat-by-file >> "$output"
	echo "" >> "$output"
	git diff "$branch_dest" "$branch_src" --name-status >> "$output"
	echo "" >> "$output"
}

# =================================================
# Get User Input, and create new directories
# =================================================

# Get the build directory name
echo "Input the name of the build directory:"
read dir_build
dir_build=${dir_build//[^a-zA-Z0-9]/}

# Exit immediately if our build directory already exists
if [ -d "$dir_build" ]; then
	echo "Exiting because our build directory: " $dir_build " already exists."
	exit
fi

# Get the source branch name
echo "Input the name of the source/deployment branch:"
read branch_src

# Get the destination branch name
echo "Input the name of the destination/restore branch:"
read branch_dest

# Make our main build directory, and move there
mkdir $dir_build
cd $dir_build

# Create our DEPLOY and RESTORE directories
create_directory "DEPLOY" "$branch_src" "$branch_dest" "MA"
create_directory "RESTORE" "$branch_dest" "$branch_src" "M"

exit