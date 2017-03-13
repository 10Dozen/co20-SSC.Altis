/*
 *	Mission Settings
 */
call dzn_fnc_getMissionParametes;



/*
 *	Area
 */
SSC_Area = [];
{
	SSC_Area pushBack ([_x, false] call dzn_fnc_convertTriggerToLocation);
} forEach (synchronizedObjects SSC_Location);

setTimeMultiplier par_env_timeMultiplier;

/*
 *	Functions
 */
dzn_fnc_GenerateRandomPath = {
	private _num = _this;
	
	private _cps = [];
	
	// Start Pos
	private _pos = SSC_Area call dzn_fnc_getRandomPointInZone;
	_cps pushBack _pos;
	
	// Other positions
	for "_i" from 1 to _num do {
		private _newPos = [-100,-100,0];
		
		while { 
			!([_newPos, SSC_Area] call dzn_fnc_isInLocation) 
			|| (_newPos call dzn_fnc_isInWater) 
			|| { _newPos distance2d _x < par_path_DistnaceBetweenCPs / 1.5 } count _cps > 0
		} do {
			_newPos = [_cps select (_i - 1), random 360, par_path_DistnaceBetweenCPs] call dzn_fnc_getPosOnGivenDir;
		};
		
		if ( !([_newPos, SSC_Area] call dzn_fnc_isInLocation) || (_newPos call dzn_fnc_isInWater) ) then {
			_newPos = [_cps select (_i - 1), random[-130,0,130], par_path_DistnaceBetweenCPs] call dzn_fnc_getPosOnGivenDir;
		} else {	
			_cps pushBack _newPos;
		};
	};
	
	_cps
};

dzn_fnc_drawMarkersForCPs = {
	{
		[format ["mrk_cp_%1_%2", _forEachIndex, time], _x, "hd_dot", "ColorBlack", format["CP %1", _forEachIndex], true] call dzn_fnc_createMarkerIcon;
	} forEach _this;
};


dzn_fnc_createSubMissionAsset = {
	private _pos = _this;	
	private _objClass = selectRandom ["CUP_O_BM21_RU","rhs_gaz66_r142_vv","CUP_O_BMP_HQ_RU","CUP_O_BTR90_HQ_RU","O_T_Truck_03_device_ghex_F","O_Truck_03_device_F"];
	
	private _newPos = [_pos, random 360, 200 + round(random 300)] call dzn_fnc_getPosOnGivenDir;
	while { 
		!([_newPos, SSC_Area] call dzn_fnc_isInLocation) 
		|| (_newPos call dzn_fnc_isInWater) 
		|| { _newPos isFlatEmpty [(sizeof _objClass) / 5,0,300,(sizeof _objClass),0]) select 0 isEqualTo [] }
	} do {
		_newPos = [_pos, random 360, 200 + round(random 300)] call dzn_fnc_getPosOnGivenDir;
	};
	
	private _obj = createVehicle [_objClass, _newPos, [], 0, "NONE"];
	_obj lock true;	
	_obj allowDamage false;	
	_obj setDir (random 360);
	_obj setPosATL _newPos;
	_obj setVelocity [0,0,0];
	
	_obj
};


/*
	call compile preProcessFileLineNumbers "Logic\common.sqf";
	
	c = 5 call dzn_fnc_GenerateRandomPath;
	c call dzn_fnc_drawMarkersForCPs;
	



*/