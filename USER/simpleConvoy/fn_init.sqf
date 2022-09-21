if (!isServer) exitWith {};

["UK3CB_UN_B_Kamaz_Closed", "init", {
	 params ["_vehicle"];

	 [_vehicle] call grad_simpleconvoy_fnc_attachCable;

}, true, [], true] call CBA_fnc_addClassEventHandler;


missionNamespace setVariable ["Mawali_convoyState", 0];

["Mawali_convoyState", {
		params ["_convoyGoBool", "_zeus"]

		if (_zeus) then {
			missionNamespace setVariable ["Mawali_convoyStateZeus", _convoyGoBool];
		} else {
			missionNamespace setVariable ["Mawali_convoyStateEscort", _convoyGoBool];
		};

		private _convoyStateZeus = missionNamespace getVariable ["Mawali_convoyStateZeus", false];
		private _convoyStateEscort = missionNamespace getVariable ["Mawali_convoyStateEscort", false];

		if (_convoyStateZeus && _convoyStateEscort) then {
				private _speed = missionNamespace getVariable ["Mawali_convoySpeedCache", 0.01];
				[_speed] call CBA_fnc_serverEvent;
		};

		if (!_convoyStateZeus || !_convoyStateEscort) then {
				[0.01] call CBA_fnc_serverEvent;
		};

}] call CBA_fnc_addEventhandler;

["Mawali_convoySpeed", {
		params ["_speed"]

		if (_speed < 0.5) exitWith {
				// convoy says "stopping now"
					private _previousSpeed = missionNamespace getVariable ["Mawali_convoySpeed", 0.01];
					missionNamespace setVariable ["Mawali_convoySpeedCache", _previousSpeed];
					missionNamespace setVariable ["Mawali_convoySpeed", 0.01];
		};

		private _state = missionNamespace getVariable ["Mawali_convoyState", 0];
		if (_state == 2) then {
				// convoy says "running now"
				missionNamespace setVariable ["Mawali_convoySpeedCache", _speed];
				missionNamespace setVariable ["Mawali_convoySpeed", _speed];
		};

}] call CBA_fnc_addEventhandler;

/*

1 - Convoy stops - red escort, red zeus
2 - Convoy stops - green escort, red zeus
3 - Convoy runs - green escort, green zeus

1,2 - welcome
3 - adieu

Convoy speed - Zeus

*/
