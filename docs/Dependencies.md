
---

## External Dependencies
This project integrates with several adult framework mods. To ensure consistency:

### Fertility Mode Plus (Baka Edition)
- Canonical version: [NexusMods ID 46820](https://www.nexusmods.com/skyrimspecialedition/mods/46820)
- Source scripts are mirrored under `/external/FertilityModePlus`.
- These files are **read-only** for reference.  
  Vesselbound must not modify them directly.  
- Any compatibility patches should be placed in `/src/compat/FMPlusCompat.psc`.

### Other Mods
- **Fill Her Up (Baka)**, **SLA Aroused NG**, **Milk Mod Economy**, **Stress & Fear**, etc.  
  Vesselbound interacts through safe wrappers in `/src/compat/`.

---

## Workflow
1. **When coding with GPT**:  
   - Always open the repo version of the relevant file.  
   - If a snippet is pasted in chat, treat it as a draft unless tagged as “overwrite repo version.”

2. **When adding external references**:  
   - Mirror upstream `.psc` source files into `/external/<ModName>`.  
   - Include a `README.md` noting the exact mod version.

3. **When extending Vesselbound**:  
   - Add new scripts under `/src/vesselbound`.  
   - Place all third-party integration code in `/src/compat`.  
   - Update `/docs/CONTRIBUTING.md` if collaboration rules change.

---

## Coding Conventions
- **PapyrusUtil / StorageUtil** for persistent data.
- **Compat wrappers** must guard calls with presence checks.
- **Debug logging** should be MCM-toggleable.
- **Incremental updates** only — never assume full rewrites unless requested.

---

## License & Credits
- Vesselbound is an original work by [Your Name/Handle].  
- Fertility Mode Plus (Baka Edition) and other dependencies belong to their respective authors.  
- External source scripts are included for **reference only** and must not be redistributed outside this repo.

