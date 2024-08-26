#!/usr/bin/env bash
set -euo pipefail

while getopts b:h: flag
do
    case "${flag}" in
        b) basebranch=${OPTARG};;
        h) headbranch=${OPTARG};;
    esac
done

echo "creating pull request"
pr_id=$(curl -L  -X POST  https://api.github.com/repos/kevin90n/kevin-hotfix/pulls \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -d '{"title":"chore: scheduled branch merge","body":"","head":"'"$headbranch"'","base":"'"$basebranch"'"}'  |  jq -r .node_id) || request_status=$?

if [[ -z ${request_status+x} && -n $pr_id && $pr_id != null ]]
then
    echo "created pull request"
else
  echo "failed to get pull request ID. Exiting"
  exit 1
fi