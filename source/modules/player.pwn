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

#if !defined GetDistanceBetweenPlayers 	
	stock Float:GetDistanceBetweenPlayers(const playerid, const targetid)
	{
		if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return -1.0;
		new Float:CurrentPos[3];
		GetPlayerPos(targetid, CurrentPos[0], CurrentPos[1], CurrentPos[2]);
		return GetPlayerDistanceFromPoint(playerid, CurrentPos[0], CurrentPos[1], CurrentPos[2]);
	}
#endif

#if !defined MYSQL_MODULE_
	#error "Error loading mysql module (Module: player)"
#endif

#if !defined PLAYER_MODULE_
	#define PLAYER_MODULE_

	static const Float:camera_start_position[12][2][6] = {
		{
			{1482.074462, -898.318481, 92.719245, 1482.074462, -898.318481, 92.719245},
			{1479.071166, -894.389892, 91.979782, 1479.071166, -894.389892, 91.979782}
		},
		{
			{423.594848, -2073.024902, 43.753078, 423.594848, -2073.024902, 43.753078},
			{422.012817, -2068.566406, 42.134643, 422.012817, -2068.566406, 42.134643}
		},
		{
			{905.401794, -1200.925048, 106.217491, 905.401794, -1200.925048, 106.217491},
			{910.388732, -1201.068725, 105.885704, 910.388732, -1201.068725, 105.885704}
		},
		{
			{2042.314697, 1462.658447, 34.089710, 2042.314697, 1462.658447, 34.089710},
			{2038.087890, 1460.144287, 33.188415, 2038.087890, 1460.144287, 33.188415}
		},
		{
			{1720.672119, -1695.043334, 123.531272, 1720.672119, -1695.043334, 123.531272},
			{1718.984619, -1690.368896, 122.981605, 1718.984619, -1690.368896, 122.981605}
		},
		{
			{2869.032470, -1016.669128, 85.820434, 2869.032470, -1016.669128, 85.820434},
			{2866.939941, -1020.951416, 84.309280, 2866.939941, -1020.951416, 84.309280}
		},
		{
			{2924.099853, -1042.005615, 34.369697, 2924.099853, -1042.005615, 34.369697},
			{2923.572265, -1037.038574, 34.147113, 2923.572265, -1037.038574, 34.147113}
		},
		{
			{1886.422851, -832.526062, 137.030166, 1886.422851, -832.526062, 137.030166},
			{1883.315795, -836.421569, 136.616577, 1883.315795, -836.421569, 136.616577}
		},
		{
			{-1168.268310, 1134.234008, 136.937957, -1168.268310, 1134.234008, 136.937957},
			{-1172.385009, 1131.439697, 136.442672, -1172.385009, 1131.439697, 136.442672}
		},
		{
			{-1011.961486, 2105.833984, 149.920181, -1011.961486, 2105.833984, 149.920181},
			{-1007.483459, 2104.049316, 148.592544, -1007.483459, 2104.049316, 148.592544}
		},
		{
			{22.611024, -1959.371337, 84.940864, 22.611024, -1959.371337, 84.940864},
			{26.822828, -1956.851684, 83.985832, 26.822828, -1956.851684, 83.985832}
		},
		{
			{1494.964233, 13.226538, 189.263305, 1481.021728, -1798.964599, 254.696289},
			{1494.903320, 8.249490, 188.788665, 1481.015502, -1795.936523, 250.717529}
		}
	},

	cam_start_time_pos[12] = {
		2000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 50000
	};

	enum player_e {
		player_id,
		player_gender,
		player_skin,
		player_attempt,
		player_money,
		Float:player_health,
		ORM:player_orm,
		player_nickname[MAX_PLAYER_NAME + 1],
		player_password[65 + 1],
		player_salt[64 + 1],
		bool:player_logged
	};

	new player[MAX_PLAYERS][player_e];

	new novice_skin[2][10] = {
		{1, 2, 3, 6, 7, 20, 21, 22, 23, 24}, 
		{12, 13, 190, 41, 55, 56, 69, 91, 93, 148}
	};

	stock PlayerConnectCallback(playerid) {

		SetPlayerColor(playerid, 0xFFFFFF55);

		player[playerid][player_logged] = false;

		new ORM:orm_id = player[playerid][player_orm] = orm_create("players");

		orm_addvar_string(orm_id, player[playerid][player_nickname], MAX_PLAYER_NAME, "nickname");
		orm_addvar_string(orm_id, player[playerid][player_salt], 65, "salt");
		orm_addvar_string(orm_id, player[playerid][player_password], 65, "password");

		orm_addvar_int(orm_id, player[playerid][player_id], "id");
		orm_addvar_int(orm_id, player[playerid][player_skin], "skin");
		orm_addvar_int(orm_id, player[playerid][player_gender], "gender");
		orm_addvar_int(orm_id, player[playerid][player_money], "money");

		orm_addvar_float(orm_id, player[playerid][player_health], "health");

		GetPlayerName(playerid, player[playerid][player_nickname], MAX_PLAYER_NAME);
		
		orm_setkey(orm_id, "nickname");

		orm_load(orm_id, "OnPlayerDataLoading", "d", playerid);
	}

	void OnPlayerDataLoading(playerid) {
		GetPlayerName(playerid, player[playerid][player_nickname], MAX_PLAYER_NAME);

		switch(orm_errno(player[playerid][player_orm])) {
			case ERROR_NO_DATA: {
				orm_setkey(player[playerid][player_orm], "id");
				ShowPlayerDialog(
					playerid, 
					dialog_reg,
					DIALOG_STYLE_INPUT, 
					!"Регистрация аккаунта", 
					!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nПридумайте сложный пароль, состоящий минимум из 6 символов.\nИспользуйте разные символы, в разном регистре и цифры.\n\nВведите придуманный пароль в поле ниже:", 
					!"Далее", 
					!"Отмена"
				);
			}
			
			case ERROR_OK: {
				SetSpawnInfo(playerid, 0, player[playerid][player_skin], 1743.2384, -1861.7690, 13.5771, 356.6750, 0, 0, 0, 0, 0, 0);
				ShowPlayerDialog(
					playerid, 
					dialog_auth, 
					DIALOG_STYLE_INPUT, 
					!"Вход в аккаунт", 
					!"{FFFFFF}Авторизация на "#COLOR #HOSTNAME"{FFFFFF}\n\nВспомните пароль, введенный при регистрации.\n\nВведите этот пароль в поле ниже:", 
					!"Далее", 
					!"Отмена"
				);
			}
		}
	}

	stock PlayerRequestClassCallback(playerid) {
		new rand = random(12);
		InterpolateCameraPos(playerid, camera_start_position[rand][0][0], camera_start_position[rand][0][1], camera_start_position[rand][0][2], camera_start_position[rand][0][3], camera_start_position[rand][0][4], camera_start_position[rand][0][5], cam_start_time_pos[rand]);
		InterpolateCameraLookAt(playerid, camera_start_position[rand][1][0], camera_start_position[rand][1][1], camera_start_position[rand][1][2], camera_start_position[rand][1][3], camera_start_position[rand][1][4], camera_start_position[rand][1][5], cam_start_time_pos[rand]);
		return true;
	}

	stock DialogResponseCallback(playerid, dialogid, response, listitem, inputtext[]) {
		switch(dialogid) {
			case dialog_reg: {
				if(!response) 
					Kick(playerid);

				strmid(player[playerid][player_password], inputtext, 0, strlen(inputtext));

				if(!regex_check(inputtext, regex_password)) {
					ShowPlayerDialog(
						playerid, 
						dialog_reg, 
						DIALOG_STYLE_INPUT, 
						!"Регистрация аккаунта | Выбор пароля", 
						!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nПридумайте сложный пароль, состоящий минимум из 6 символов.\nИспользуйте разные символы, в разном регистре и цифры.\n\nВведите придуманный пароль в поле ниже:\n\n{FF0000}Пароль должен быть длинее 6 и меньше 20 символов!", 
						!"Далее", 
						!"Отмена"
					);
				} else {
					ShowPlayerDialog(playerid, 
						dialog_gender,
						DIALOG_STYLE_MSGBOX, 
						!"Регистрация аккаунта | Выбор пола персонажа", 
						!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nВыберите пол вашего персонажа:", 
						!"Мужской", 
						!"Женский"
					);
				}
			}

			case dialog_auth: {
				if(!response)
					Kick(playerid);
				
				new hash[64 + 1];

				SHA256_PassHash(inputtext, player[playerid][player_salt], hash, 65);
				
				if(!strcmp(hash, player[playerid][player_password], false)) {
					SpawnPlayer(playerid);
				} else {
					if(player[playerid][player_attempt] == 3) {
						Kick(playerid);
					}

					player[playerid][player_attempt] += 1;
					ShowPlayerDialog(
						playerid, 
						dialog_auth, 
						DIALOG_STYLE_INPUT, 
						!"Вход в аккаунт", 
						!"{FFFFFF}Авторизация на "#COLOR #HOSTNAME"{FFFFFF}\n\nВспомните пароль, введенный при регистрации.\n\nВведите этот пароль в поле ниже:", 
						!"Далее", 
						!"Отмена"
					);

					SendFormatMessage(
						playerid, 
						COLOR_64, 
						!"Не верный пароль, попробуйте заного.У вас осталось %d попыток(и)", 
						(4 - player[playerid][player_attempt])
					);
				}
			}

			case dialog_gender: {
				player[playerid][player_gender] = response;
				player[playerid][player_skin] = novice_skin[response ? 0 : 1][random(10) + 1];
				player[playerid][player_salt][0] = '\0';

				new hash[64 + 1];

				GenerateSalt(player[playerid][player_salt]);
				SHA256_PassHash(player[playerid][player_password], player[playerid][player_salt], hash, 64);
				strmid(player[playerid][player_password], hash, 0, sizeof(hash));
				
				player[playerid][player_health] = 100.0;
				player[playerid][player_money] = 250;

				orm_insert(player[playerid][player_orm], "", "", "");

				orm_update(player[playerid][player_orm]);

				PlayerConnectCallback(playerid);
			}
		}
	}

	stock PlayerDisconnectCallback(playerid, reason) {
		switch(reason) {
			default: {
				SavePlayer(playerid);

				orm_clear_vars(player[playerid][player_orm]);
			}
		}
	}
	
	stock PlayerSpawnCallback(playerid) {
		if(!player[playerid][player_logged]) {
			player[playerid][player_logged] = !player[playerid][player_logged];
			orm_setkey(player[playerid][player_orm], "id");

			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, player[playerid][player_money]);
			SetPlayerHealth(playerid, player[playerid][player_health]);
		}
		SetPlayerPos(playerid, 1743.2384, -1861.7690, 13.5771);
		SetPlayerFacingAngle(playerid, 356.6750);
	}

	stock PlayerTextCallback(playerid, text[]) {
		FindSpecifiersInString(text, 144);
		format(text, 144, "(Чат: Местный) %s[%d]: {FFFFFF}%s", player[playerid][player_nickname], playerid, text);
		ProxDetector(playerid, 30.0, GetPlayerColor(playerid), text);
	}

	CMD:gc(playerid, text[]) 
	{
		new args[][] = {
			!"[Аргумент команды]{FFA500} text - {FFE801}Текст в глобальный чат."
		};

		if(sscanf(text, "s[110]", text)) {
			SendClientMessage(playerid, -1, !"Синтаксис команды: /gc [text]");
			SendSyntaxInfo(playerid, 0x479200FF, 1, args);
			
			return true;
		}

		FindSpecifiersInString(text, 144);
		format(text, 144, "(Чат: Глобальный) %s[%d]: {FFFFFF}%s", player[playerid][player_nickname], playerid, text);
		ProxDetector(playerid, 30.0, GetPlayerColor(playerid), text);
		return true;
	}

	CMD:pay(playerid, params[]) 
	{
		new 
			targetid,
			count;
			
		new args[][] = {
			!"[Аргумент команды]{FFA500} targetid - {FFE801}Идентификатор игрока.",
			!"[Аргумент команды]{FFA500} count - {FFE801}Количество денег, которое необходимо передать."
		};

		if(sscanf(params, "dd", targetid, count) || count < 1) {
			SendClientMessage(playerid, -1, !"Синтаксис команды: /pay [targetid] [count]");
			SendSyntaxInfo(playerid, 0x479200FF, 2, args);
			
			return true;
		}
		
		if(GetDistanceBetweenPlayers(playerid, targetid) > 15.0) {
			SendClientMessage(playerid, 0xFFA500FF, !"Данный игрок слишком далеко от вас.");
			return true;
		}

		if(player[playerid][player_money] < count) {
			SendClientMessage(playerid, 0xFFA500FF, !"У вас нету столько наличных.");
			return true;
		}

		if(!IsPlayerConnected(targetid) || playerid == targetid) {
			SendClientMessage(playerid, 0xFFA500FF, !"Игрока с данным идентификатором несуществует.");
			return true;
		}

		player[playerid][player_money] -= count;
		player[targetid][player_money] += count;

		SendFormatMessage(playerid, 0x29ae00ff, !"%s[%d] передал вам $%d", player[playerid][player_nickname], playerid, count);
		SendFormatMessage(playerid, 0x29ae00ff, !"Вы передали $%d игроку %s[%d]", count, player[playerid][player_nickname], playerid);
		
		SavePlayer(playerid);
		
		return true;
	}


	stock SavePlayer(playerid)
	{
		GetPlayerHealth(playerid, player[playerid][player_health]);
		orm_save(player[playerid][player_orm]);
	}

	stock ProxDetector(playerid, Float:max_range, color, string[], Float:max_ratio = 1.6) 
	{ 
		new 
			Float:pos_x, 
			Float:pos_y, 
			Float:pos_z, 
			Float:range, 
			Float:range_ratio, 
			Float:range_with_ratio, 
			clr_r, clr_g, clr_b, 
			Float:color_r, Float:color_g, Float:color_b; 

		if (!GetPlayerPos(playerid, pos_x, pos_y, pos_z)) { 
			return 0; 
		} 

		color_r = float(color >> 24 & 0xFF); 
		color_g = float(color >> 16 & 0xFF); 
		color_b = float(color >> 8 & 0xFF); 
		range_with_ratio = max_range * max_ratio; 

	#if defined foreach 
		foreach (new i : Player) { 
	#else 
		for (new i = GetPlayerPoolSize(); i != -1; i--) { 
	#endif 
			if (!IsPlayerStreamedIn(playerid, i)) { 
				continue; 
			} 

			range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z); 
			if (range > max_range) { 
				continue; 
			} 

			range_ratio = (range_with_ratio - range) / range_with_ratio; 
			clr_r = floatround(range_ratio * color_r); 
			clr_g = floatround(range_ratio * color_g); 
			clr_b = floatround(range_ratio * color_b); 

			SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string); 
		} 

		SendClientMessage(playerid, color, string); 
		return 1; 
	}  

	stock FindSpecifiersInString(message[], array_size = sizeof(message))
	{
		new message_length = strlen(message);

		for(new i; i < message_length; i++)
		{
			if(message[i] == '%')
			{
				if(message_length < array_size) strins(message, "%", i++, message_length++);
				else message[i] = '#';
			}
		}
	}  

	stock GenerateSalt(salt[]) {
        new sample[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        for( new ch; ch < 63; ch++ ) {
                salt[ch] = sample[random(sizeof(sample) - 1)];
        }
	}

	public OnPlayerText(playerid, text[])
	{
		PlayerTextCallback(playerid, text);
	#if defined _player_OnPlayerText
		return _player_OnPlayerText(playerid, text);
	#endif
	}
	#if defined _ALS_OnPlayerText
		#undef    OnPlayerText
	#else
		#define    _ALS_OnPlayerText
	#endif
	#define    OnPlayerText    _player_OnPlayerText
	#if defined _player_OnPlayerText
	forward _player_OnPlayerText(playerid, text[]);
	#endif  

	public OnPlayerRequestClass(playerid, classid)
	{
		PlayerRequestClassCallback(playerid);
	#if defined _player_OnPlayerRequestClass
		return _player_OnPlayerRequestClass(playerid, classid);
	#endif
	}
	#if defined _ALS_OnPlayerRequestClass
		#undef    OnPlayerRequestClass
	#else
		#define    _ALS_OnPlayerRequestClass
	#endif
	#define    OnPlayerRequestClass    _player_OnPlayerRequestClass
	#if defined _player_OnPlayerRequestClass
	forward _player_OnPlayerRequestClass(playerid, classid);
	#endif  

	public OnPlayerSpawn(playerid)
	{
		PlayerSpawnCallback(playerid);
	#if defined _player_OnOnPlayerSpawn
		return _player_OnPlayerSpawn(playerid);
	#endif
	}
	#if defined _ALS_OnPlayerSpawn
		#undef    OnPlayerSpawn
	#else
		#define    _ALS_OnPlayerSpawn
	#endif
	#define    OnPlayerSpawn    _player_OnPlayerSpawn
	#if defined _player_OnPlayerSpawn
	forward _player_OnPlayerSpawn(playerid);
	#endif  


	public OnPlayerConnect(playerid)
	{
		PlayerConnectCallback(playerid);

	#if defined _player_OnPlayerConnect
		return _player_OnPlayerConnect(playerid);
	#else 
		return true;
	#endif
	}
	#if defined _ALS_OnPlayerConnect
		#undef    OnPlayerConnect
	#else
		#define    _ALS_OnPlayerConnect
	#endif
	#define    OnPlayerConnect    _player_OnPlayerConnect
	#if defined _player_OnPlayerConnect
	forward _player_OnPlayerConnect(playerid);
	#endif 

	public OnPlayerDisconnect(playerid, reason)
	{
		PlayerDisconnectCallback(playerid, reason);
	#if defined _player_OnPlayerDisconnect
		return _player_OnPlayerDisconnect(playerid, reason);
	#endif
	}
	#if defined _ALS_OnPlayerDisconnect
		#undef    OnPlayerDisconnect
	#else
		#define    _ALS_OnPlayerDisconnect
	#endif
	#define    OnPlayerDisconnect    _player_OnPlayerDisconnect
	#if defined _player_OnPlayerDisconnect
	forward _player_OnPlayerDisconnect(playerid, reason);
	#endif 

	public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
	{
		DialogResponseCallback(playerid, dialogid, response, listitem, inputtext);
	#if defined _player_OnDialogResponse
		return _player_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#endif
	}
	#if defined _ALS_OnDialogResponse
		#undef    OnDialogResponse
	#else
		#define    _ALS_OnDialogResponse
	#endif
	#define    OnDialogResponse    _player_OnDialogResponse
	#if defined _player_OnDialogResponse
	forward _player_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
	#endif 

#endif