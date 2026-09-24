#!/usr/bin/env bash
set -euo pipefail

REMOTE="origin"
CURRENT_BRANCH="$(git branch --show-current)"

if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Error: You are not currently on a branch."
  exit 1
fi

echo "WARNING: This will permanently rewrite the repository history."
echo "Repository: $(git remote get-url "$REMOTE")"
echo "Branch:     $CURRENT_BRANCH"
echo
read -r -p 'Type DELETE HISTORY to continue: ' CONFIRM

if [[ "$CONFIRM" != "DELETE HISTORY" ]]; then
  echo "Cancelled."
  exit 1
fi

# Make sure the current files are included in the new snapshot.
# Ignored files (.gitignore) will remain ignored.
git add -A

TEMP_BRANCH="__clean_history_$(date +%s)"

# Create a branch with no parents/history.
git checkout --orphan "$TEMP_BRANCH"

# Snapshot exactly what exists now.
git add -A
git commit -m "Initial commit"

# Delete all old local branches.
while IFS= read -r branch; do
  if [[ "$branch" != "$TEMP_BRANCH" ]]; then
    git branch -D "$branch"
  fi
done < <(git for-each-ref --format='%(refname:short)' refs/heads/)

# Give the new branch the original branch name.
git branch -m "$CURRENT_BRANCH"

# Replace the remote branch with the new one-commit history.
git push --force --set-upstream "$REMOTE" "$CURRENT_BRANCH"

# Delete all other remote branches.
while IFS= read -r branch; do
  if [[ "$branch" != "$CURRENT_BRANCH" ]]; then
    echo "Deleting remote branch: $branch"
    git push "$REMOTE" --delete "$branch"
  fi
done < <(
  git ls-remote --heads "$REMOTE" |
  awk '{gsub("refs/heads/", "", $2); print $2}'
)

# Delete all remote tags.
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  echo "Deleting remote tag: $tag"
  git push "$REMOTE" ":refs/tags/$tag"
done < <(
  git ls-remote --tags --refs "$REMOTE" |
  awk '{gsub("refs/tags/", "", $2); print $2}'
)

# Delete local tags.
git tag -l | while IFS= read -r tag; do
  [[ -z "$tag" ]] || git tag -d "$tag"
done

# Remove old commits from the local Git database/reflog.
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo
echo "Done."
echo "The repository now has one commit containing the current files."
#!/usr/bin/env bash
set -euo pipefail

REMOTE="origin"
CURRENT_BRANCH="$(git branch --show-current)"

if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Error: You are not currently on a branch."
  exit 1
fi

echo "WARNING: This will permanently rewrite the repository history."
echo "Repository: $(git remote get-url "$REMOTE")"
echo "Branch:     $CURRENT_BRANCH"
echo
read -r -p 'Type DELETE HISTORY to continue: ' CONFIRM

if [[ "$CONFIRM" != "DELETE HISTORY" ]]; then
  echo "Cancelled."
  exit 1
fi

# Make sure the current files are included in the new snapshot.
# Ignored files (.gitignore) will remain ignored.
git add -A

TEMP_BRANCH="__clean_history_$(date +%s)"

# Create a branch with no parents/history.
git checkout --orphan "$TEMP_BRANCH"

# Snapshot exactly what exists now.
git add -A
git commit -m "Initial commit"

# Delete all old local branches.
while IFS= read -r branch; do
  if [[ "$branch" != "$TEMP_BRANCH" ]]; then
    git branch -D "$branch"
  fi
done < <(git for-each-ref --format='%(refname:short)' refs/heads/)

# Give the new branch the original branch name.
git branch -m "$CURRENT_BRANCH"

# Replace the remote branch with the new one-commit history.
git push --force --set-upstream "$REMOTE" "$CURRENT_BRANCH"

# Delete all other remote branches.
while IFS= read -r branch; do
  if [[ "$branch" != "$CURRENT_BRANCH" ]]; then
    echo "Deleting remote branch: $branch"
    git push "$REMOTE" --delete "$branch"
  fi
done < <(
  git ls-remote --heads "$REMOTE" |
  awk '{gsub("refs/heads/", "", $2); print $2}'
)

# Delete all remote tags.
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  echo "Deleting remote tag: $tag"
  git push "$REMOTE" ":refs/tags/$tag"
done < <(
  git ls-remote --tags --refs "$REMOTE" |
  awk '{gsub("refs/tags/", "", $2); print $2}'
)

# Delete local tags.
git tag -l | while IFS= read -r tag; do
  [[ -z "$tag" ]] || git tag -d "$tag"
done

# Remove old commits from the local Git database/reflog.
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo
echo "Done."
echo "The repository now has one commit containing the current files."
