tS_TFAR_Disable = true;

tf_no_auto_long_range_radio = true; 
tf_same_sw_frequencies_for_side = true; 
tf_same_lr_frequencies_for_side = true; 
tf_same_dd_frequencies_for_side = true;	
tf_give_microdagr_to_soldier = true;

// *****
tSF_DEBUG = true;

// dzn Gear
  // set true to engage Edit mode
[false] execVM "dzn_gear\dzn_gear_init.sqf";

// dzn DynAI
[] execVM "dzn_dynai\dzn_dynai_init.sqf";

  // TS Framework
[] execVM "dzn_tSFramework\dzn_tSFramework_Init.sqf";

// *****


[] execVM "Logic\common.sqf";
if (hasInterface) then {
	[] execVM "Logic\client.sqf";
};