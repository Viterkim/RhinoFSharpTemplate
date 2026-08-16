# RhinoFSharpTemplate

A small F# rhino plugin template. It starts at `0.0.1`, builds for Rhino 7, 8, and 9, and contains two temp cmds.

<!-- TEMPLATE_ONLY_START -->
## Make a fresh plug-in

Clone this repository into the folder you want, then run the initializer once:

```powershell
.\scripts\win\init-project.ps1 -Name MyProjectName -User BingoManden
```

`Name` is the f# namespace, assembly name, project filename, Yak name, and temp Rhino command prefix. It must begin with a letter and contain letters or digits. 

`User` is used as the author, assembly company, and repo owner.

The initializer replaces template names, renames the project, creates new guids and 2 bullshit commands, then deletes itself.
<!-- TEMPLATE_ONLY_END -->

## Development

Just use ./build-and-install.ps1 when developing, but you can do:

```powershell
.\scripts\win\format.ps1 -Check
.\scripts\win\check.ps1
.\scripts\win\build.ps1 -RhinoVersion 9
.\scripts\win\build-all.ps1
.\build-and-install.ps1
```

Add an existing F# file before the generated Rhino wrappers:

```powershell
.\scripts\win\add-file.ps1 -Name .\src\Core\Bingo.fs
.\scripts\win\add-file.ps1 -Name .\src\Core\Early.fs -Before .\src\Core\Bingo.fs
```

Create a command file and its generated Rhino wrapper:

```powershell
.\scripts\win\add-command.ps1 -Name BingoCmd
```

Then edit `src\Commands\BingoCmd.fs`. The project file, GUID, command name, and Rhino wrapper are already handled.

`build-and-install.ps1` defaults to Rhino 9 and uses the fast build/install loop without formatting or source checks. `build-all.ps1` runs those checks once and builds every configured Rhino version without packaging or publishing.

See [Windows development](./docs/building-on-windows.md) for local installation and the guarded Yak release scripts.

## Template from / used in

Template: Rhino F# Template [Github Link](https://github.com/Viterkim/RhinoFSharpTemplate)

Example project: RhinosCanFly / Rhinos Can Fly [Github Link](https://github.com/Viterkim/RhinosCanFly)
