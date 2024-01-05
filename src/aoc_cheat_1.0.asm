include 'C:\fasmw16726\INCLUDE\win32ax.inc'
include 'virtualkeys.inc'

section '.text' code readable writeable executable
	PID			dd ?
	hAoC			dd ?
	ReadBuff		db ?
	nopBuff 		db 6 dup (90h)
	byteJMP 		db 0EBh
	byteJNZ 		db 85h
	byteJZ			db 84h
	byteJZs 		db 74h
	RestoreMiniMapBuff	db 74h,02
	DisCtrlHackBuff1	db 75h,4Eh
	DisCtrlHackBuff2	db 75h,14h
	DisCtrlHackBuff3	db 0Fh,84h,77h,01,00,00
	DisCtrlHackBuff4	db 0Fh,85h,6Fh,02,00,00
	DisCtrlHackBuff5	db 75h,60h
	bTEST			dd 0
	GAIA			db 0
	ME			db 1
	SEND			db 0,0,0,1
	UNK1			db 0,0,0C8h,60h ; cantidad
	UNK2			db 0,0,0,0C0h
	SPEEDWOOD		db 0BDh
	SPEEDSTONE		db 4Fh
	SPEEDGOLD		db 2Fh
	SPEEDFOOD		db 0BEh
	FARMHACK		db 24h
	SPEEDHACK		db 0C3h
	SPIESHACK		db 0B7h
	CARTOHACK		db 32h
	FOOD100 		db 0
	WOOD100 		db 1
	STONE100		db 2
	GOLD100 		db 3
	POPHACK 		dw 104h
	szMutex 		db 'aoe_1.0_cheat',0
	szAocWindowTitle	db 'Age of Empires II Expansion',0

entry $
	invoke CreateMutex,0,1,addr szMutex
	invoke GetLastError
	cmp eax,0B7h
	jz fnAppExit

	invoke FindWindow,addr szAocWindowTitle,0
	or eax,eax
	jz fnAppExit
;==========================================================================================
	invoke GetWindowThreadProcessId,eax,addr PID
	invoke OpenProcess,PROCESS_VM_OPERATION+PROCESS_VM_READ+PROCESS_VM_WRITE,FALSE,[PID]
	mov [hAoC],eax
	; WaitForHacks
	invoke WriteProcessMemory,[hAoC],0076509Fh,addr fnWaitForHack,fnEndWaitForHack-fnWaitForHack,0
	invoke WriteProcessMemory,[hAoC],005EA325h,addr fnJmpWaitForHack,6,0
	invoke WriteProcessMemory,[hAoC],00420984h,addr CopyPlayerID,7,0
	; DeleteHack
	invoke WriteProcessMemory,[hAoC],004EBAF1h,addr nopBuff,2,0
	invoke WriteProcessMemory,[hAoC],004EBB01h,addr nopBuff,2,0
	invoke WriteProcessMemory,[hAoC],004EBB16h,addr nopBuff,2,0
;==========================================================================================
	@@:
	invoke FindWindow,addr szAocWindowTitle,0
	or eax,eax
	jz fnAppExit

	invoke Sleep,150
	invoke GetAsyncKeyState,VK_F5
	or eax,eax
	jnz fnControlHack

	invoke GetAsyncKeyState,VK_F6
	or eax,eax
	jnz fnMiniMapHack

	invoke GetAsyncKeyState,VK_F7
	or eax,eax
	jnz fnMapHack

	invoke ReadProcessMemory,[hAoC],00765169h,addr ME,1,0

	;;invoke GetAsyncKeyState,VK_MENU
	;;movsx ebx,ax
	;;invoke GetAsyncKeyState,VK_1
	;;cwde
	;;and eax,ebx
	;;test ah,80h
	;;jnz fnsWoodHack

	;;invoke GetAsyncKeyState,VK_MENU
	;;movsx ebx,ax
	;;invoke GetAsyncKeyState,VK_2
	;;cwde
	;;and eax,ebx
	;;test ah,80h
	;;jnz fnsStoneHack

	;;invoke GetAsyncKeyState,VK_MENU
	;;movsx ebx,ax
	;;invoke GetAsyncKeyState,VK_3
	;;cwde
	;;and eax,ebx
	;;test ah,80h
	;;jnz fnsGoldHack

	;;invoke GetAsyncKeyState,VK_MENU
	;;movsx ebx,ax
	;;invoke GetAsyncKeyState,VK_4
	;;cwde
	;;and eax,ebx
	;;test ah,80h
	;;jnz fnsFoodHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_5
	cwde
	and eax,ebx
	test ah,80h
	jnz fnFarmHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_6
	cwde
	and eax,ebx
	test ah,80h
	jnz fnSpeedHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_7
	cwde
	and eax,ebx
	test ah,80h
	jnz fnSpiesHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_8
	cwde
	and eax,ebx
	test ah,80h
	jnz fnCartographyHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_9
	cwde
	and eax,ebx
	test ah,80h
	jnz fnPopHack

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_Q
	cwde
	and eax,ebx
	test ah,80h
	jnz fnWood100

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_W
	cwde
	and eax,ebx
	test ah,80h
	jnz fnStone100

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_A
	cwde
	and eax,ebx
	test ah,80h
	jnz fnGold100

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_S
	cwde
	and eax,ebx
	test ah,80h
	jnz fnFood100

	invoke GetAsyncKeyState,VK_MENU
	movsx ebx,ax
	invoke GetAsyncKeyState,VK_X
	cwde
	and eax,ebx
	test ah,80h
	jnz fnTest

	jmp @B
;==========================================================================================
fnControlHack: ; (F5)
	invoke ReadProcessMemory,[hAoC],005BC6F0h,addr ReadBuff,1,0
	cmp byte[ReadBuff],90h
	jz fnDisableControlHack

		invoke WriteProcessMemory,[hAoC],005BC6F0h,addr nopBuff,2,0
		invoke WriteProcessMemory,[hAoC],005F9309h,addr nopBuff,2,0
		invoke WriteProcessMemory,[hAoC],005F9F03h,addr nopBuff,6,0
		invoke WriteProcessMemory,[hAoC],005BD8E1h,addr nopBuff,6,0
		invoke WriteProcessMemory,[hAoC],005F2F55h,addr nopBuff,2,0
		invoke WriteProcessMemory,[hAoC],004B4A69h,addr byteJMP,1,0

		jmp @B

fnDisableControlHack:
		invoke WriteProcessMemory,[hAoC],005BC6F0h,addr DisCtrlHackBuff1,2,0
		invoke WriteProcessMemory,[hAoC],005F9309h,addr DisCtrlHackBuff2,2,0
		invoke WriteProcessMemory,[hAoC],005F9F03h,addr DisCtrlHackBuff3,6,0
		invoke WriteProcessMemory,[hAoC],005BD8E1h,addr DisCtrlHackBuff4,6,0
		invoke WriteProcessMemory,[hAoC],005F2F55h,addr DisCtrlHackBuff5,2,0
		invoke WriteProcessMemory,[hAoC],004B4A69h,addr byteJZs,1,0

		jmp @B

fnMiniMapHack: ; (F6)
	invoke ReadProcessMemory,[hAoC],005DB9C3h,addr ReadBuff,1,0
	cmp byte[ReadBuff],90h
	jz fnDisableMiniMapHack

		invoke WriteProcessMemory,[hAoC],005DB9C3h,addr nopBuff,2,0

		jmp @B

fnDisableMiniMapHack:
		invoke WriteProcessMemory,[hAoC],005DB9C3h,addr RestoreMiniMapBuff,2,0

		jmp @B

fnMapHack: ; (F7)
	invoke ReadProcessMemory,[hAoC],005BFD0Ch,addr ReadBuff,1,0
	cmp byte[ReadBuff],85h
	jz fnDisableMapHack

		invoke WriteProcessMemory,[hAoC],005BFD0Ch,addr byteJNZ,1,0
		invoke WriteProcessMemory,[hAoC],005EF93Dh,addr DarkZoneHack,6,0
		invoke WriteProcessMemory,[hAoC],00489306h,addr byteJMP,1,0
		invoke WriteProcessMemory,[hAoC],0048930Ah,addr byteJMP,1,0
		invoke WriteProcessMemory,[hAoC],00489363h,addr byteJMP,1,0

		jmp @B

fnDisableMapHack:
		invoke WriteProcessMemory,[hAoC],005BFD0Ch,addr byteJZ,1,0
		invoke WriteProcessMemory,[hAoC],005EF93Dh,addr DisDarkZoneHack,6,0
		invoke WriteProcessMemory,[hAoC],00489306h,addr byteJZs,1,0
		invoke WriteProcessMemory,[hAoC],0048930Ah,addr byteJZs,1,0
		invoke WriteProcessMemory,[hAoC],00489363h,addr byteJZs,1,0

		jmp @B

fnsWoodHack: ; (ALT+1)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPEEDWOOD,1,0
	jmp fnWriteNextAddress2

fnsStoneHack: ; (ALT+2)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPEEDSTONE,1,0
	jmp fnWriteNextAddress2

fnsGoldHack: ; (ALT+3)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPEEDGOLD,1,0
	jmp fnWriteNextAddress2

fnsFoodHack: ; (ALT+4)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPEEDFOOD,1,0
	jmp fnWriteNextAddress2

fnFarmHack: ; (ALT+5)
	invoke WriteProcessMemory,[hAoC],00765093h,addr FARMHACK,1,0
	jmp fnWriteNextAddress2

fnSpeedHack: ; (ALT+6)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPEEDHACK,1,0
	jmp fnWriteNextAddress2

fnSpiesHack: ; (ALT+7)
	invoke WriteProcessMemory,[hAoC],00765093h,addr SPIESHACK,1,0
	jmp fnWriteNextAddress

fnCartographyHack: ; (ALT+8)
	invoke WriteProcessMemory,[hAoC],00765093h,addr CARTOHACK,1,0
	jmp fnWriteNextAddress

fnPopHack: ; (ALT+9)
	invoke WriteProcessMemory,[hAoC],00765093h,addr POPHACK,2,0
	jmp fnWriteNextAddress2

fnWood100: ; (ALT+Q)
	invoke WriteProcessMemory,[hAoC],00765093h,addr WOOD100,1,0
	jmp fnWriteNextAddress2

fnStone100: ; (ALT+W)
	invoke WriteProcessMemory,[hAoC],00765093h,addr STONE100,1,0
	jmp fnWriteNextAddress2

fnGold100: ; (ALT+E)
	invoke WriteProcessMemory,[hAoC],00765093h,addr GOLD100,1,0
	jmp fnWriteNextAddress2

fnFood100: ; (ALT+R)
	invoke WriteProcessMemory,[hAoC],00765093h,addr FOOD100,1,0
	jmp fnWriteNextAddress2

fnTest: ; (ALT+X)
	invoke WriteProcessMemory,[hAoC],00765093h,addr bTEST,4,0
	inc dword[bTEST]
	jmp fnWriteNextAddress2
;==========================================================================================
fnWriteNextAddress:
	invoke WriteProcessMemory,[hAoC],0076509Bh,addr GAIA,1,0
	invoke WriteProcessMemory,[hAoC],00765097h,addr ME,1,0
	invoke WriteProcessMemory,[hAoC],0076508Fh,addr SEND,4,0
	invoke WriteProcessMemory,[hAoC],0076508Bh,addr UNK2,4,0

	jmp @B

fnWriteNextAddress2:
	invoke WriteProcessMemory,[hAoC],0076509Bh,addr GAIA,1,0
	invoke WriteProcessMemory,[hAoC],00765097h,addr ME,1,0
	invoke WriteProcessMemory,[hAoC],0076508Fh,addr UNK1,4,0
	invoke WriteProcessMemory,[hAoC],0076508Bh,addr UNK2,4,0

	jmp @B

fnAppExit:
	invoke ExitProcess,0
;==========================================================================================
DarkZoneHack:
	mov ecx,-1
	nop

DisDarkZoneHack:
	mov ecx,dword[eax+128h]

fnJmpWaitForHack:
	db 0E9h,75h,0ADh,17h,00h
	nop

fnWaitForHack:
	mov edx,dword[eax+0A8h]

	pushad
	push dword[ds:0076508Bh]
	push dword[ds:0076508Fh]
	push dword[ds:00765093h]
	push dword[ds:00765097h]
	push dword[ds:0076509Bh]

	call @F
	add esp,14h

	mov dword[ds:0076508Bh],0
	mov dword[ds:0076508Fh],0
	mov byte[ds:00765093h],0
	mov byte[ds:00765097h],0
	mov byte[ds:0076509Bh],0

	popad

	db 0E9h,30h,52h,0E8h,0FFh

	@@:
	push ebp
	mov ebp,esp
	sub esp,8

	push ebx
	xor eax,eax
	push esi
	push edi
	mov dword[ebp-8],eax
	mov dword[ebp-4],eax
	pushad
	mov ecx,006833D0h
	mov ecx,dword[ecx]

	mov eax,00420970h
	call eax

	mov ecx,eax
	mov eax,dword[ecx+9Ch]
	mov dword[ebp-8],eax
	mov dword[ebp-4],ecx
	mov eax,dword[ebp+8]
	mov dword[ecx+9Ch],eax
	push dword[ebp+18h]
	push dword[ebp+14h]
	push dword[ebp+10h]
	push dword[ebp+0Ch]

	mov eax,005B3900h
	call eax

	mov ecx,dword[ebp-4]
	mov eax,dword[ebp-8]
	mov dword[ecx+9Ch],eax

	popad

	pop edi
	pop esi

	pop ebx
	leave
	retn

	mov cx,word[eax+94h]
	mov byte[ds:00765169h],cl
	db 0E9h,22h,0B8h,0CBh,0FFh
fnEndWaitForHack:
CopyPlayerID:
	db 0E9h,0CEh,47h,34h,00
	nop
	nop

section '.idata' import data readable writeable
 library kernel32,'kernel32.dll',\
	 user32,'user32.dll'

  import kernel32,\
	 CreateMutex,'CreateMutexA',\
	 GetLastError,'GetLastError',\
	 OpenProcess,'OpenProcess',\
	 ReadProcessMemory,'ReadProcessMemory',\
	 WriteProcessMemory,'WriteProcessMemory',\
	 Sleep,'Sleep',\
	 ExitProcess,'ExitProcess'

  import user32,\
	 FindWindow,'FindWindowA',\
	 GetWindowThreadProcessId,'GetWindowThreadProcessId',\
	 GetAsyncKeyState,'GetAsyncKeyState'
