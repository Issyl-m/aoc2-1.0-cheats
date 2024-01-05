# aoc2-1.0-cheats

Proof of concept of multi-player cheats for Age of Empires II: The Conquerors (ver. 1.0). I have coded multiple cheats in the 2012s for this game, including a map-hack, delete-hack, control-hack (that moves other player units), infinite resources, and early technologies. The memory addresses related to the game hardcoded in this project are the result of reverse engineering using `Immunity Debugger` (https://www.immunityinc.com/products/debugger/). A more modern alternative would be to use `x64dbg` (https://x64dbg.com/). A similar process should lead to the same cheats in version 1.0c of AoE II. 

# Compilation

This project was entirely written in `fasm` (https://flatassembler.net/). Remember to update the following line in `main.asm` with the corresponding path:

1. `include 'C:\fasmw16726\INCLUDE\win32ax.inc'`.