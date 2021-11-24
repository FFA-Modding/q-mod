# WARNING!
This patch is bugged, please do not download it, I'll (V E L D) patch it with the v1.08.  
Plus, to make the game realize it's a real update, I'll add a v1.06 patch, maybe empty or maybe a basic version non-hack of the Q-Mod (Hack Frontal Assault)

## FileList.xml infos

To repack a game in a PSArc you'll have to create a `FileList.xml` and then write in the relative path to the file from the `FileList.xml`.  
For example, it may looks like that:  
```xml  
assets\data\configs\weapon.csv  
assets\data\configs\competitiveweapon.csv  
assets\data\configs\competitivedefense.csv  
assets\data\configs\ennemy.csv  
assets\data\configs\competitivebasepurchase.csv  
assets\data\configs\defense.cvs  
assets\levels\acid_refinery_pvp\scripts\global.lua  
assets\levels\pvp_dlc_0\scripts\herosetup.lua  
assets\levels\pvp_dlc_0\scripts\global.lua  
assets\levels\pvp_dlc0_\scripts\music.lua  
assets\levels\plasma_harvester_pvp_pre\scripts\zone_whitebox_gameplay.lua  
assets\levels\plasma_harvester_pvp_pre\scripts\global.lua  
assets\levels\plasma_harvester_pvp_pre\scripts\invasion_database.lua  
assets\levels\plasma_harvester_pvp_pre\levelconfig.lua  
assets\built\game\scripts\universal_global.lua```  
To pack a package, go to `Bruteforce Save Data` dir and start `PARAM_SFO_Editor.exe`.
TitleID = The identifier of the game in the region that you want to pkg. Here are the IDs:
- `Disc Europe   : BCES01594`
- `Disc America  : BCUS98380`
- `Pack Europe   : NPEA00378`
- `Pack America  : NPUA80642`
- `Pack Japan    : NPJA00089`
In the Title, enter the title of the patch or the game in the language you want to pack. Basically, write it in French, English or Japanese.
- Ratchet & Clank: Q-Force
- Ratchet & Clank: Full Frontal Assault
- ラチェット＆クランク 銀河戦隊Qフォース *(Spelling: Ratchet & Clank: Ginga Sentai Q-Force)*
In the version, set the latest version you have *(basically with no any modded patches, it's 1.05, but if you have every patches released on the Github, refer to the version name of it. For example, 1.07 was for the solo cheats.)*
In the target version, set the number of the version you're packing, for example if your patch is *1.06* well uninstall the *1.06*; *1.07* and upper patches and set it. If the target version is lower than the version set higher, down the version to `target-version - 1`. For example, if the target version is *1.06* then set version to *1.05*.  
In the add field, you can add `TITLE01` and upper `TITLE`s you can add translation in other languages. Refer to another `PARAM.SFO` to know what number of title is what language.
