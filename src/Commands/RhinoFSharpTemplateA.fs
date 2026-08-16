module RhinoFSharpTemplate.Commands.RhinoFSharpTemplateA

open global.RhinoFSharpTemplate
open Rhino
open Rhino.Commands

let run (_document: RhinoDoc) =
    RhinoApp.WriteLine "RhinoFSharpTemplateA ran."
    Result.Success
