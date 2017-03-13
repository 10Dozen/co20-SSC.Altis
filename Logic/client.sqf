if !(hasInterface) exitWith {};
player enableFatigue false;

private _teamLogic = synchronizedObjects player select 0;

player setVariable ["SSC_Team", parseNumber ((str(_teamLogic) splitString "_") select 1)]; 
player setVariable ["SSC_TeamLogic", _teamLogic]; 
player setVariable ["SSC_CurrentTask", taskNull ];
player setVariable ["SSC_CompetitionStarted", false]; 
player setVariable ["SSC_Processed", true];


/*	
 *	Functions
 */


dzn_fnc_c_move = {
	player setPos (((player getVariable "SSC_TeamLogic") getVariable "SSC_Path") select ((player getVariable "SSC_TeamLogic") getVariable "SSC_PathNode"));
};

dzn_fnc_c_MoveTo = {
	params["_u","_pos"];
	0 cutText ["", "WHITE OUT", 0.1];
	sleep 0.5;
	
	_u allowDamage false;
	if (vehicle _u != _u) then {
		moveOut _u;
	};
	_u switchMove "";
	_u setVelocity [0,0,0];
	_u setPosASL _pos;
	_u allowDamage true;
	
	sleep 2;
	0 cutText ["", "WHITE IN", 1];
};

dzn_fnc_c_getPathNode = {
	((player getVariable "SSC_TeamLogic") getVariable "SSC_Path") select _this
};

dzn_fnc_c_MoveTeamLogic = {
	(player getVariable "SSC_TeamLogic") setPos ( _this call dzn_fnc_c_getPathNode);
};

dzn_fnc_c_createTaskCP = {
	params ["_cpNum", "_pos"];
	
	private _taskID = format["Task_Team%1_CP%2", player getVariable "SSC_Team", _cpNum];
	[
		group player
		, _taskID
		, [
			format ["Find and move to Checkpoint %1 at grid %2", _cpNum, _pos call dzn_fnc_getMapGrid]
			, format ["Move to Checkpoint %1", _cpNum]
			, ""
		]
		, objNull
		, 1
		, 8
		, true
		, ""
		, false
	] call BIS_fnc_taskCreate;
	
	player setVariable ["SSC_CurrentTask", _taskID];
};

dzn_fnc_c_finishTaskCP = {
	// "CANCELED" / "SUCCEEDED" / "FAILED"
	[
		player getVariable "SSC_CurrentTask"
		,_this
		,true
	] spawn BIS_fnc_taskSetState;
};


dzn_fnc_c_doStartAction = {
	private _teamLogic = player getVariable "SSC_TeamLogic";
	
	// Generate path for team
	if (isNil {_teamLogic getVariable "SSC_Path"}) then {
		_teamLogic setVariable [
			"SSC_Path"
			, par_path_NumberOfCPs call dzn_fnc_GenerateRandomPath
			, true
		];
		
		_teamLogic setVariable ["SSC_Results", [], true];
		_teamLogic setVariable ["SSC_PathNode", 1, true];
		
		private _submissions = [];
		if (par_path_NumberOfCPs < par_path_NumberOfSubmissions) then {
			par_path_NumberOfSubmissions = par_path_NumberOfCPs;
		};
		
		if (par_path_NumberOfSubmissions > 0) then {
			private _cps = [];
			for _i from 1 to par_path_NumberOfCPs do { _cps pushBack _i; };			
			for _i from 1 to par_path_NumberOfSubmissions do {
				_submissions pushBack ( _cps call dzn_fnc_selectAndRemove; );
			};
		};
		
		_teamLogic setVariable ["SSC_SubMissions", _submissions, true];
	};
	
	{
		_x setVariable ["SSC_CompetitionStarted", true, true];
		_x setVariable ["SSC_Processed", false, true];
	} forEach (synchronizedObjects _teamLogic);
};

dzn_fnc_c_processStart = {
	private _teamLogic = player getVariable "SSC_TeamLogic";
	private _path = _teamLogic getVariable "SSC_Path";
	
	hint "Competition Started!";
	sleep 1;
	
	// Gear
	
	// Move to CP
	[player, 0 call dzn_fnc_c_getPathNode] spawn dzn_fnc_c_MoveTo;
	0 call dzn_fnc_c_MoveTeamLogic;
	
	// Task	
	[1, 1 call dzn_fnc_c_getPathNode] call dzn_fnc_c_createTaskCP;
};

dzn_fnc_c_doAbortAction = {
	private _result = [
		[format ["Are you sure, you want to Abort the competition?", _node], [0,0,0,.7]]
		, ["Yes", [.0,.4,.1,.5]]
		, ["No",[.4,.0,.0,.5]]
	] call dzn_fnc_ShowBasicDialog;
	
	if !(_result) exitWith {};
	
	hint "Competition Aborted";	
	sleep 2;
	
	private _teamLogic = player getVariable "SSC_TeamLogic";
	_teamLogic setPos (getMarkerPos "respawn_west");
	{
		_x setVariable ["SSC_CompetitionStarted", false, true];
		_x setVariable ["SSC_Processed", false, true];		
	} forEach (synchronizedObjects _teamLogic);
};

dzn_fnc_c_processAbort = {
	[player, getMarkerPos "respawn_west"] call dzn_fnc_c_MoveTo;	
	"CANCELED" call dzn_fnc_c_finishTaskCP;
};

dzn_fnc_c_doReportAction = {
	private _teamLogic = player getVariable "SSC_TeamLogic";
	private _node = _teamLogic getVariable "SSC_PathNode";

	private _result = [
		[format ["Are you sure, that you have reached Checkpoint %1?", _node], [0,0,0,.7]]
		, ["Report", [.0,.4,.1,.5]]
		, ["Cancel",[.4,.0,.0,.5]]
	] call dzn_fnc_ShowBasicDialog;
	
	if !(_result) exitWith {};
	
	private _calculated = [
		(getPos player) distance2d (_node call dzn_fnc_c_getPathNode)
		, 10
		, 300
	] call dzn_fnc_c_CalculateAccuracy;
	
	(_teamLogic getVariable "SSC_Results") pushBack _calculated;
	_teamLogic setVariable ["SSC_Results", _teamLogic getVariable "SSC_Results", true];
	
	_teamLogic setVariable ["SSC_PathNode", _node + 1, true];	
	if (_node + 1 > par_path_NumberOfCPs) then {
		_teamLogic setPos (getMarkerPos "respawn_west");
	} else {
		_node call dzn_fnc_c_MoveTeamLogic;
	};
	
	{
		_x setVariable ["SSC_Processed", false, true];
	} forEach (synchronizedObjects _teamLogic);
};

dzn_fnc_c_processReport = {
	private _teamLogic = player getVariable "SSC_TeamLogic";
	private _node = _teamLogic getVariable "SSC_PathNode";
	
	private _accuracy = str( (_teamLogic getVariable "SSC_Results") select (count (_teamLogic getVariable "SSC_Results") - 1) ) + "%";
	hint format ["Reported accuracy - %1", _accuracy];
	
	"SUCCEEDED" call dzn_fnc_c_finishTaskCP;
	
	sleep 2;
	if (_node > par_path_NumberOfCPs) then {
		sleep 2;
		[player, getMarkerPos "respawn_west"] call dzn_fnc_c_MoveTo;
		hint "Competition done";
	} else {
		[_node, _node call dzn_fnc_c_getPathNode] call dzn_fnc_c_createTaskCP;
	};
};


dzn_fnc_c_CalculateAccuracy = {
	params ["_dist", "_min", "_max"];
	
	if (_dist <= _min) exitWith { 100 };
	if (_dist > _max) exitWith { 0 };
	
	private _delta = _max - _min;
	private _val = 100 - ( 100 * (_dist - _min) ) / _delta;
	
	round(_val)
};




/*	
 *	Handlers
 */

addMissionEventHandler ["EachFrame", {
	if (player getVariable "SSC_Processed") exitWith {};

	if (player getVariable "SSC_CompetitionStarted") then {
		if ( (player getVariable "SSC_TeamLogic") getVariable "SSC_PathNode" > 1 ) then {
			[] spawn dzn_fnc_c_processReport;
		} else {
			[] spawn dzn_fnc_c_processStart;			
		};		
	} else {
		[] spawn dzn_fnc_c_processAbort;
	};
	
	player setVariable ["SSC_Processed", true];
}];

player addEventHandler ["Respawn", {
	[player, player getVariable "dzn_gear"] call dzn_fnc_gear_assignKit;
	player enableFatigue false;	
	
	player synchronizeObjectsAdd [player getVariable "SSC_TeamLogic"];
	
	if ( !isNil { ((player getVariable "SSC_TeamLogic") getVariable "SSC_PathNode") } ) then {
		[
			player
			, ((player getVariable "SSC_TeamLogic") getVariable "SSC_PathNode") call dzn_fnc_c_getPathNode
		] spawn dzn_fnc_c_MoveTo; 
	};
}];