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

#if !defined SendSyntaxInfo
	stock SendSyntaxInfo(playerid, color, count, info[][])
	{
		for(new i = 0; i < count; i++) {
			SendClientMessage(playerid, color, info[i]);
		}
	}
#endif

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
