# Vesselbound — Build Tips (Papyrus)

This repo is set up so **only** our sources compile, and vanilla/SkyUI are used as **headers**. If you ever see the compiler dumping a bunch of vanilla `.pex` files into our mod, or throwing “override type(...)” panics, it’s almost always an include-path issue.

---

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
