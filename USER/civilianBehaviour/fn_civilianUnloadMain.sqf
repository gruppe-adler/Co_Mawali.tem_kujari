params ["_convoyGroup", "_radius"];

mawali_fnc_getValidHousePositions = {
	params ["_vehicle", ["_radius", 100]];

	private _randomBuildings = nearestObjects [_vehicle, ["House"], _radius];
	private _buildingsWithPos = [];

	{
		if (count ([_x] call BIS_fnc_buildingPositions) > 0) then {
			_buildingsWithPos pushBackUnique _x;
		};
	} forEach _randomBuildings;

	_buildingsWithPos
};

mawali_fnc_civilianPickHousePosition = {
	params ["_validHouses"];

	private _positionInBuildings = ([selectRandom _validHouses] call BIS_fnc_buildingPositions);

	(_positionInBuildings#0)
};

mawali_fnc_getSuffix = {
	params ["_number"];

	private _zero = if (_number < 10) then {
		"0"
	} else {
		""
	};
	private _return = _zero + str _number;

	_return
};

mawali_fnc_getSound = {
	params ["_unit", "_type"];

	private _prefix = _unit getVariable ["Mawali_speaker", "akin"];
	private _suffix = "01";
	private _return = "";

	switch (_type) do {
		case "rice" : {
			_suffix = [(ceil (random 14))] call mawali_fnc_getSuffix;
		};
		case "adieu" : {
			_suffix = [(ceil (random 14))] call mawali_fnc_getSuffix;
		};
		case "water" : {
			_suffix = [(ceil (random 15))] call mawali_fnc_getSuffix;
		};
		case "suaheli" : {
			_suffix = [(ceil (random 15))] call mawali_fnc_getSuffix;
		};
		case "welcome" : {
			_suffix = [(ceil (random 15))] call mawali_fnc_getSuffix;
		};
		case "fun" : {
			_suffix = [(ceil (random 15))] call mawali_fnc_getSuffix;
		};
		case "grunt" : {
			_suffix = [(ceil (random 5))] call mawali_fnc_getSuffix;
		};
		default {};
	};

	_return = _prefix + "_" + _type + "_" + _suffix;

	_return
};

mawali_fnc_saySound = {
	params ["_unit", "_sound"];

	[_unit, _sound] remoteExec ["say3d"];
	[_unit, true] remoteExec ["setRandomLip"];
	_unit setVariable ["Mawali_laberCooldown", CBA_missionTime];

	[{
		[_this, false] remoteExec ["setRandomLip"];
	}, _unit, 1.5] call CBA_fnc_waitAndExecute;
};

mawali_fnc_moveToVehicle = {
	params ["_unit", "_vehicle"];

	private _boundingBox = 0 boundingBoxReal _vehicle;
	private _p1 = _boundingBox select 0;
	private _p2 = _boundingBox select 1;
	private _length = abs ((_p2 select 1) - (_p1 select 1));
	private _vehicleRear = _vehicle getRelPos [_length/2 - (random 2), 170 + random 20];

	    _unit limitSpeed 12; // dont sprint

	_unit doMove _vehicleRear;
	diag_log format ["unit moves to back of vehicle: %1", _vehicleRear];
	waitUntil {
		moveToCompleted _unit || moveToFailed _unit
	};

	if (moveToFailed _unit) exitWith {
		_unit doMove (_unit getVariable ["Mawali_homePos", [0, 0, 0]]);
		waitUntil {
			sleep 1;
			moveToCompleted _unit || moveToFailed _unit
		};
		deleteVehicle _unit;
	};

	switch ((_unit getVariable ["Mawali_interactionType", "none"])) do {
		case "fuel" : {
			private _canisters = attachedObjects _unit;

			private _sound = [_unit, "water"] call mawali_fnc_getSound;
			[_unit, _sound] call mawali_fnc_saySound;
			[_unit, "ace_field_rations_drinkFromSourceSquatLow", 1] call ace_common_fnc_doAnimation;
			sleep 8;

			{
				if (typeOf _x == "Land_BarrelEmpty_F") then {
					private _replacement = createSimpleObject ["Land_BarrelWater_F", [0, 0, 0]];
					_replacement attachTo [_unit, [0, -.4, 0.4], "pelvis", true];
					deleteVehicle _x;

					[_unit, _replacement] call grad_civilianBehaviour_fnc_cleanAttachment;
				};
			} forEach _canisters;

			{
				if (typeOf _x == "Land_BarrelEmpty_grey_F") then {
					private _replacement = createSimpleObject ["Land_BarrelWater_grey_F", [0, 0, 0]];
					_replacement attachTo [_unit, [0, -.4, 0.4], "pelvis", true];
					deleteVehicle _x;

					[_unit, _replacement] call grad_civilianBehaviour_fnc_cleanAttachment;
				};
			} forEach _canisters;

			{
				if (typeOf _x == "Land_Barrel_empty") then {
					private _replacement = createSimpleObject ["Land_Barrel_water", [0, 0, 0]];
					_replacement attachTo [_unit, [0, -.4, 0.4], "pelvis", true];
					deleteVehicle _x;

					[_unit, _replacement] call grad_civilianBehaviour_fnc_cleanAttachment;
				};
			} forEach _canisters;

			private _sound = [_unit, "water"] call mawali_fnc_getSound;
			[_unit, _sound] call mawali_fnc_saySound;
			            _unit limitSpeed 7; // dont run
			_unit doMove (_unit getVariable ["Mawali_homePos", [0, 0, 0]]);
			waitUntil {
				sleep 1;
				moveToCompleted _unit || moveToFailed _unit
			};
			{
				deleteVehicle _x
			} forEach _canisters;
			deleteVehicle _unit;
		};
		case "rice" : {
			private _riceSackDestroyed = createSimpleObject ["Land_FoodSack_01_dmg_brown_idap_F", [0, 0, 0], false];
			_riceSackDestroyed setDir (random 360);
			_riceSackDestroyed setPos (getPos _unit);
			playSound3D ["a3\animals_f_beta\sheep\data\sound\sheep_falldown1.wss", _unit];

			_unit setUnitPos "MIDDLE";

			_unit doMove (_unit getVariable ["Mawali_homePos", [0, 0, 0]]);
			private _sound = [_unit, "rice"] call fnc_getSound;
			[_unit, _sound] call mawali_fnc_saySound;
			            _unit limitSpeed 7; // dont run
			waitUntil {
				sleep 1;
				moveToCompleted _unit || moveToFailed _unit
			};
			deleteVehicle _unit;
		};
		default {};
	};
};

mawali_fnc_prepareInteractionType = {
	params ["_unit", "_vehicle"];

	if ([_vehicle] call ace_refuel_fnc_getFuel > 50) then {
		_unit setVariable ["Mawali_interactionType", "fuel"];

		private _items = [
			["rhsusf_props_ScepterMWC_D", [0, 0, -.2], ["righthand", "lefthand"]],
			["rhsusf_props_ScepterMWC_OD", [0, 0, -.2], ["righthand", "lefthand"]],
			["Land_CanisterPlastic_F", [0, 0, -.3], ["righthand", "lefthand"]],
			["Land_BarrelEmpty_F", [0, -.4, 0.4], ["pelvis"]],
			["Land_BarrelEmpty_grey_F", [0, -.4, 0.4], ["pelvis"]],
			["gm_barrel", [0, -.4, 0.4], ["pelvis"]],
			["gm_barrel_rusty", [0, -.4, 0.4], ["pelvis"]],
			["Land_Barrel_empty", [0, -.4, 0.4], ["pelvis"]]
		];

		private _item1 = selectRandom _items;
		_item1 params ["_classname", "_offset", "_selection"];

		if (count _selection > 1) then {
			private _canisterR = createSimpleObject [_item1#0, [0, 0, 0]];
			_canisterR attachTo [_unit, _item1#1, "righthand", true];

			[_unit, _canisterR] call grad_civilianBehaviour_fnc_cleanAttachment;

			private _item2 = selectRandom _items;
			_item2 params ["_classname", "_offset", "_selection"];
			if (count _selection > 1) then {
				private _canisterL = createSimpleObject [_item2#0, [0, 0, 0]];
				_canisterL attachTo [_unit, _item2#1, "lefthand", true];

				[_unit, _canisterL] call grad_civilianBehaviour_fnc_cleanAttachment;
			};
		} else {
			private _canisterSingle = createSimpleObject [_classname, [0, 0, 0]];
			_canisterSingle attachTo [_unit, _offset, _selection#0, true];
		};
	};

	if (typeOf _vehicle == "UK3CB_UN_B_Kamaz_Closed") then {
		private _items = [
			["Land_FoodSacks_01_small_brown_idap_F", [0, 0, 0], ["head"]],
			["Land_FoodSack_01_full_brown_idap_F", [-.2, 0, 0], ["righthand", "lefthand"]],
			["Land_FoodSack_01_full_brown_F", [-.2, 0, 0], ["righthand", "lefthand"]]
		];

		private _item1 = selectRandom _items;
		_item1 params ["_classname", "_offset", "_selection"];

		if (count _selection > 1) then {
			private _canisterR = createSimpleObject [_item1#0, [0, 0, 0]];
			_canisterR attachTo [_unit, _item1#1, "righthand", true];

			[_unit, _canisterR] call grad_civilianBehaviour_fnc_cleanAttachment;

			if (random 2 > 1) then {
				private _item2 = selectRandom _items;
				private _canisterL = createSimpleObject [_item2#0, [0, 0, 0]];
				_canisterL attachTo [_unit, _item2#1, "lefthand", true];

				[_unit, _canisterL] call grad_civilianBehaviour_fnc_cleanAttachment;
			};
		} else {
			private _canisterSingle = createSimpleObject [_classname, [0, 0, 0]];
			_canisterSingle attachTo [_unit, _offset, _selection#0, true];
		};

		_unit setVariable ["Mawali_interactionType", "rice"];
	};
};

mawali_fnc_civilianUnloadRice = {
	params ["_position"];
};

mawali_fnc_laberShitLoop = {
	params ["_unit"];

	if (isNull _unit) exitWith {};

	if ((_unit getVariable ["Mawali_laberCooldown", CBA_missionTime]) < (CBA_missionTime - 7)) exitWith {};

	private _dice = random 10;
	private _type = "suaheli";

	if (_dice > 5) then {
		if (missionNameSpace getVariable ["Mawali_convoySpeed", 0.01] > 0.5) then {
			_type = "welcome";
		} else {
			_type = "adieu";
		};
	};
	if (_dice > 7) then {
		if (missionNameSpace getVariable ["Mawali_convoySpeed", 0.01] > 0.5) then {
			_type = "grunt";
		} else {
			_type = "adieu";
		};
	};
	if (_dice > 9) then {
		if (missionNameSpace getVariable ["Mawali_convoySpeed", 0.01] > 0.5) then {
			_type = "fun";
		} else {
			_type = "adieu";
		};
	};
	private _string = [_unit, _type] call mawali_fnc_getSound;

	    // systemChat (name _unit + ": " + _string);
	[_unit, _string] call mawali_fnc_saySound;

	[{
		[_this] call mawali_fnc_laberShitLoop;
	}, _unit, (random 10 max 3)] call CBA_fnc_waitAndExecute;
};

[_convoyGroup, _radius] spawn {
	params ["_convoyGroup", "_radius"];
	{
		private _vehicle = vehicle _x;
		private _validHouses = [_vehicle, _radius] call mawali_fnc_getValidHousePositions;
		if (count _validHouses < 1) then {
			// systemChat ("no houses for vehicle " + str _foreachindex);
		} else {
			// exclude vehicles way off
			if (speed _vehicle == 0 && _vehicle distance (leader group _x) < 500 && typeof _vehicle != "UK3CB_UN_B_Landcruiser") then {
				for "_i" from 1 to (ceil ((missionNameSpace getVariable ["mawali_convoyUnloadCivCount", 20]) max 10)) do {
					systemChat ("innerloop " + str _i);
					private _spawnPosition = [_validHouses] call mawali_fnc_civilianPickHousePosition;
					if (count _spawnPosition < 1) exitWith {
						systemChat "no positions";
					};

					private _civilian = (createGroup civilian) createUnit ["UK3CB_ADC_C_CIV_ISL", _spawnPosition, [], 0, "CAN_COLLIDE"];
					private _face = selectRandom ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03", "AfricanHead_01_sick", "AfricanHead_02_sick", "AfricanHead_03_sick"];
					[_civilian, _face] remoteExec ["setFace", 0, _civilian];
					_civilian setVariable ["lambs_danger_disableAI", true];
					_civilian disableAI "AUTOCOMBAT";
					_civilian disableAI "FSM";
					_civilian setBehaviour "CARELESS";
					_civilian setVariable ["Mawali_speaker", selectRandom ["akin", "akin2"], true];
					_civilian setVariable ["Mawali_homePos", getPosATL _civilian];
					[_civilian, _vehicle] call mawali_fnc_prepareInteractionType;
					if ((_civilian getVariable ["Mawali_interactionType", "none"]) == "none") exitWith {
						deleteVehicle _civilian
					};
					[_civilian, _vehicle] spawn mawali_fnc_moveToVehicle;
					[_civilian] call mawali_fnc_laberShitLoop;
					sleep (random 1);
				};
				            sleep (missionNameSpace getVariable ["Mawali_convoyDurationUnload", 60]); // sleep only when necessary
			};
		};
		    // systemChat ("outerloop " + str _foreachindex);^
		["CONVOY UNLOAD DONE", [1, 0, 0, 1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];
	} forEach (units _convoyGroup);
};