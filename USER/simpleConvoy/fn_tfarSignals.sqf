if (!hasInterface) exitwith {};

// binding to the mission namespace and not the player object in particular:
["interceptTFARCalls", "OnTangent", {
	params ["_unit", "_radioclass", "_type", "_additional", "_pressed"];

	if (_pressed && _type == 2) then {
		private _channel = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrChannel;
		systemChat str _channel;
	};
}, ObjNull] call TFAR_fnc_addEventHandler;
