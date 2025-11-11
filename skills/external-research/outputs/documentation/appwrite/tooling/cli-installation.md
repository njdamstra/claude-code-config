[Skip to content](https://appwrite.io/docs/tooling/command-line/installation#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The [Appwrite Command Line Interface (CLI)](https://github.com/appwrite/sdk-for-cli) is an application that allows you to interact with Appwrite to perform server-side tasks using your terminal. This includes creating and managing projects, managing resources (rows, files, users), creating and deploying Appwrite Functions, and other operations available through Appwrite's API.

## [Getting started](https://appwrite.io/docs/tooling/command-line/installation\#getting-started)

The CLI is packaged both as an [npm module](https://www.npmjs.com/package/appwrite-cli) as well as a [standalone binary](https://github.com/appwrite/sdk-for-cli/releases/latest) for your operating system, making it completely dependency free, platform independent, and language agnostic.

If you plan to use the CLI to initialize new Appwrite Functions, ensure that [Git is installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) on your machine.

### [Install with npm](https://appwrite.io/docs/tooling/command-line/installation\#install-with-npm)

If you have npm set up, run the command below to install the CLI.

```web-code sh line-numbers
npm install -g appwrite-cli

```

### [Install with script](https://appwrite.io/docs/tooling/command-line/installation\#install-with-script)

For a completely dependency-free installation, the CLI also ships with a convenient installation script for your operating system

macOSWindowsLinux

macOSWindows
More

Linux

Using [Homebrew](https://brew.sh/)

```web-code sh line-numbers
brew install appwrite

```

or terminal

```web-code sh line-numbers
curl -sL https://appwrite.io/cli/install.sh | bash

```

Using [Powershell](https://learn.microsoft.com/en-us/powershell/)

```web-code sh line-numbers
iwr -useb https://appwrite.io/cli/install.ps1 | iex

```

or [Scoop](https://scoop.sh/)

```web-code sh line-numbers
scoop install https://raw.githubusercontent.com/appwrite/sdk-for-cli/master/scoop/appwrite.config.json

```

```web-code sh line-numbers
curl -sL https://appwrite.io/cli/install.sh | bash

```

## [Update your CLI](https://appwrite.io/docs/tooling/command-line/installation\#update-your-cli)

npmacOSWindowsLinuxScoop

npmmacOS
More

WindowsLinuxScoop

```web-code sh line-numbers
npm install -g appwrite-cli

```

Using [Homebrew](https://brew.sh/)

```web-code sh line-numbers
brew install appwrite

```

or terminal

```web-code sh line-numbers
curl -sL https://appwrite.io/cli/install.sh | bash

```

```web-code sh line-numbers
iwr -useb https://appwrite.io/cli/install.ps1 | iex

```

```web-code sh line-numbers
curl -sL https://appwrite.io/cli/install.sh | bash

```

```web-code sh line-numbers
scoop install https://raw.githubusercontent.com/appwrite/sdk-for-cli/master/scoop/appwrite.config.json

```

### [Verify installation](https://appwrite.io/docs/tooling/command-line/installation\#verify-installation)

After the installation or the update is complete, you can verify the Appwrite CLI is available by checking its version number.

```web-code sh line-numbers
appwrite -v

```

## [Login](https://appwrite.io/docs/tooling/command-line/installation\#login)

Before you can use the CLI, you need to login to your Appwrite account using

```web-code sh line-numbers
appwrite login

```

Add the `--endpoint` flag if you're using a self-hosted instance of Appwrite. This flag requires you to add the URL string you're using for your self-hosted instance after the `--endpoint` flag.

```web-code sh line-numbers
appwrite login --endpoint "<URL_HERE>"

```

You can log in to multiple accounts or change the **current** account by re-running the command.

## [Initialization](https://appwrite.io/docs/tooling/command-line/installation\#initialization)

After you're logged in, the CLI needs to be initialized with your Appwrite project. You can initialize the CLI using:

```web-code sh line-numbers
appwrite init project

```

This will create your `appwrite.config.json` file, where you will configure your various services like tables, functions, teams, topics, and buckets.

```web-code json line-numbers
{
    "projectId": "<PROJECT_ID>",
    "endpoint": "https://<REGION>.cloud.appwrite.io/v1"
}

```

You can run your first CLI command after logging in. Try fetching information about your Appwrite project.

```web-code sh line-numbers
appwrite projects get --project-id "<PROJECT_ID>"

```

##### Self-signed certificates

By default, requests to domains with self-signed SSL certificates (or no certificates) are disabled. If you trust the domain, you can bypass the certificate validation using

```web-code sh line-numbers
appwrite client --self-signed true

```

### [Next steps](https://appwrite.io/docs/tooling/command-line/installation\#next-steps)

You can use the CLI to create and deploy tables, functions, teams, topics, and buckets. Deployment commands allow you to configure your Appwrite project programmatically and replicate functions and table schemas across Appwrite projects.

[Learn more about deployment](https://appwrite.io/docs/tooling/command-line/tables)

Besides utility commands, the CLI can be used to execute commands like a Server SDK.

[Find a full list of commands](https://appwrite.io/docs/tooling/command-line/commands)

You can choose to use the CLI in a headless and non-interactive mode without the need for config files or sessions. This is useful for CI or scripting use cases.

[Learn more about CI mode](https://appwrite.io/docs/tooling/command-line/non-interactive)

## [Help](https://appwrite.io/docs/tooling/command-line/installation\#help)

If you get stuck anywhere, you can always use the `help` command to get the usage examples.

```web-code sh line-numbers
appwrite help

```

## [Configuration](https://appwrite.io/docs/tooling/command-line/installation\#configuration)

At any point, if you would like to change your server's endpoint, project ID, or self-signed certificate acceptance, use the `client` command.

```web-code sh line-numbers
appwrite client --endpoint https://<REGION>.cloud.appwrite.io/v1
appwrite client --key 23f24gwrhSDgefaY
appwrite client --self-signed true
appwrite client --reset // Resets your CLI configuration
appwrite client --debug // Prints your current configuration

```

## [Uninstall](https://appwrite.io/docs/tooling/command-line/installation\#uninstall)

If you installed Appwrite CLI using NPM, you can use the following command to uninstall it.

```web-code sh line-numbers
npm uninstall -g appwrite-cli

```

If you installed the Appwrite CLI with brew or the installation script for your operating system, use the following command to uninstall it.

macOSWindowsLinux

macOSWindows
More

Linux

Using [Homebrew](https://brew.sh/)

```web-code sh line-numbers
brew uninstall appwrite

```

or terminal

```web-code sh line-numbers
rm -f /usr/local/bin/appwrite | bash

```

Using [Powershell](https://learn.microsoft.com/en-us/powershell/)

```web-code sh line-numbers
$APPWRITE_INSTALL_DIR = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Appwrite"; Remove-Item -Force -Path $APPWRITE_INSTALL_DIR

```

or [Scoop](https://scoop.sh/)

```web-code sh line-numbers
scoop uninstall appwrite

```

```web-code sh line-numbers
rm -f /usr/local/bin/appwrite | bash

```

You can also remove the configuration, cookies, and API Keys the Appwrite CLI stored. To remove those, run the following command.

macOSWindowsLinux

macOSWindows
More

Linux

```web-code sh line-numbers
rm -rf ~/.appwrite | bash

```

Using [Powershell](https://learn.microsoft.com/en-us/powershell/)

```web-code sh line-numbers
$APPWRITE_CONFIG_DIR = Join-Path -Path $env:UserProfile -ChildPath ".appwrite"; Remove-Item -Recurse -Force -Path $APPWRITE_CONFIG_DIR

```

or [Scoop](https://scoop.sh/)

```web-code sh line-numbers
appwrite client --reset

```

```web-code sh line-numbers
rm -rf ~/.appwrite | bash

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
