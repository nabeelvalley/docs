# My Current VSCode Setup


## Settings

`settings.json`

```json
{
    "editor.suggestSelection": "first",
    "vsintellicode.modify.editor.suggestSelection": "automaticallyOverrodeDefaultValue",
    "git.enableSmartCommit": true,
    "git.autofetch": true,
    "git.confirmSync": false,
    "editor.wordWrap": "on",
    "highlight-bad-chars.additionalUnicodeChars": [
      "\u2019", "\u2018", "\u201D", "\u201C", "\u2013", "\u037E", "\u200E"
    ],
    "highlight-matching-tag.highlightFromContent": true,
    "highlight-matching-tag.highlightSelfClosing": false,
    "highlight-matching-tag.styles": {
        "opening": {
          "name": {
            "underline": "green"
          }
        }, 
        "closing": {
            "name": {
              "underline": "red"
            }
          }
      },
      "editor.minimap.enabled": true,
      "emmet.includeLanguages": {
        "aspnetcorerazor": "html",
        "cshtml": "html"
      },
      "breadcrumbs.enabled": true,
      "[html]": {
        "editor.defaultFormatter": "vscode.html-language-features"
      },
      "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
      "liveServer.settings.donotShowInfoMsg": true,
      "omnisharp.enableMsBuildLoadProjectsOnDemand": true,
      "terminal.integrated.rendererType": "dom",
      "workbench.statusBar.visible": true,
      "python.jediEnabled": false,
      "debug.toolBarLocation": "docked",
      "javascript.preferences.quoteStyle": "single",
      "npm.enableScriptExplorer": true,
      "shellLauncher.shells.windows": [
        {
          "shell": "C:\\Windows\\System32\\cmd.exe",
          "label": "cmd"
        },
        {
          "shell": "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
          "label": "PowerShell"
        },
        {
          "shell": "C:\\Program Files\\Git\\bin\\bash.exe",
          "label": "Git bash"
        },
        {
          "shell": "C:\\Windows\\System32\\bash.exe",
          "label": "WSL Bash"
        }
      ],
      "gitlens.mode.active": "review",
      "zenMode.hideLineNumbers": false,
      "extensions.autoUpdate": false,
      "peacock.favoriteColors": [
        {
          "name": "Angular Red",
          "value": "#b52e31"
        },
        {
          "name": "Auth0 Orange",
          "value": "#eb5424"
        },
        {
          "name": "Azure Blue",
          "value": "#007fff"
        },
        {
          "name": "C# Purple",
          "value": "#68217A"
        },
        {
          "name": "Gatsby Purple",
          "value": "#639"
        },
        {
          "name": "Go Cyan",
          "value": "#5dc9e2"
        },
        {
          "name": "Java Blue-Gray",
          "value": "#557c9b"
        },
        {
          "name": "JavaScript Yellow",
          "value": "#f9e64f"
        },
        {
          "name": "Mandalorian Blue",
          "value": "#1857a4"
        },
        {
          "name": "Node Green",
          "value": "#215732"
        },
        {
          "name": "React Blue",
          "value": "#00b3e6"
        },
        {
          "name": "Something Different",
          "value": "#832561"
        },
        {
          "name": "Vue Green",
          "value": "#42b883"
        },
        {
          "name": "Webhooks",
          "value": "#d797aa"
        },
        {
          "name": "Subdomains",
          "value": "#5a6ba8"
        }
      ],
      "files.exclude": {
        "**/bin": true,
        "**/obj": true
      },
      "window.zoomLevel": 0,
      "explorer.confirmDelete": false,
      "mssql.connections": [
        {
          "server": "localhost\\SQLEXPRESS",
          "database": "",
          "authenticationType": "Integrated",
          "password": ""
        }
      ],
      "workbench.colorTheme": "Panda Syntax",
      "editor.fontFamily": "NovaMono, Consolas, 'Courier New', monospace",
      "workbench.activityBar.visible": true,
      "[javascript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "[typescriptreact]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "[typescript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "[css]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "editor.lineNumbers": "relative",
      "[markdown]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "editor.largeFileOptimizations": false
} 
```

## Extension Setup

## Get Installed Extensions

To check the current installed extensions:

```sh
code --list-extensions | xargs -L 1 echo code --install-extension
```

```ps1
code --list-extensions | % { "code --install-extension $_" }
```

The code output from the above can be used to reinstall all installed extensions

## Extensions

To install the extensions you can run the following script:

```sh
code --install-extension aeschli.vscode-css-formatter
code --install-extension alexcvzz.vscode-sqlite
code --install-extension Azurite.azurite
code --install-extension CoenraadS.bracket-pair-colorizer-2
code --install-extension dbaeumer.vscode-eslint
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension eamodio.gitlens
code --install-extension eryouhao.brackets-light-pro
code --install-extension esbenp.prettier-vscode
code --install-extension formulahendry.code-runner
code --install-extension formulahendry.dotnet-test-explorer
code --install-extension george-alisson.html-preview-vscode
code --install-extension Ikuyadeu.r
code --install-extension JamesBirtles.svelte-vscode
code --install-extension johnpapa.vscode-peacock
code --install-extension KnisterPeter.vscode-github
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-dotnettools.csharp
code --install-extension ms-mssql.mssql
code --install-extension ms-python.python
code --install-extension ms-vscode.azure-account
code --install-extension ms-vscode.vs-keybindings
code --install-extension ms-vscode.vscode-typescript-tslint-plugin
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension NabeelValley.typewriter
code --install-extension Prisma.vscode-graphql
code --install-extension quicktype.quicktype
code --install-extension ritwickdey.LiveServer
code --install-extension schneiderpat.aspnet-helper
code --install-extension tinkertrain.theme-panda
code --install-extension Tyriar.shell-launcher
code --install-extension vincaslt.highlight-matching-tag
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension WallabyJs.quokka-vscode
code --install-extension warren-buckley.iis-express
code --install-extension wengerk.highlight-bad-chars
code --install-extension yzhang.markdown-all-in-one
```
