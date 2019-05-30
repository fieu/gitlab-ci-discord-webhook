#!/usr/bin/env bash

STATUS=$1

case $STATUS in
    "success" )
    EMBED_COLOR="3066993"
    STATUS_MESSAGE="Passed"
    AVATAR="https://i.imgur.com/ZxLKmyn.png"
    ;;

    "failure" )
    EMBED_COLOR="15158332"
    STATUS_MESSAGE="Failed"
    AVATAR="https://i.imgur.com/ZV7WX2f.png"
    ;;
esac

AUTHOR_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$CI_COMMIT_SHA" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$CI_COMMIT_SHA" --pretty="%b")" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g'

if [ "$AUTHOR_NAME" == "$COMMITTER_NAME" ]; then
  CREDITS="$AUTHOR_NAME authored & committed"
else
  CREDITS="$AUTHOR_NAME authored & $COMMITTER_NAME committed"
fi

TIMESTAMP=$(date --utc +%FT%TZ)

WEBHOOK_DATA='{
  "username": "",
  "avatar_url": "https://i.imgur.com/ZxLKmyn.png",
  "embeds": [ {
    "color": '$EMBED_COLOR',
    "author": {
      "name": "Job #'"$CI_JOB_ID"' (Pipeline #'"$CI_PIPELINE_ID"') '"$STATUS_MESSAGE"' - '"$GITLAB_USER_LOGIN/$CI_PROJECT_NAME"'",
      "url": "'"$CI_PIPELINE_URL"'",
      "icon_url": "'$AVATAR'"
    },
    "title": "'"$COMMIT_SUBJECT"'",
    "url": "'"$CI_PROJECT_URL/commit/$CI_COMMIT_SHA"'",
    "description": "'"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",
    "fields": [
      {
        "name": "Commit",
        "value": "'"[\`$CI_COMMIT_SHORT_SHA\`]($CI_PROJECT_URL/commit/$CI_COMMIT_SHA)"'",
        "inline": true
      },
      {
        "name": "Branch",
        "value": "'"[\`$CI_COMMIT_REF_NAME\`]($CI_PROJECT_URL/tree/$CI_COMMIT_REF_SLUG)"'",
        "inline": true
      }
    ],
    "timestamp": "'"$TIMESTAMP"'"
  } ]
}'

(curl --fail --progress-bar -A "TravisCI-Webhook" -H Content-Type:application/json -H X-Author:Suce#7443 -d "$WEBHOOK_DATA" "$2" \
  && echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."