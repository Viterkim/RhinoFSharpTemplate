module RhinoFSharpTemplate.Commands.RhinoFSharpTemplateB

open global.RhinoFSharpTemplate
open Rhino
open Rhino.Commands

let run (_document: RhinoDoc) =
    RhinoApp.WriteLine $"RhinoFSharpTemplateB ran. {WindowsPlatform.placeholder ()}"
    Result.Success
