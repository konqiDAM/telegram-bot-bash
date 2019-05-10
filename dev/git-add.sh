#!/usr/bin/env bash
# file: git-add.sh
#
# works together with git pre-push.sh and ADD all changed files since last push

#### $$VERSION$$ v0.80-dev2-0-gdbba89c

# magic to ensure that we're always inside the root of our application,
# no matter from which directory we'll run script
GIT_DIR=$(git rev-parse --git-dir)
cd "$GIT_DIR/.." || exit 1

[ ! -f .git/.lastpush ] && echo "No push or hooks not installed, use \"git add\" instead ... Abort" && exit

FILES="$(find ./* -newer .git/.lastpush)"
[ "${FILES}" = "" ] && echo "Noting changed since last push ... Abort" && exit

# run pre_commit on files
dev/hooks/pre-commit.sh

echo -n "Add files to repo: "
# shellcheck disable=SC2086
for file in ${FILES}
do
	[ -d "${file}" ] && continue
	echo -n "${file} "
done
git add .
echo "done."

