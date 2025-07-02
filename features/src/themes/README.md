# VS Code Themes Pack

**Registry:** `ghcr.io/ghostmind-dev/features/themes`

Adds a curated set of VS Code themes and icon packs for visual customization and personalization of your development environment.

## 🎨 Included Themes and Visual Extensions

This feature installs the following VS Code themes and visual customization extensions:

| Name                   | Description                                                      | Marketplace URL                                                                                           |
| ---------------------- | ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Material Theme         | Beautiful Material Design themes with multiple variants          | [View Extension](https://marketplace.visualstudio.com/items?itemName=equinusocio.vsc-material-theme)      |
| Cobalt2 Theme Official | Cobalt2 theme for VS Code - elegant dark theme                   | [View Extension](https://marketplace.visualstudio.com/items?itemName=wesbos.theme-cobalt2)                |
| Panda Theme            | A superminimal, dark syntax theme with great readability         | [View Extension](https://marketplace.visualstudio.com/items?itemName=tinkertrain.theme-panda)             |
| Gruvbox Theme          | Gruvbox theme for Visual Studio Code - retro groove color scheme | [View Extension](https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox)                   |
| Nomo Dark Icon Theme   | Dark icon theme for Visual Studio Code with clean aesthetics     | [View Extension](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-icontheme-nomo-dark) |
| Material Icon Theme    | Material Design Icons for Visual Studio Code                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=pkief.material-icon-theme)           |
| Vue Theme              | Vue.js inspired theme for Visual Studio Code                     | [View Extension](https://marketplace.visualstudio.com/items?itemName=mariorodeghiero.vue-theme)           |

## 📖 Usage

To use this feature, add it to your `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/themes:1": {}
  }
}
```

This will install all the included themes and icon packs. You can then select your preferred theme by:

1. Opening the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Typing "Color Theme" and selecting "Preferences: Color Theme"
3. Choosing from the available themes
4. For icon themes, use "Preferences: File Icon Theme"

## 🎨 Available Themes

- **Material Theme** - Multiple variants including Ocean, Palenight, and High Contrast
- **Cobalt2** - Dark theme with blue accents
- **Panda** - Superminimal dark theme
- **Gruvbox** - Retro groove color scheme
- **Vue Theme** - Vue.js inspired colors

## 📁 Icon Themes

- **Nomo Dark** - Clean dark icon theme
- **Material Icons** - Google Material Design icons
