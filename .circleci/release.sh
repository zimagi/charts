#!/usr/bin/env bash

set -e
set -o errexit
set -o nounset
set -o pipefail

: "${GH_TOKEN:?Environment variable GH_TOKEN must be set}"
: "${GIT_REPOSITORY_URL:?Environment variable GIT_REPO_URL must be set}"
: "${GIT_USERNAME:?Environment variable GIT_USERNAME must be set}"
: "${GIT_EMAIL:?Environment variable GIT_EMAIL must be set}"
: "${GIT_REPOSITORY_NAME:?Environment variable GIT_REPOSITORY_NAME must be set}"


main() {
    local charts_dir=charts

    local repo_root
    repo_root="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"
    pushd "${repo_root}" > /dev/null

    echo "Looking up latest tag..."
    local latest_tag
    latest_tag=$(find_latest_tag)

    local head_rev
    head_rev=$(git rev-parse --verify HEAD)
    echo "$head_rev HEAD"

    echo "Identifying changed charts since tag '$latest_tag'..."
    local changed_charts=()
    readarray -t changed_charts <<< "$(get_changed_charts "$latest_tag")"

    if [[ -n "${changed_charts[*]}" ]]; then
        # install_chart_releaser

        rm -rf .cr-release-packages
        mkdir -p .cr-release-packages

        rm -rf .cr-index
        mkdir -p .cr-index

        for chart in "${changed_charts[@]}"; do
            if [[ -d "$chart" ]]; then
                package_chart "$chart"
            else
                echo "Chart '$chart' no longer exists in repo. Skipping it..."
            fi
        done

        release_charts
        sleep 5
        update_index
    else
        echo "Nothing to do. No chart changes detected."
    fi

    popd > /dev/null
}

get_changed_charts() {
    local commit="$1"

    local changed_files
    changed_files=$(git diff --find-renames --name-only "$commit" -- "$charts_dir")

    local depth=$(( $(tr "/" "\n" <<< "$charts_dir" | sed '/^\(\.\)*$/d' | wc -l) + 1 ))
    local fields="1-${depth}"

    cut -d '/' -f "$fields" <<< "$changed_files" | uniq | filter_charts
}

filter_charts(){
    while read -r chart; do
        [[ ! -d "$chart" ]] && continue
        local file="$chart/Chart.yaml"
        if [[ -f "$file" ]]; then
            echo "$chart"
        else
           echo "WARNING: $file is missing, assuming that '$chart' is not a Helm chart. Skipping." 1>&2
        fi
    done
}

package_chart(){
    local chart="$1"

    local args=("$chart" --package-path .cr-release-packages)

    echo "Packaging chart '$chart'..."
    chart-releaser package "${args[@]}"
}

find_latest_tag() {
    if ! git describe --tags --abbrev=0 2> /dev/null; then
        git rev-list --max-parents=0 --first-parent HEAD
    fi
}

release_charts() {
    local args=(-o "$GIT_USERNAME" -r "$GIT_REPOSITORY_NAME" -c "$(git rev-parse HEAD)" -t "$GH_TOKEN")

    echo 'Releasing charts...'
    chart-releaser upload "${args[@]}"
}

update_index() {
    chart-releaser index -o "$GIT_USERNAME" -r "$GIT_REPOSITORY_NAME" -c "https://jagyugyaerik.github.io/cr--test/"
    cat .cr-index/index.yaml

    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_USERNAME"

    git checkout gh-pages
    cp --force .cr-index/index.yaml index.yaml

    git status
    ls -la
    cat index.yaml

    if ! git diff --quiet; then
        git add .
        git commit --message="Update index.yaml" --signoff
        git push -q https://"${GH_TOKEN}"@github.com/"${GIT_USERNAME}"/"${GIT_REPOSITORY_NAME}".git  gh-pages

    fi
}

main