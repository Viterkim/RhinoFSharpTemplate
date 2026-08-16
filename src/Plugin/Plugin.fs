namespace RhinoFSharpTemplate

open Rhino.PlugIns

type RhinoFSharpTemplatePlugin() =
    inherit PlugIn()

    override _.LoadTime = PlugInLoadTime.WhenNeeded
