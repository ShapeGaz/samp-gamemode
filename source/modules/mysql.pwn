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

