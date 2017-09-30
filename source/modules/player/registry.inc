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
DialogResponse:registry(playerid, response, listitem, inputtext[])  
{  
	_LISTITEM();

    if(!response) 
		Kick(playerid);

	strmid(player[playerid][player_password], inputtext, 0, strlen(inputtext));

	if(!regex_check(inputtext, regex_password)) {
		ShowPlayerDialogEx(
			playerid, 
			"registry", 
			DIALOG_STYLE_INPUT, 
			!"Регистрация аккаунта | Выбор пароля", 
			!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nПридумайте сложный пароль, состоящий минимум из 6 символов.\nИспользуйте разные символы, в разном регистре и цифры.\n\nВведите придуманный пароль в поле ниже:\n\n{FF0000}Пароль должен быть длинее 6 и меньше 20 символов!", 
			!"Далее", 
			!"Отмена"
		);
	} else {
		ShowPlayerDialogEx(playerid, 
			"gender",
			DIALOG_STYLE_MSGBOX, 
			!"Регистрация аккаунта | Выбор пола персонажа", 
			!"{FFFFFF}Регистрация на "#COLOR #HOSTNAME"{FFFFFF}\n\nВыберите пол вашего персонажа:", 
			!"Мужской", 
			!"Женский"
		);
	}
    return 1;  
}  


DialogResponse:gender(playerid, response, listitem, inputtext[]) 
{
	_LISTITEM();
	_INPUTTEXT();

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

	PLAYER_OnPlayerConnect(playerid);
	return 1;
}