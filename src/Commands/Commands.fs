namespace RhinoFSharpTemplate

open System
open System.Runtime.InteropServices
open Rhino
open Rhino.Commands

[<AbstractClass>]
type PluginCommand(run: RhinoDoc -> Result) =
    inherit Command()

    override self.EnglishName =
        let class_name = self.GetType().Name
        let suffix = "Command"

        if not (class_name.EndsWith(suffix, StringComparison.Ordinal)) then
            invalidOp $"Rhino command class '{class_name}' must end with '{suffix}'."

        class_name.Substring(0, class_name.Length - suffix.Length)

    override _.RunCommand(document: RhinoDoc, _mode: RunMode) = run document

[<Guid("22222222-2222-4222-8222-222222222222")>]
[<CommandStyle(Style.Transparent)>]
type RhinoFSharpTemplateACommand() =
    inherit PluginCommand(Commands.RhinoFSharpTemplateA.run)

[<Guid("33333333-3333-4333-8333-333333333333")>]
[<CommandStyle(Style.Transparent)>]
type RhinoFSharpTemplateBCommand() =
    inherit PluginCommand(Commands.RhinoFSharpTemplateB.run)
