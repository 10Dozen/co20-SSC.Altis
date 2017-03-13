// ***********************************
// Gear Kits 
// ***********************************
// ******** GEAR CLASSES **********
//
//	Maptools		"ACE_MapTools"	["ACE_MapTools",1]
//	Binocular		"Binocular"	["Binocular",1]		
//
// 	Map			"ItemMap"
//	Compass			"ItemCompass"
//	Watch			"ItemWatch"
//	Personal Radio		"ItemRadio"
//
// ******* KIT NAMES FORMAT ********
//  Kit names format:		kit_FACTION_ROLE
//	Platoon Leader / Командир Взвода	->	kit_ussf_pl
//	Squad Leader / Командир отделения	->	kit_ussf_sl
//	Section Leader				->	kit_ussf_sl
//	2IC					->	kit_ussf_2ic
//	Fireteam Leader				->	kit_ussf_ftl
//	Automatic Rifleman			->	kit_ussf_ar
//	Grenadier / Стрелок (ГП)		->	kit_ussf_gr
//	Rifleman / Стрелок			->	kit_ussf_r
//	Экипаж					->	kit_ussf_crew
//	Пулеметчик				->	kit_ussf_mg
//	Стрелок-Гранатометчик			->	kit_ussf_at
//	Стрелок, помощник гранатометчика	->	kit_ussf_aat
//	Старший стрелок				->	kit_ussf_ar / kit_ussf_ss
//	Снайпер					->	kit_ussf_mm
// ****************
//
// ******** USEFUL MACROSES *******
// Maros for Empty weapon
#define EMPTYKIT	[["","","","",""],["","","","",""],["","","","",""],["","","","",""],[],[["",0],["",0],["",0],["",0],["",0],["",0],["",0],["",0],["",0]],[["",0],["",0],["",0],["",0],["",0],["",0]],[]]
// Macros for Empty weapon
#define EMPTYWEAPON	"","",["","","",""]
// Macros for the list of items to be chosen randomly
#define RANDOM_ITEM	["H_HelmetB_grass","H_HelmetB"]
// Macros to give the item only if daytime is in given inerval (e.g. to give NVGoggles only at night)
#define NIGHT_ITEM(X)	if (daytime < 9 || daytime > 18) then { X } else { "" }

// ******** ASSIGNED and UNIFORM ITEMS MACRO ********
#define NVG_NIGHT_ITEM		if (daytime < 9 || daytime > 18) then { "NVGoggles_OPFOR" } else { "" }
#define BINOCULAR_ITEM		"Binocular"

#define ASSIGNED_ITEMS		"ItemMap","ItemCompass","ItemWatch","ItemRadio", NVG_NIGHT_ITEM
#define ASSIGNED_ITEMS_L		"ItemMap","ItemCompass","ItemWatch","ItemRadio"

#define UNIFORM_ITEMS		["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_elasticBandage",5],["ACE_tourniquet",2],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_quikclot",5],["ACE_CableTie",2],["ACE_Flashlight_XL50",1],["ACE_EarPlugs",1]
#define UNIFORM_ITEMS_L		["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_elasticBandage",5],["ACE_tourniquet",2],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_quikclot",5],["ACE_CableTie",2],["ACE_Flashlight_XL50",1],["ACE_EarPlugs",1],["ACE_MapTools",1]
// ****************


/*
	Hat:
		"H_Booniehat_oli"
	Backpack:
		"B_AssaultPack_rgr"
	Ghillie:
		"U_B_GhillieSuit"
		vs.
		"U_B_CombatUniform_mcam"
		
	Vests:
		"CUP_V_B_LHDVest_Yellow"
		"CUP_V_B_LHDVest_White"
		"CUP_V_B_LHDVest_Violet"
		"CUP_V_B_LHDVest_Red"
		"CUP_V_B_LHDVest_Green"
		"CUP_V_B_LHDVest_Brown"
		"CUP_V_B_LHDVest_Blue"
		
		vs
		
		"V_PlateCarrier1_rgr"
*/

// Generate equipment according to Mission Parameters
private _vest = "";
if ("par_team_EquipmentVest" call BIS_fnc_getParamValue == 0) then { 
	_vest = [
		"CUP_V_B_LHDVest_Yellow"		
		,"CUP_V_B_LHDVest_Violet"
		,"CUP_V_B_LHDVest_Red"
		,"CUP_V_B_LHDVest_Green"
		,"CUP_V_B_LHDVest_Brown"
		,"CUP_V_B_LHDVest_Blue"
		,"CUP_V_B_LHDVest_White"
		,"CUP_V_B_LHDVest_Yellow"
		,"CUP_V_B_LHDVest_Violet"
		,"CUP_V_B_LHDVest_Red"	
	] select ((player getVariable "SSC_Team") -1);
} else {
	_vest = "V_PlateCarrier1_rgr"
};
private _uniform = if ("par_team_EquipmentGhillie" call BIS_fnc_getParamValue == 0) then { "U_B_CombatUniform_mcam" } else { "U_B_GhillieSuit" };
private _binocular = if ("par_team_EquipmentBinoculars" call BIS_fnc_getParamValue == 0) then { "Binocular" } else { "ACE_Vector" };
private _nvg = if ("par_team_EquipmentNVG" call BIS_fnc_getParamValue == 0) then { "" } else { "NVGoggles_OPFOR" };

//		SSC KITS

kit_ssc_pathfinder = [
	["<EQUIPEMENT >>  ", _uniform, _vest,"B_AssaultPack_rgr","H_Booniehat_oli",""],
	["<PRIMARY WEAPON >>  ","rhs_weap_m24sws","rhsusf_5Rnd_762x51_m118_special_Mag",["","","rhsusf_acc_LEUPOLDMK4","rhsusf_acc_harris_swivel"]],
	["<LAUNCHER WEAPON >>  ","","",["","","",""]],
	["<HANDGUN WEAPON >>  ","","",["","","",""]],
	["<ASSIGNED ITEMS >>  ", ASSIGNED_ITEMS_L, _binocular, _nvg],
	["<UNIFORM ITEMS >> ",[UNIFORM_ITEMS_L]],
	["<VEST ITEMS >> ",[]],
	["<BACKPACK ITEMS >> ",[["ACE_RangeCard",1],["ACE_Chemlight_HiRed",1],["Chemlight_green",1],["B_IR_Grenade",2],["SmokeShellRed",1],["SmokeShellBlue",1],["HandGrenade",2],["PRIMARY MAG",10]]]
];

kit_ssc_rifleman = [
	["<EQUIPEMENT >>  ", _uniform, _vest,"B_AssaultPack_rgr","H_Booniehat_oli",""],
	["<PRIMARY WEAPON >>  ","rhs_weap_mk18_grip","30Rnd_556x45_Stanag",["rhsusf_acc_rotex5_grey","ACE_acc_pointer_green","rhsusf_acc_SpecterDR_A","rhsusf_acc_grip1"]],
	["<LAUNCHER WEAPON >>  ","","",["","","",""]],
	["<HANDGUN WEAPON >>  ","","",["","","",""]],
	["<ASSIGNED ITEMS >>  ", ASSIGNED_ITEMS_L, _binocular, _nvg],
	["<UNIFORM ITEMS >> ",[UNIFORM_ITEMS_L]],
	["<VEST ITEMS >> ",[]],
	["<BACKPACK ITEMS >> ",[["30Rnd_556x45_Stanag",10],["ACE_Chemlight_HiRed",1],["Chemlight_green",1],["B_IR_Grenade",2],["SmokeShellRed",1],["SmokeShellBlue",1],["HandGrenade",2]]]
];

