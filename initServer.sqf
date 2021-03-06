/*
 *	You can change MissionDate to some specific date to override date set in mission editor:
 *		format:		[@Year, @Month, @Day, @Hours, @Minutes] (e.g. [2012, 12, 31, 12, 45])
 */
private _time = switch ("par_env_daytime" call BIS_fnc_getParamValue) do {
	case 0: { round(random 24) };
	case 1: { 5 + round(random 5) };
	case 2: { 10 + round(random 5) };
	case 3: { 17 + round(random 4) };
	case 4: { 21 + round(random 8) };
};

MissionDate = [
	date select 0
	, date select 1
	, date select 2
	, _time
	, selectRandom [0,10,15,20,25,30,40,45,50]
];
publicVariable "MissionDate";

/*
 * Date
 */
setDate MissionDate;

/*
 *	Weather
 */
if (!isNil "dzn_fnc_setWeather") then {
	("par_env_weather" call BIS_fnc_getParamValue) spawn dzn_fnc_setWeather;
};


/*
 *	Collect Some Player connection data
 */
PlayerConnectedData = [];
PlayerConnectedEH = addMissionEventHandler ["PlayerConnected", {
	diag_log "Client connected";
	diag_log _this;
	// [ DirectPlayID, getPlayerUID player, name player, @bool, clientOwner ]
	PlayerConnectedData pushBack _this;
	publicVariable "PlayerConnectedData";
}];


/*
 *	Logics
 */
[] execVM "Logic\server.sqf";