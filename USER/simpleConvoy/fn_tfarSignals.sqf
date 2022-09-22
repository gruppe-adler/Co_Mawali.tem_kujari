if (!hasInterface) exitwith {};

// binding to the mission namespace and not the player object in particular:
["interceptTFARCalls", "OnTangent", {
	params ["_unit", "_radioclass", "_type", "_additional", "_pressed"];

	if (!_pressed && _type == 1) then {
		private _channel = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrChannel;
		
		if (_channel == 6) then {
			[_unit, true] call grad_simpleConvoy_fnc_tfarResponse;
		};

		if (_channel == 7) then {
			[{
				[_unit, false] call grad_simpleConvoy_fnc_tfarResponse;
			}, [], (random 3 max 1)] call CBA_fnc_waitAndExecute;
		};
	};
}, ObjNull] call TFAR_fnc_addEventHandler;


["interceptTFARChannelChange", "OnLRchannelSet", {
		params ["_unit", "_radio", "_type", "_channel", "_additional"];

		if (_channel == 6) then {
			hintSilent "send in this channel to move convoy";
		};

		if (_channel == 7) then {
			hintSilent "send in this channel to stop convoy";
		};
}, ObjNull] call TFAR_fnc_addEventHandler;
