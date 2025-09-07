# Vesselbound — Design Plan (v0.2)

A Skyrim SE/AE gameplay extension focused on advanced fertility, ovulation, pregnancy, pleasure, and integration across the SexLab ecosystem. This doc is the working design spec to commit to GitHub.

> **Scope note**: Vesselbound augments existing mods (FM+, FHU, SexLab P+, etc.). Where possible, it patches or extends through events, MCM settings, and soft dependencies to avoid hard conflicts.

---

## 1) Target Mods & Integrations

- Fill Her Up: Baka Edition (FHU)
- Fertility Mode v3 (Fixes & Tweaks)
- SexLab P+
- SLO Aroused NG (SexLabAroused.esm)
- Slavetats / LewdMarks
- SexLab Parasites (Kyne's Blessing)
- SexLab Survival
- Milk Mod Economy (MME)
- Schlongs of Skyrim (AE DLL)
- SexLab Scaler
- RaceMenu
- Apropos 2

### 1.1 Framework Hooks & Fallbacks (Auto‑Detect)
Vesselbound performs **capability detection** at startup and enables integrations when present; otherwise features gracefully degrade to safe fallbacks.

- **Arousal**: SLO Aroused NG → arousal value drives OIO scaling (cache/throttle).
- **Orgasm Events**: SLSO → per‑actor orgasm hooks; fallback to SexLab climax events if absent.
- **Act Context**: SLATE → tag queries (e.g., vaginal) for womb‑access gating; fallback to heuristic checks.
- **Overlays**: Overlay Distribution Framework (ODF) → Blessing of Burdens distribution with SPID‑style filters.
- **MCM**: MCM Helper → slimmer config layer; **FISS** → export/import presets.
- **Papyrus Utils**: Skyrim – Utility Mod (SUM) → math/rand helpers where available; fallback to VB_Math.
- **Parasites**: SexLab Parasites → parasite pleasure meter + resist ticks; inert if mod missing.
- **Creatures**: Creature Framework → cleaner multi‑preg/seed data for creature mates when present.

---

## 2) Vesselbound Actors

- Features may apply to:
  - **Blessing of Burdens** bearers only (visualized via LewdMarks/Slavetats overlays, distributed with ODF), **or**
  - **All valid female actors** (MCM toggle).

**Implementation**: persistent magic effect + overlay slotting; lightweight keyword/faction tag for filtering.

---

## 3) Multiple Pregnancies (FM+ Patch)

- Allow **configurable max concurrent pregnancies** per actor (supports creatures).
- Maintain separate gestation records (each with father/race/seed time, etc.).
- Reconcile with existing FM+/FHU sperm & timer logic.

**Key requirements**
- Data model for multiple embryos.
- Safe patching of FM+ conception checks (hook not hard overwrite where possible).
- MCM: `maxConcurrentPregnancies`, conflict guardrails, debug tools.

---

## 4) Orgasm‑Induced Ovulation (OIO)

- Female orgasm may **trigger ovulation** with a configurable base chance.
- Modifiers from potions/poisons/spells/drugs/effects (MCM sliders and keyword-based effects).
- Each OIO creates **unfertilized ova** items/nodes that persist for **~24 in‑game hours** (configurable) before decay.
- **Instant fertilization** logic during ovulation:
  - If ejaculation occurs while ovulating, ova can be **instantly fertilized**.
  - **MCM option**: Only allow instant fertilization if the partner is **actively penetrating the recipient’s womb** (cervical access true), not just vaginal.
- Optional override to **replace FM+ cycle** so that only OIO releases ova.
- Assault scenarios (SexLab P+) emphasize **orgasm resistance** to avoid OIO events and resulting pregnancies.

**Framework use:**
- **SLSO** → high‑signal per‑actor orgasm events.
- **SLO Aroused NG** → arousal multiplier scaling on OIO chance.

---

## 5) Cervical Penetration / Womb Access

- During vaginal scenes, partners with schlong size ≥ threshold may attempt **cervix breach** attempts.
- **Higher size ⇒ higher access chance**; repeated attempts within a scene increase success odds (diminishing returns cap).
- On success: mark **wombAccess = true** for that scene window; increase **pleasure gain** for both actors; enables OIO **instant fertilization** if toggled.

**Framework use:**
- **SLATE** → animation tags to verify vaginal acts.

**MCM knobs**
- `wombSizeThreshold`, `wombAccessBaseChance`, `wombAccessRetryBonus`, `wombAccessPleasureMult`.

---

## 6) Parasites (SexLab Parasites)

- Parasites can **induce orgasm, trigger OIO, and fertilize ova** (where applicable).
- Introduce a **Parasite Pleasure Meter** per attached parasite instance, analogous to SexLab actor arousal.
- **Resistance options**:
  - Actor can periodically attempt **orgasm resistance** checks to stall parasite‑driven climaxes.
  - Actor can attempt to **stave parasite pleasure gains** (reduced accumulation for a duration on success).

**Framework use:**
- Parasite hooks from SexLab Parasites.
- Resistance checks modified by SLO arousal & SexLab Survival states.

---

## 7) Integration Hooks

**SexLab Scaler**
- Trigger heart particles on **orgasm**, **fertilization**, **womb access**.

**Apropos 2**
- Event lines for: Ovulation start, Womb penetration, Ejaculation into womb, Instant fertilization, Parasite surge/orgasm.

**MME (Milk Mod Economy)**
- Milk production influenced by **number of active pregnancies** and status effects.

**ODF + LewdMarks / Slavetats / RaceMenu**
- Blessing overlays; optional progressive markings tied to pregnancies or womb access events.

**SLO Aroused NG / SexLab Survival**
- Use arousal/survival state as modifiers to OIO and resistance rolls.

**Acheron**
- Tap into defeat events to escalate OIO resistance stakes during assaults.

---

## 8) Data & Save Model

- Actor‑scoped storage for:
  - `pregnancies[]` (list of embryos with timers/metadata)
  - `ova[]` (unfertilized ova entries with decay timestamps)
  - `wombAccessWindow` (scene‑scoped flag/TTL)
  - `parasitePleasure` map keyed by parasite ID

**Persistence**: SKSE co-save or JSONUtil fallback; migration guards. Optionally leverage **Dynamic Persistent Forms** for lightweight TTL tracking.

---

## 9) MCM Settings (Draft)

- **General**: master enable, debug logging, overlay usage, target‑population (Blessing vs All), **integration toggles** (enable/disable SLO/SLSO/SLATE/ODF/SUM hooks individually), **Preset Export/Import (FISS)**.
- **Pregnancy**: max concurrent pregnancies, conflict safety.
- **OIO**: base chance, duration (hours), require womb access for instant fertilization, modifiers scale, **arousal weight (SLO)**, cache window (s).
- **Womb Access**: size threshold, retry bonus, pleasure multiplier, access window TTL (min).
- **Parasites**: pleasure gain rate, resist cadence & DC, success reduction, allow parasite‑induced OIO.
- **Apropos/FX**: enable/disable lines & particles.

---

## 10) Technical Notes

- Prefer **events & soft hooks**; isolate FM+ patches with version checks and feature flags.
- **Capability detection**: one central module sets `HasSLO/HasSLSO/HasSLATE/HasODF/HasFISS/HasMCMHelper/HasSUM/HasParasites/HasCreatureFramework`.
- **Graceful degradation**: if a framework is missing, substitute internal heuristics (e.g., basic act checks, VB_Math, generic SexLab orgasm events).
- Guard against **scene timing** anomalies (orgasm/events vs expression updates).
- Clamp rates; avoid save bloat via capped arrays and periodic compaction.
- **Debug Page** in MCM: test buttons (force OIO, womb access TTL, spawn/clear ova, simulate ejaculation), **FISS preset export/import**.

---

## 11) Roadmap (Phased)

**Phase 1 — Foundations**
- Data model & persistence
- MCM scaffolding (MCM Helper) & Debug panel
- **Capability detector** (SLO/SLSO/SLATE/ODF/FISS/SUM/Parasites/Creature Framework)

**Phase 2 — Multi‑Pregnancy**
- Patch FM+ conception to store multiple embryos
- Gestation tick & visibility

**Phase 3 — OIO Core**
- Orgasm hooks → ovulation roll (**SLSO first; SexLab fallback**)
- Ova lifecycle & decay
- Instant fertilization logic (+ womb‑required toggle; **SLATE tags** for act validation)

**Phase 4 — Womb Access**
- Size checks, retries, pleasure multipliers
- Scene‑scoped access window

**Phase 5 — Parasites**
- Parasite Pleasure Meter + resist system
- Parasite‑driven OIO integration

**Phase 6 — FX & Flavor**
- SexLab Scaler particles
- Apropos 2 line bank
- QA pass & polish

---

## 12) Repository Layout (Proposed)

```
Vesselbound/
├─ docs/
│  └─ DESIGN.md  ← (this file)
├─ src/
│  ├─ core/
│  │  ├─ events.psc
│  │  ├─ storage.psc
│  │  └─ mcm.psc
│  ├─ fmplus/
│  │  └─ multipreg_patch.psc
│  ├─ oio/
│  │  ├─ oio_controller.psc
│  │  └─ ova_lifecycle.psc
│  ├─ womb/
│  │  └─ access_controller.psc
│  ├─ parasites/
│  │  └─ parasite_pleasure.psc
│  ├─ bridge/            ← integration shims
│  │  ├─ slo_bridge.psc      (SLO arousal)
│  │  ├─ slso_bridge.psc     (orgasm events)
│  │  ├─ slate_bridge.psc    (tag queries)
│  │  ├─ odf_bridge.psc      (overlay ops)
│  │  ├─ fiss_bridge.psc     (preset I/O)
│  │  └─ sum_bridge.psc      (math/helpers)
│  ├─ fx/
│  │  ├─ scaler_integration.psc
│  │  └─ apropos_bridge.psc
│  └─ util/
│     ├─ debug.psc
│     └─ math.psc
└─ package/
   └─ FOMOD + ESL/ESP assets (later)
```

---

## 13) Commit Notes (suggested)

- **feat(doc): update Vesselbound DESIGN spec v0.2** — adds framework detection (SLO, SLSO, SLATE, ODF, FISS, MCM Helper, SUM, Acheron, Dynamic Persistent Forms), clarifies integration hooks, MCM preset export, and Phase 1 goals.

**Next Up**: finalize Phase 1 implementation with MCM Helper bindings, FISS presets, and Debug page wiring.
