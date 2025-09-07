# Vesselbound — Dependencies

## Hard Requirements

* **Skyrim SE/AE** 1.6+
* **SKSE** (latest build)
* **SkyUI** (for MCM)
* **SexLab Framework**
* **Fertility Mode v3 Fixes & Tweaks**
* **Fill Her Up: Baka Edition**

## Soft Dependencies (Enhanced if Present)

* **SLO Aroused NG (SexLabAroused.esm)** → Arousal scaling for OIO.
* **SLSO (SexLab Separate Orgasms)** → Per-actor orgasm hooks.
* **SLATE** → Reliable animation tagging for womb access/OIO gating.
* **Overlay Distribution Framework** → Blessing of Burdens overlays.
* **MCM Helper** → Streamlined config UI.
* **FISS** → Export/import presets.
* **Skyrim – Utility Mod (SUM)** → Math/rand helpers.
* **SexLab Parasites** → Parasite pleasure/resistance system.
* **Creature Framework** → Multi-pregnancy support for creatures.
* **SexLab Scaler** → FX particles (orgasm/fertilization/womb access).
* **Apropos 2** → Dynamic dirty talk.
* **Milk Mod Economy** → Pregnancy → milk production link.

## Optional Flavor

* **Slavetats / LewdMarks** → Blessing/marking overlays.
* **SexLab Survival** → Orgasm resistance in assault scenarios.
* **Schlongs of Skyrim (AE DLL)** → Size data for cervix breach.
* **RaceMenu** → Overlay slots.
* **Acheron** → Defeat event hooks.
* **Dynamic Persistent Forms** → Safe spawn persistence.

## Load Order Notes

The following are confirmed active in the development load order:

* **SexLabAroused.esm**
* **SLSO.esp**
* **SLATE.esp**
* **OverlayDistributionFramework.esp**
* **MCMHelper.esp**
* **FISS.esp**
* **Skyrim – Utility Mod.esm**
* **SexLab-Parasites.esp**

Vesselbound will auto-detect these frameworks and gracefully degrade if they are absent.
