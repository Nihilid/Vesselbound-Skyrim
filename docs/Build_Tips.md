# Vesselbound — Build Tips (Papyrus)

## Golden `tasks.json`

Use this exact task (compile the **parent** folder only; the parent already contains `stubs/`):

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Papyrus: Compile Vesselbound",
      "type": "process",
      "command": "D:/Skyrim Mod Tools/papyrus-compiler/PapyrusCompiler.exe",
      "args": [
        "compile",
        "-nocache",
        "-i", "C:/Users/Makron/AppData/Roaming/Vortex/skyrimse/mods/Vesselbound/scripts/source",
        "-h", "C:/Steam/steamapps/common/Skyrim Special Edition/Data/Scripts/Source",
        "-o", "C:/Users/Makron/AppData/Roaming/Vortex/skyrimse/mods/Vesselbound/scripts"
      ],
      "problemMatcher": [],
      "group": { "kind": "build", "isDefault": true }
    }
  ]
}
