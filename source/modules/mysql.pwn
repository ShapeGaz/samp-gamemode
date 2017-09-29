/*
	This Source Code Form is subject to the terms of the Mozilla
	Public License, v. 2.0. If a copy of the MPL was not distributed
	with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

#if !defined MYSQL_MODULE_
	#define MYSQL_MODULE_

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
	#if defined _mysql_OnGameModeInit
		return _mysql_OnGameModeInit();
	#endif
	}
	#if defined _ALS_OnGameModeInit
		#undef    OnGameModeInit
	#else
		#define    _ALS_OnGameModeInit
	#endif
	#define    OnGameModeInit    _mysql_OnGameModeInit
	#if defined _mysql_OnGameModeInit
	forward _mysql_OnGameModeInit();
	#endif  

	public OnGameModeExit()
	{
		mysql_close(connect_mysql);
	#if defined _mysql_OnGameModeExit
		return _mysql_OnGameModeExit();
	#endif
	}
	#if defined _ALS_OnGameModeExit
		#undef    OnGameModeExit
	#else
		#define    _ALS_OnGameModeExit
	#endif
	#define    OnGameModeExit    _mysql_OnGameModeExit
	#if defined _mysql_OnGameModeExit
	forward _mysql_OnGameModeExit();
	#endif  
#endif

