/*
	 Copyright (c) 2017 Yuriy Abramov (RegasenDev)
 
	Permission is hereby granted, free of charge, to any person obtaining
	a copy of6 this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:
	
	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <a_samp>

#define GAMEMODE \
	"RolePlay"
#define HOSTNAME \ 
	"Regasen RolePlay"
	
#define void%0(%1)\
	forward %0(%1); public %0(%1)

#undef MAX_PLAYERS
#define MAX_PLAYERS (300)

#if !defined BYTES_PER_CELL
 	const BYTES_PER_CELL = cellbits/charbits;
#endif

#define MAX_PLAYER_PASSWORD 20

#define _LISTITEM(); switch(listitem)  {}
#define _INPUTTEXT(); inputtext[0] = '\0';

enum {
	dialog_auth,
	dialog_reg,
	dialog_gender,
}

#define COLOR_64 0xFFA500FF
#define COLOR "{FFA500}"

new regex:regex_password;


#include "../source/library/crashdetect.inc"//crashdetect

#include "../source/library/a_mysql.inc"//R41-4
#include "../source/library/sscanf2.inc"//2.8.2
#include "../source/library/Pawn.CMD.inc"//Pawn.CMD
#include "../source/library/Pawn.Regex.inc"//Pawn.Regex
#include "../source/library/streamer.inc"//Streamer

#include "../source/library/dc_kickfix.inc"//DC kick/ban fix
#include "../source/library/foreach.inc"//foreach

#include "../source/library/u_dialogs.inc"//стяжкин

#include "../source/modules/player/player.pwn"

stock SendSyntaxInfo(playerid, color, count, info[][])
{
	for(new i = 0; i < count; i++) {
		SendClientMessage(playerid, color, info[i]);
	}
}

main()
{
}

new MySQL:connect_mysql;

public OnGameModeInit()
{
	connect_mysql = mysql_connect_file();
		
	if(mysql_errno() != 0) {
		print("Не удается подключиться к базе данных.");
		return false;
	} else {
		print("Подключение к базе данных установлено");
	}

	regex_password = regex_new("[0-9a-zA-Z!@#$%^&*]{6,20}");
	SetGameModeText(GAMEMODE);

	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

	SendRconCommand("hostname " #HOSTNAME);
	return true;
}

public OnGameModeExit() 
{
	mysql_close(connect_mysql);
	regex_delete(regex_password);
	return true;
}

public OnPlayerConnect(playerid)
{
#if defined PLAYER_MODULE_
	PLAYER_OnPlayerConnect(playerid);
#endif
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
#if defined PLAYER_MODULE_
	PLAYER_OnPlayerDisconnect(playerid, reason);
#endif
	return true;
}

public OnPlayerText(playerid, text[])
{
#if defined PLAYER_MODULE_
	PLAYER_OnPlayerText(playerid, text);
#endif
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
#if defined PLAYER_MODULE_
	PLAYER_OnPlayerRequestClass(playerid);
#endif
	return true;
}

public OnPlayerSpawn(playerid)
{
#if defined PLAYER_MODULE_
	PLAYER_OnPlayerSpawn(playerid);
#endif
	return true;
}

stock SendFormatMessage(playerid, color, fstring[], {Float, _}:...)
{
    static const STATIC_ARGS = 3;
    new n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;
    if(n == 0)
        return SendClientMessage(playerid, color, fstring);

    new message[128], arg_start, arg_end;        
    #emit CONST.alt        fstring
    #emit LCTRL              5
    #emit ADD
    #emit STOR.S.pri        arg_start

    #emit LOAD.S.alt        n
    #emit ADD
    #emit STOR.S.pri        arg_end
    do{
        #emit LOAD.I
        #emit PUSH.pri
        arg_end -= BYTES_PER_CELL;
        #emit LOAD.S.pri      arg_end
    }while(arg_end > arg_start);

    #emit PUSH.S          fstring
    #emit PUSH.C          128
    #emit PUSH.ADR       message

    n += BYTES_PER_CELL * 3;
    #emit PUSH.S           n
    #emit SYSREQ.C       format

    n += BYTES_PER_CELL;
    #emit LCTRL             4
    #emit LOAD.S.alt       n
    #emit ADD
    #emit SCTRL             4

    return SendClientMessage(playerid, color, message);
}   