# Windows development

Install Rhino and the .NET SDK selected by `global.json`.

Build for a specific Rhino version:

```powershell
.\scripts\win\build.ps1 -RhinoVersion 8
```

Run formatting and source checks:

```powershell
.\scripts\win\format.ps1 -Check
.\scripts\win\check.ps1
```

Format the F# source:

```powershell
.\scripts\win\format.ps1
```

Check once and build every configured Rhino version:

```powershell
.\scripts\win\build-all.ps1
```

For local debugging, close Rhino and run:

```powershell
.\build-and-install.ps1
```

The first installation needs one manual registration. Build once, open Rhino, browse to the `.rhp` below `bin`, install it through Options > Plug-ins, close Rhino, and run `build-and-install.ps1` again.

`build-and-install.ps1` defaults to Rhino 9 and skips formatting and source checks for a quicker edit/install loop. Pass `-RhinoVersion 7` or `-RhinoVersion 8` when needed. The scripts also accept `$env:RHINO_FSHARP_TEMPLATE_RHINO_VERSION = "8"`.

## Yak releases

Release scripts start parked in `scripts\win\deploy`, where they refuse to run. Read `MOVE-OUT-ONE-LAYER-TO-USE.txt` and move all three `.ps1` files up into `scripts\win` when the project is genuinely ready for packaging or publishing.
