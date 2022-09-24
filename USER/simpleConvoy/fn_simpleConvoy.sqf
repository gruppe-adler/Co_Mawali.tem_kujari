
params ["_convoyGroup",["_convoySpeed",50],["_convoySeparation",50],["_pushThrough", true]];

if (!isServer) exitWith {};

// init global vars
missionNamespace setVariable ["Mawali_convoySpeed", _convoySpeed, true];
missionNamespace setVariable ["Mawali_convoySeparation", _convoySeparation, true];
missionNamespace setVariable ["Mawali_convoyGroup", _convoyGroup, true];

if (_pushThrough) then {
    _convoyGroup enableAttack !(_pushThrough);
    {(vehicle _x) setUnloadInCombat [false, false];} forEach (units _convoyGroup);
};
_convoyGroup setFormation "COLUMN";
_convoyGroup setCombatBehaviour "CARELESS";

{
    (vehicle _x) forceSpeed _convoySpeed*1.15;
    (vehicle _x) setConvoySeparation _convoySeparation;
    _x disableAI "FSM";
    _x disableAI "AUTOCOMBAT";
    _x setVariable ["lambs_danger_disableAI", true, true];    
    _x forceFollowRoad true;
} forEach (units _convoyGroup);
(vehicle leader _convoyGroup) forceSpeed _convoySpeed;
(vehicle leader _convoyGroup) doFollow (leader _convoyGroup);

[{
    params ["_args", "_handle"];
    
    private _convoyGroup = missionNamespace getVariable ["Mawali_convoyGroup", grpNull];
    if (isNull _convoyGroup) exitWith {}; // skip but be prepared

    // enable speed adjustments on the fly
    private _convoySpeed = missionNamespace getVariable ["Mawali_convoySpeed", 0];
    {
        private _vehicle = vehicle _x;
        private _convoySeparation = ((speed _x)/2) max 2; // dont get closer than 2m even when super slow, can be set individually per veh
        // give vehicles behind time to catch up, setting to lower speeds make vehicles stall and drive at less speed
        if (_convoySpeed < 30) then {
            _vehicle forceSpeed 30;
        } else {
            _vehicle forceSpeed _convoySpeed*1.15;
        };
        _vehicle setConvoySeparation _convoySeparation;
    } forEach (units _convoyGroup);
    (vehicle leader _convoyGroup) forceSpeed _convoySpeed;

    if (_convoySpeed == 0) then {
        (vehicle leader _convoyGroup) forceSpeed 0.001;
        {
            private _vehicle = vehicle _x;
            if (speed _vehicle < 0.5 && _vehicle distance (leader _convoyGroup < 1000)) then {
                (_vehicle) engineOn false;
                doStop _vehicle;
            };
        } forEach (units _convoyGroup);
    } else {
        {
            private _vehicle = vehicle _x;
            if (speed _vehicle < 5) then {
                _x doFollow (leader _convoyGroup);
                // systemChat ("force follow leader " + name _vehicle);
            };  
        } forEach (units _convoyGroup)-(crew (vehicle (leader _convoyGroup)))-allPlayers;
    };

    // systemChat "konvoiloop";

}, 3, []] call CBA_fnc_addPerFrameHandler;
