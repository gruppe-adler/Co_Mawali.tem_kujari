params ["_vehicle"];

_vehicle addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

	if (damage _unit > 0.88) exitWith { 0 };

	_damage
}];