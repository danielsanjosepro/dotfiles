#!/usr/bin/env bash
# open-github.sh — open the GitHub repository of the current working directory

# Exit immediately if a command fails
set -e

# Ensure we're inside a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a git repository."
    exit 1
fi

# Get the remote URL
remote_url=$(git remote get-url origin 2>/dev/null || true)

if [[ -z "$remote_url" ]]; then
    echo "❌ No remote 'origin' found."
    exit 1
fi

# Normalize the URL (handle git@ and https forms)
if [[ "$remote_url" =~ ^git@github\.com:(.*)\.git$ ]]; then
    repo_path="${BASH_REMATCH[1]}"
    github_url="https://github.com/${repo_path}"
elif [[ "$remote_url" =~ ^https://github\.com/(.*)\.git$ ]]; then
    repo_path="${BASH_REMATCH[1]}"
    github_url="https://github.com/${repo_path}"
else
    echo "❌ This remote does not appear to be a GitHub repository."
    echo "Remote URL: $remote_url"
    exit 1
fi

# Open in the default browser
echo "🌐 Opening $github_url"
if command -v xdg-open >/dev/null; then
    xdg-open "$github_url" >/dev/null 2>&1
elif command -v open >/dev/null; then  # macOS
    open "$github_url"
else
    echo "Please open this URL manually:"
    echo "$github_url"
fi

