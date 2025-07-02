# VS Code Extensions Pack

**Registry:** `ghcr.io/ghostmind-dev/features/extensions`

Adds a curated set of VS Code extensions for development productivity.

## 📦 Included Extensions

This feature installs the following VS Code extensions:

| Name                      | Description                                                           | Marketplace URL                                                                                                   |
| ------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| JSON Language Features    | Built-in JSON language support for VS Code                            | [View Extension](https://marketplace.visualstudio.com/items?itemName=vscode.json-language-features)               |
| Docker                    | Makes it easy to create, manage, and debug containerized applications | [View Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)                 |
| Kubernetes                | Develop, deploy and debug Kubernetes applications                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) |
| Prettier                  | Code formatter using prettier                                         | [View Extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)                      |
| REST Client               | REST Client for Visual Studio Code                                    | [View Extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)                           |
| In Bed By 7pm             | Theme to help you get in bed by 7pm                                   | [View Extension](https://marketplace.visualstudio.com/items?itemName=sdras.inbedby7pm)                            |
| nginx.conf                | nginx support for Visual Studio Code                                  | [View Extension](https://marketplace.visualstudio.com/items?itemName=william-voyek.vscode-nginx)                  |
| shell-format              | Shellscript, Dockerfile and gitignore formatter                       | [View Extension](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format)                   |
| HashiCorp Terraform       | Syntax highlighting and autocompletion for Terraform                  | [View Extension](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)                         |
| DotENV                    | Support for dotenv file syntax                                        | [View Extension](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)                            |
| HashiCorp HCL             | HashiCorp HCL syntax support                                          | [View Extension](https://marketplace.visualstudio.com/items?itemName=hashicorp.hcl)                               |
| Material Theme            | Beautiful Material Design themes                                      | [View Extension](https://marketplace.visualstudio.com/items?itemName=equinusocio.vsc-material-theme)              |
| Cobalt2 Theme Official    | Cobalt2 theme for VS Code                                             | [View Extension](https://marketplace.visualstudio.com/items?itemName=wesbos.theme-cobalt2)                        |
| Lua                       | Lua language support                                                  | [View Extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)                                 |
| Panda Theme               | A superminimal, dark syntax theme                                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=tinkertrain.theme-panda)                     |
| Go                        | Rich Go language support for Visual Studio Code                       | [View Extension](https://marketplace.visualstudio.com/items?itemName=golang.go)                                   |
| LuaHelper                 | Lua language support and debugging                                    | [View Extension](https://marketplace.visualstudio.com/items?itemName=yinfei.luahelper)                            |
| GraphQL                   | GraphQL extension for VSCode                                          | [View Extension](https://marketplace.visualstudio.com/items?itemName=graphql.vscode-graphql)                      |
| GraphQL Syntax            | GraphQL syntax highlighting                                           | [View Extension](https://marketplace.visualstudio.com/items?itemName=graphql.vscode-graphql-syntax)               |
| Gruvbox Theme             | Gruvbox theme for Visual Studio Code                                  | [View Extension](https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox)                           |
| vscode-styled-components  | Syntax highlighting for styled-components                             | [View Extension](https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components)  |
| Nomo Dark Icon Theme      | Dark icon theme for Visual Studio Code                                | [View Extension](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-icontheme-nomo-dark)         |
| Material Icon Theme       | Material Design Icons for Visual Studio Code                          | [View Extension](https://marketplace.visualstudio.com/items?itemName=pkief.material-icon-theme)                   |
| SQLTools                  | Database management done right                                        | [View Extension](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)                               |
| Mode Context              | Context-aware mode switching for VS Code                              | [View Extension](https://marketplace.visualstudio.com/items?itemName=ghostmind.mode-context)                      |
| GitHub Copilot Chat       | AI pair programmer chat interface                                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=github.copilot-chat)                         |
| GitHub Copilot Nightly    | AI pair programmer (nightly version)                                  | [View Extension](https://marketplace.visualstudio.com/items?itemName=github.copilot-nightly)                      |
| Python                    | IntelliSense, linting, debugging & more for Python                    | [View Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python)                            |
| Prisma                    | Adds syntax highlighting, formatting, auto-completion for Prisma      | [View Extension](https://marketplace.visualstudio.com/items?itemName=prisma.prisma)                               |
| Tailwind CSS IntelliSense | Intelligent Tailwind CSS tooling for VS Code                          | [View Extension](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)                   |
| Vue Theme                 | Vue.js theme for Visual Studio Code                                   | [View Extension](https://marketplace.visualstudio.com/items?itemName=mariorodeghiero.vue-theme)                   |
| Deno                      | A language server client for Deno                                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno)                        |

## 📖 Usage

To use this feature, add it to your `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/extensions:1": {}
  }
}
```
