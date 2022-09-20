
params ["_convoyGroup",["_convoySpeed",50],["_convoySeparation",50],["_pushThrough", true]];

// init global vars
missionNamespace setVariable ["GRAD_convoySpeed", _convoySpeed, true];
missionNamespace setVariable ["GRAD_convoySeparation", _convoySeparation, true];

if (_pushThrough) then {
    _convoyGroup enableAttack !(_pushThrough);
    {(vehicle _x) setUnloadInCombat [false, false];} forEach (units _convoyGroup);
};
_convoyGroup setFormation "COLUMN";
{
    (vehicle _x) limitSpeed _convoySpeed*1.15;
    (vehicle _x) setConvoySeparation _convoySeparation;
} forEach (units _convoyGroup);
(vehicle leader _convoyGroup) limitSpeed _convoySpeed;

while {sleep 5; !isNull _convoyGroup} do {

    // enable speed adjustments on the fly
    private _convoySpeed = missionNamespace getVariable ["GRAD_convoySpeed", 0];
    private _convoySeparation = missionNamespace getVariable ["GRAD_convoySeparation", 50];
    {
        private _vehicle = vehicle _x;
        // give vehicles behind time to catch up, setting to lower speeds make vehicles stall and drive at less speed
        if (_convoySpeed < 30) then {
            _vehicle limitSpeed 30;
        } else {
            _vehicle limitSpeed _convoySpeed*1.15;
        };
        _vehicle setConvoySeparation _convoySeparation;
    } forEach (units _convoyGroup);
    (vehicle leader _convoyGroup) limitSpeed _convoySpeed;

    if (_convoySpeed == 0) then {
        (vehicle leader _convoyGroup) limitSpeed 0.001;
        {
            private _vehicle = vehicle _x;
            if (speed _vehicle < 0.5) then {
                (_vehicle) engineOn false;
            };
        } forEach (units _convoyGroup);
    };

    {
        private _vehicle = vehicle _x;
        if ((speed _vehicle < 5) && (_pushThrough || (behaviour _x != "COMBAT"))) then {
            (_vehicle) doFollow (leader _convoyGroup);
        };  
    } forEach (units _convoyGroup)-(crew (vehicle (leader _convoyGroup)))-allPlayers;
    {
        private _vehicle = vehicle _x;
        (_vehicle) setConvoySeparation _convoySeparation;
    } forEach (units _convoyGroup);
};
