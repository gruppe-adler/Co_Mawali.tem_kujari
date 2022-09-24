if (!isServer) exitWith {};

["UK3CB_UN_B_Kamaz_Closed", "init", {
	 params ["_vehicle"];

	 [_vehicle] call grad_simpleconvoy_fnc_attachCable;
	 [_vehicle] call grad_simpleconvoy_fnc_attachRicePallets;

}, true, [], true] call CBA_fnc_addClassEventHandler;


missionNamespace setVariable ["Mawali_convoyState", 0];

["Mawali_convoyState", {
		params [["_convoyGoBool", false], ["_zeus", false]];

		if (_zeus) then {
			missionNamespace setVariable ["Mawali_convoyStateZeus", _convoyGoBool];
		} else {
			missionNamespace setVariable ["Mawali_convoyStateEscort", _convoyGoBool];
		};

		private _convoyStateZeus = missionNamespace getVariable ["Mawali_convoyStateZeus", true];
		private _convoyStateEscort = missionNamespace getVariable ["Mawali_convoyStateEscort", true];

		if (_convoyStateZeus && _convoyStateEscort) then {
				private _speed = missionNamespace getVariable ["Mawali_convoySpeedCache", 0.01];
				["Mawali_convoySpeed", [_speed]] call CBA_fnc_serverEvent;
		};

		if (!_convoyStateZeus || !_convoyStateEscort) then {
				["Mawali_convoySpeed", [0.01]] call CBA_fnc_serverEvent;
		};

}] call CBA_fnc_addEventhandler;

["Mawali_convoySpeed", {
		params ["_speed"];

		if (_speed < 0.5) exitWith {
				// convoy says "stopping now"
				[boss, false] call grad_simpleConvoy_fnc_tfarResponse;
				private _previousSpeed = missionNamespace getVariable ["Mawali_convoySpeed", 0.01];
				missionNamespace setVariable ["Mawali_convoySpeedCache", _previousSpeed];
				missionNamespace setVariable ["Mawali_convoySpeed", 0.01];
		};
		
		// convoy says "running now"
		[boss, true] call grad_simpleConvoy_fnc_tfarResponse;
		missionNamespace setVariable ["Mawali_convoySpeed", _speed];
		missionNamespace setVariable ["Mawali_convoySpeedCache", _speed];

}] call CBA_fnc_addEventhandler;

/*

1 - Convoy stops - red escort, red zeus
2 - Convoy stops - green escort, red zeus
3 - Convoy runs - green escort, green zeus

1,2 - welcome
3 - adieu

Convoy speed - Zeus

*/
