wally install
rojo sourcemap default.project.json --output sourcemap.json --include-non-scripts
wally-package-types --sourcemap sourcemap.json Packages/