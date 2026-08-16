namespace RhinoFSharpTemplate

open System
open System.Runtime.InteropServices
open Rhino
open Rhino.Commands

[<AbstractClass>]
type PluginCommand(run: RhinoDoc -> Result) =
    inherit Command()

    override self.EnglishName =
        let className = self.GetType().Name
        let suffix = "Command"

        if not (className.EndsWith(suffix, StringComparison.Ordinal)) then
            invalidOp $"Rhino command class '{className}' must end with '{suffix}'."

        className.Substring(0, className.Length - suffix.Length)

    override _.RunCommand(document: RhinoDoc, _mode: RunMode) = run document

[<Guid("22222222-2222-4222-8222-222222222222")>]
[<CommandStyle(Style.Transparent)>]
type RhinoFSharpTemplateACommand() =
    inherit PluginCommand(Commands.RhinoFSharpTemplateA.run)

[<Guid("33333333-3333-4333-8333-333333333333")>]
[<CommandStyle(Style.Transparent)>]
type RhinoFSharpTemplateBCommand() =
    inherit PluginCommand(Commands.RhinoFSharpTemplateB.run)
