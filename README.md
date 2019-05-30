# Gitlab CI 🡒 Discord Webhook
> Heavily influenced by [DiscordHooks/travis-ci-discord-webhook](https://github.com/DiscordHooks/travis-ci-discord-webhook).

If you are looking for a way to get build (success/failure) status reports from
[Gitlab CI](https://gitlab.com) in [Discord](https://discordapp.com), stop
looking. You've came to the right place.

## Requirements
-  You should be using Gitlab CI for testing code.
-  A Discord Server where notifications will be posted.
-  5 minutes
-  A cup of coffee ☕

## Guide
1.  Create a webhook in your Discord Server ([Guide](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks)).

2.  Copy the **Webhook URL**.

3.  Go to your repository `Settings 🡒 CI / CD` (for which you want status notifications)
    in Gitlab and add an environment variable called `DISCORD_WEBHOOK` and paste
    the **Webhook URL** you got in the previous step.

    ![Add environment variable in Gitlab CI](https://i.imgur.com/ThRm7Jb.png)

4.  Add these lines to the `.gitlab-ci.yml` file of your repository.

    ```yaml
    notify-success:
        stage: notify-success
        when: on_success
        script:
            - wget https://raw.githubusercontent.com/NurdTurd/gitlab-ci-discord-webhook/master/send.sh
            - bash ./send.sh success $DISCORD_WEBHOOK
    notify-failure:
        stage: notify-failure
        when: on_failure
        script:
            - wget https://raw.githubusercontent.com/NurdTurd/gitlab-ci-discord-webhook/master/send.sh
            - bash ./send.sh failure $DISCORD_WEBHOOK
    ```

5. **Be sure to add both (in order) `notify-failure` and `notify-success` to your `stages` section of your `.gitlab-ci.yml`.**

5.  Grab your coffee ☕ and enjoy! And, if you liked this, please ⭐**Star**
    this repository to show your love.

### Note
-  If you face any issues in the scripts (and you're sure it's not on your side),
please consider opening an issue and I'll fix it ASAP.
-  If you want to improve the scripts, feel free to open a pull request.

### See Also
-  [discord.sh](https://github.com/ChaoticWeg/discord.sh) - Write-only command-line Discord webhook integration written in 100% Bash script.