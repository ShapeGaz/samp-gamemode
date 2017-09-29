/*
	This Source Code Form is subject to the terms of the Mozilla
	Public License, v. 2.0. If a copy of the MPL was not distributed
	with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
#include <a_samp>

#define GAMEMODE \
	"samp-gamemode"
#define HOSTNAME \ 
	"Samp RolePlay"
	
#define void%0(%1)\
	forward %0(%1); public %0(%1)

#undef MAX_PLAYERS
#define MAX_PLAYERS (300)

#if !defined BYTES_PER_CELL
 	const BYTES_PER_CELL = cellbits/charbits;
#endif

#define MAX_PLAYER_PASSWORD 20

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
#include "../source/library/pickfix.inc"//edwin pickup flood fix

#include "../source/modules/mysql.pwn"
#include "../source/modules/player.pwn"


main()
{
}

public OnGameModeInit()
{
	regex_password = regex_new("[0-9a-zA-Z!@#$%^&*]{6,20}");
	SetGameModeText(GAMEMODE);

	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	return true;
}

public OnGameModeExit() 
{
	regex_delete(regex_password);
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

stock SendSyntaxInfo(playerid, color, count, info[][])
{
	for(new i = 0; i < count; i++) {
		SendClientMessage(playerid, color, info[i]);
	}
}