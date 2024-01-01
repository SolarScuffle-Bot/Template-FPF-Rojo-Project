# Template-FPF-Rojo-Project
A fully managed rojo project to support instance-friendly Folder-Per-Feature architectures.

## Update Models From Asset Place
1. Open `.lune/Assets.rbxl` in studio
2. Make the modifications you want in the workspace folders
3. **Save the file**
4. Run `lune updateModels` in the terminal

### Where Are The Changes?
You may have to restart the Rojo server to see all the changes.

### My Models Are Corrupted!
Due to a bug in Lune (or Rojo?) models can get corrupted.
1. Run `rojo build --output build.rbxl` in the terminal
2. Open `build.rbxl` in studio
3. Publish the place as your production place
4. Continue from there