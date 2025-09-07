# Vesselbound — Skyrim SE Mod

Vesselbound is a Skyrim SE/AE gameplay extension that integrates with SexLab Framework, Fertility Mode, Fill Her Up, and other adult-oriented mods. It introduces new systems for ovulation, womb access, parasites, and multi-pregnancy, with configurable mechanics and deep framework integrations.

---

## Documentation

* [Design Document](docs/Design.md) — features, roadmap, and repository layout.
* [Dependencies](docs/Dependencies.md) — required and optional mods/frameworks.

---

## Features (Phase 1)

* Core scaffolding with persistent storage and event handling.
* Capability detection for frameworks (SexLab Aroused NG, SLSO, SLATE, ODF, FISS, MCM Helper, SUM, Parasites, Creature Framework).
* Debug logging helpers and math utilities.
* Early MCM interface (SkyUI/MCM Helper).
* Quest `Vesselbound_QST` to initialize systems at game start.

---

## Repository Layout

```
Vesselbound/
├─ docs/
│  ├─ Design.md
│  └─ Dependencies.md
├─ source/
│  ├─ core/        (storage, events, mcm)
│  ├─ util/        (debug, math, arrayutil)
│  └─ bridge/      (stubs for framework integrations)
├─ data/
│  └─ scripts/     (compiled .pex output)
└─ external/
   └─ fertilitymodeplus/  (patched FM+ sources)
```

---

## Building

Papyrus sources are in `source/`. Compile them to `data/scripts/` using the Papyrus compiler:

```sh
PapyrusCompiler.exe compile \
  -i <repo>/Vesselbound/data/scripts/source \
  -i <Skyrim>/Data/Scripts/Source \
  -o <repo>/Vesselbound/data/scripts \
  -h <Skyrim>/Data/Scripts/Source \
  -nocache -optimize -all
```

> See the VS Code `tasks.json` included for a ready-to-use build task.

---

## Status

Active development — Phase 1 scaffolding complete, integrating Phase 2 multi-pregnancy and OIO systems next.

Contributions and testing feedback are welcome.
