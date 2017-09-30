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