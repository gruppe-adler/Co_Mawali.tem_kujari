params ["_convoyGroup", "_radius"];


fnc_civilianPickHousePosition = {
    params ["_vehicle", "_radius"];

    private _randomBuilding = selectRandom (nearestObjects [_vehicle, ["House", "Building"], _radius]);
    private _positionInBuildings = ([_randomBuilding] call BIS_fnc_buildingPositions);

    private _positionInBuilding = if (count _positionInBuildings > 0) then { selectRandom _positionInBuildings } else { [] };

	private _isInside = lineIntersectsSurfaces [							
		_spawnPosition, 
		_spawnPosition vectorAdd [0, 0, 50], 
		_x, objNull, true, 1, "GEOM", "NONE"
	] select 0 params ["","","","_house"];

	if (!_isInside) then { _positionInBuilding = [] };

    _positionInBuilding
};

fnc_getSuffix = {
    params ["_number"];

    private _zero = if (_number < 10) then { "0" } else { "" };
    _suffix = _zero + str _number;  

    _suffix
};


fnc_getSound = {
    params ["_unit", "_type"];

    private _prefix = _unit getVariable ["Mawali_speaker", "akin"];
    private _suffix = "01";
	private _return = "";

    switch (_type) do { 
        case "rice" : {
            _return = (ceil (random 14)) call fnc_getSuffix;
        }; 
        case "adieu" : {
            _return = (ceil (random 15)) call fnc_getSuffix;
        }; 
        case "water" : {
            _return = (ceil (random 15)) call fnc_getSuffix;
        }; 
        case "suaheli" : {
            _return = (ceil (random 15)) call fnc_getSuffix;
        }; 
        case "welcome" : {
            _return = (ceil (random 15)) call fnc_getSuffix;
        }; 
        default {  /*...code...*/ }; 
    };

	_return = _prefix + _return + _suffix;

	_return
};


fnc_saySound = {
    params ["_unit", "_sound"];

    [_unit, _sound] remoteExec ["say3d"];
    [_unit, true] remoteExec ["setRandomLip"];

    [{ 
        [_this, false] remoteExec ["setRandomLip"]; 
    }, _unit, 1.5] call CBA_fnc_waitAndExecute;
};


fnc_moveToVehicle = {
    params ["_unit", "_vehicle"];

    private _boundingBox = 0 boundingBoxReal _vehicle;
    private _p1 = _boundingBox select 0;
    private _p2 = _boundingBox select 1;
    private _length = abs ((_p2 select 1) - (_p1 select 1));
    private _vehicleRear = _vehicle getRelPos [_length/2, 175 + random 10];

    _unit doMove _vehicleRear;
    waitUntil {moveToCompleted  _unit || moveToFailed _unit};

    if (moveToFailed _unit) exitWith {
        _unit doMove (_unit getVariable ["Mawali_homePos", [0,0,0]]);
        deletevehicle _unit;
    };
    
    switch ((_unit getVariable ["Mawali_interactionType", "none"])) do { 
        case "fuel" : {
            private _canisters = attachedObjects _unit;
            {detach _x} forEach _canisters;

            private _sound = ["water"] call fnc_getSound;
            [_unit, _sound] call fnc_saySound;
            [_unit, "ace_field_rations_drinkFromSourceSquatLow", 1] call ace_common_fnc_doAnimation;
            sleep 8;
            {
                _x attachTo [_unit, [0,0,-.3], (["lefthand", "righthand"] select _forEachIndex), true];
            } forEach _canisters;

            private _sound = ["water"] call fnc_getSound;
            [_unit, _sound] call fnc_saySound;
            _unit doMove (_unit getVariable ["Mawali_homePos", [0,0,0]]);
            waitUntil {sleep 1; moveToCompleted _unit};
            {deletevehicle _x} forEach _canisters;
            deletevehicle _unit;
        }; 
        case "rice" : {
            [_unit] execvm "user\scripts\civilianUnload\carryAnimation.sqf";
            _unit doMove (_unit getVariable ["Mawali_homePos", [0,0,0]]);
            private _sound = ["rice"] call fnc_getSound;
            [_unit, _sound] call fnc_saySound;
            waitUntil {sleep 1; moveToCompleted _unit};
            deletevehicle _unit;
        }; 
        default {  /*...code...*/ }; 
    };
};


fnc_prepareInteractionType = {
    params ["_unit", "_vehicle"];

    if ([_vehicle] call ace_refuel_fnc_getFuel > 50) then {
        _unit setVariable ["Mawali_interactionType", "fuel"];
        
        private _canisterL = "Land_CanisterPlastic_F" createvehicle [0,0,0]; // createSimpleObject ["Land_CanisterPlastic_F", [0,0,0]];
        _canisterL attachTo [_unit, [0,0,-.3], "lefthand", true];
        _canisterL setMass 1000;
        { _x disableCollisionWith _canisterL; } forEach allplayers; // todo broadcast
        _unit disableCollisionWith _canisterL; 

        private _canisterR = "Land_CanisterPlastic_F" createvehicle [0,0,0]; // createSimpleObject ["Land_CanisterPlastic_F", [0,0,0]];
        _canisterR setMass 10000;
        _canisterR attachTo [_unit, [0,0,-.3], "righthand", true];
        { _x disableCollisionWith _canisterR; } forEach allplayers;
        _unit disableCollisionWith _canisterR;
    };

    if (typeOf _vehicle == "UK3CB_UN_B_Kamaz_Closed") then {
        _unit setVariable ["Mawali_interactionType", "rice"];
    };
};



fnc_civilianUnloadRice = {
    params ["_position"];

};


{
    private _vehicle = vehicle _x;
    // exclude vehicles way off
    if (speed _vehicle == 0 && _vehicle distance (leader group _x) < 500) then {

        for "_i" from 1 to (random 20 max 5) do {
            private _spawnPosition = [_vehicle, _radius] call fnc_civilianPickHousePosition;
			if (count _spawnPosition < 1) exitwith {};

            private _civilian = (createGroup civilian) createUnit ["UK3CB_ADC_C_CIV_ISL", _spawnPosition, [], 0, "CAN_COLLIDE"];
            private _face = selectRandom ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03", "AfricanHead_01_sick", "AfricanHead_02_sick", "AfricanHead_03_sick"];
            [_civilian, _face] remoteExec ["setFace", 0, _civilian];
            _civilian setVariable ["lambs_danger_disableAI", true];
            _civilian disableAI "AUTOCOMBAT";
            _civilian disableAI "FSM";
            _civilian setBehaviour "CARELESS";
            _civilian setVariable ["Mawali_homePos", _spawnPosition];
            [_civilian, _vehicle] call fnc_prepareInteractionType;
            if ((_civilian getVariable ["Mawali_interactionType", "none"]) == "none") exitwith { deletevehicle _civilian };
            [_civilian, _vehicle] spawn fnc_moveToVehicle;
            sleep (random 1);
        };
    };
} forEach (units _convoyGroup);