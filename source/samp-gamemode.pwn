#include <a_samp>

#define GAMEMODE \
	"samp-gamemode"
	
#include "../source/library/a_mysql.inc"//R41-4
#include "../source/library/sscanf2.inc"//2.8.2
#include "../source/library/Pawn.CMD.inc"//Pawn.CMD
#include "../source/library/Pawn.Regex.inc"//Pawn.Regex

#include "../source/modules/mysql.pwn"

main()
{

}

public OnGameModeInit()
{
	SetGameModeText(GAMEMODE);
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	return true;
}

public OnGameModeExit()
{
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return true;
}

public OnPlayerConnect(playerid)
{
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	return true;
}

public OnPlayerSpawn(playerid)
{
	return true;
}
