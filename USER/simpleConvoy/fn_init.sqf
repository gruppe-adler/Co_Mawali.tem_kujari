["UK3CB_UN_B_Kamaz_Closed", "init", {
	 params ["_vehicle"];

	 [_vehicle] call grad_simpleconvoy_fnc_attachCable;
	 
}, true, [], true] call CBA_fnc_addClassEventHandler;