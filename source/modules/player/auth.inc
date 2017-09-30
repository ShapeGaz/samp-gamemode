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
DialogResponse:auth(playerid, response, listitem, inputtext[]) 
{
	_LISTITEM();
	
	if(!response)
		Kick(playerid);
				
	new hash[64 + 1];

	SHA256_PassHash(inputtext, player[playerid][player_salt], hash, 65);
				
	if(!strcmp(hash, player[playerid][player_password], false)) {
		SpawnPlayer(playerid);
	} else {
		if(player[playerid][player_attempt] == 3) {
			Kick(playerid);
		
			player[playerid][player_attempt] += 1;
			ShowPlayerDialogEx(
				playerid, 
				"auth", 
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
	return 1;
}