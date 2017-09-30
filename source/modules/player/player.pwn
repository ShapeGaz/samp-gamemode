/*
	 Copyright (c) 2017 Yuriy Abramov (RegasenDev)
 
	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
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
#if !defined PLAYER_MODULE_
	#define PLAYER_MODULE_

	#include "../source/modules/player/variables.inc"
	#include "../source/modules/player/functions.inc"
	#include "../source/modules/player/registry.inc"
	#include "../source/modules/player/commands.inc"
	#include "../source/modules/player/auth.inc"
	
	stock PLAYER_OnPlayerConnect(playerid) {
		SetPlayerColor(playerid, 0xFFFFFF55);
		SetSpawnInfo(playerid, 0, 0, 1743.2384, -1861.7690, 13.5771, 356.6750, 0, 0, 0, 0, 0, 0);
				
		player[playerid][player_logged] = false;

		new ORM:orm_id = player[playerid][player_orm] = orm_create("players");

		orm_addvar_string(orm_id, player[playerid][player_nickname], MAX_PLAYER_NAME, "nickname");
		orm_addvar_string(orm_id, player[playerid][player_salt], 65, "salt");
		orm_addvar_string(orm_id, player[playerid][player_password], 65, "password");

		orm_addvar_int(orm_id, player[playerid][player_id], "id");
		orm_addvar_int(orm_id, player[playerid][player_skin], "skin");
		orm_addvar_int(orm_id, player[playerid][player_gender], "gender");
		orm_addvar_int(orm_id, player[playerid][player_level], "level");
		orm_addvar_int(orm_id, player[playerid][player_money], "money");

		orm_addvar_float(orm_id, player[playerid][player_health], "health");

		GetPlayerName(playerid, player[playerid][player_nickname], MAX_PLAYER_NAME);
		
		orm_setkey(orm_id, "nickname");

		orm_load(orm_id, "OnPlayerDataLoading", "d", playerid);
	}

	stock PLAYER_OnPlayerRequestClass(playerid) {
		new rand = random(12);
		InterpolateCameraPos(playerid, camera_start_position[rand][0][0], camera_start_position[rand][0][1], camera_start_position[rand][0][2], camera_start_position[rand][0][3], camera_start_position[rand][0][4], camera_start_position[rand][0][5], cam_start_time_pos[rand]);
		InterpolateCameraLookAt(playerid, camera_start_position[rand][1][0], camera_start_position[rand][1][1], camera_start_position[rand][1][2], camera_start_position[rand][1][3], camera_start_position[rand][1][4], camera_start_position[rand][1][5], cam_start_time_pos[rand]);
		return 1;
	}

	stock PLAYER_OnPlayerDisconnect(playerid, reason) {
		switch(reason) {
			default: {
				SavePlayer(playerid);
				orm_clear_vars(player[playerid][player_orm]);
			}
		}
	}
	
	stock PLAYER_OnPlayerSpawn(playerid) {
		if(!player[playerid][player_logged]) {
			player[playerid][player_logged] = !player[playerid][player_logged];
			orm_setkey(player[playerid][player_orm], "id");

			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, player[playerid][player_money]);
			SetPlayerHealth(playerid, player[playerid][player_health]);
			SetPlayerScore(playerid, player[playerid][player_level]);
			SetPlayerSkin(playerid, player[playerid][player_skin]);
		}
		SetPlayerPos(playerid, 1743.2384, -1861.7690, 13.5771);
		SetPlayerFacingAngle(playerid, 356.6750);
	}

	stock PLAYER_OnPlayerText(playerid, text[]) {
		FindSpecifiersInString(text, 144);
		format(text, 144, "(Чат: Местный) %s[%d]: {FFFFFF}%s", player[playerid][player_nickname], playerid, text);
		ProxDetector(playerid, 30.0, GetPlayerColor(playerid), text);
	}

	void OnPlayerDataLoading(playerid) 
	{
		GetPlayerName(playerid, player[playerid][player_nickname], MAX_PLAYER_NAME);

		switch(orm_errno(player[playerid][player_orm])) {
			case ERROR_NO_DATA: {
				orm_setkey(player[playerid][player_orm], "id");
				ShowPlayerDialogEx(
					playerid, 
					"registry",
					DIALOG_STYLE_INPUT, 
					!"Регистрация аккаунта", 
					!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nПридумайте сложный пароль, состоящий минимум из 6 символов.\nИспользуйте разные символы, в разном регистре и цифры.\n\nВведите придуманный пароль в поле ниже:", 
					!"Далее", 
					!"Отмена"
				);
			}
			
			case ERROR_OK: {
				SetSpawnInfo(playerid, 0, player[playerid][player_skin], 1743.2384, -1861.7690, 13.5771, 356.6750, 0, 0, 0, 0, 0, 0);
				ShowPlayerDialogEx(
					playerid, 
					"auth", 
					DIALOG_STYLE_INPUT, 
					!"Вход в аккаунт", 
					!"{FFFFFF}Авторизация на "#COLOR #HOSTNAME"{FFFFFF}\n\nВспомните пароль, введенный при регистрации.\n\nВведите этот пароль в поле ниже:", 
					!"Далее", 
					!"Отмена"
				);
			}
		}
	}
#endif