# Q-Mod / Full Frontal Mod

Credits:
- Created by Zaitara
- Dev by Zaitara and V E L D
- Testing by BellumZeldaDS and random victims

## INSTALLATION

To install the .psarc you have to **PUT** the **.psarc** in the installation folder on the PS3, for example:
- **EUROPE DISC**: `dev_hdd0/game/BCES001954/USRDIR/data/` and throw the **patch_`xx`.psarc** in here.
- **EUROPE PACKAGE**: `NPEA00378/USRDIR/data/` and throw the **patch_`xx`.psarc** in here.
- **AMERICAN DISC**: `dev_hdd0/game/BCUS98380/USRDIR/data/` and throw the **patch** in here.
- **AMERICAN PACKAGE**: `NPUA80642/USRDIR/data/` and throw the **patch_`xx`.psarc** in here.
- **JAPANESE PACKAGE**: `NPJA00089/USRDIR/data/` and throw the **patch_`xx`.psarc** in here.

To install the **.pkg**, you have to install a **[custom firmware like CFW](https://youtu.be/y2esLWRKLPI)** or **[HFW with HEN](https://www.youtube.com/watch?v=o3yjohY1Ues)** and then:
- Download the **.pkg** and put it on a USB key formatted in FAT32. Put the .pkg on "`E:\packages\`" (E:\ is an example).
- Put your USB key on a **USB port** of your PS3
- In **games category** on your XMB menu, go to "`⭐ Package Manager > 📁 Install Package File > 📁 Package Directory`"
- Select "QMFFMPatch_v`x.xx`.pkg" and **install it**.
**=> If this method don't work, use the first one.**

Start the game and try to launch a game on Markazia.
If you don't see the changes *(plasma barricades...)*, then retry to install the game or the patch.

## DISCLAIMER
Please, DO NOT use this mod to win easily on other players by using unavailable weapons. If you get ban for reasons we don't know, we're not responsible of.

# MODDING TOOLS

Mod that you NEED to mod the game:
- **[PS3 Game Extractor](https://www.psx-place.com/resources/ps3-game-extractor.824/)** - Used to unpack and pack the `.pkg` and `.psarc` file.
- **[Unluac](https://github.com/HansWessels/unluac)** - Used to decompile and recompile the `.lc` files.
- **[Lua Bytecode](https://lua-bytecode.github.io)** - Used to add the **`B4404`** headers to the `.lc` files.
- **[PS3 COBRA 4.88.2 Custom FirmWare](https://youtu.be/y2esLWRKLPI)** - Used to patch the game on PS3.
- **[Visual Studio Code](https://code.visualstudio.com)** - Used to modify the .lua files easily than with the notepad.
- **[MultiMAN](https://store.brewology.com/multiman.php)** / **PS3 SIDE** - Used to modify the files of the PS3 from a computer with the FTP, or from the PS3 itself with the files explorer.