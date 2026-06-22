function open-poker --description 'Open the current branch'\''s per-PR Poker (platform-api) preview env in the browser'
    set -l project nonprod1-svc-vvps
    set -l region europe-west3

    set -l pr (gh pr view --json number --jq .number 2>/dev/null)
    if test -z "$pr"
        echo "No open PR for the current branch." >&2
        return 1
    end

    set -l svc "platform-api-pr-$pr"
    set -l url (gcloud run services describe $svc --project=$project --region=$region --format='value(status.url)' 2>/dev/null)
    if test -z "$url"
        echo "No per-PR Poker env for PR #$pr ($svc not deployed)." >&2
        echo "Trigger the pr-env-platform workflow to deploy it." >&2
        return 1
    end

    echo "Opening $url"
    xdg-open $url
end
