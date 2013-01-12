private["_hasKnife","_qty","_item","_text","_string","_type","_loop","_meat","_timer"];
_item = _this select 3;
_hasKnife = 	"ItemKnife" in items player;
_hasKnifeBlunt = 	"ItemKnifeBlunt" in items player;
_type = typeOf _item;
_hasHarvested = _item getVariable["meatHarvested",false];
_config = 		configFile >> "CfgSurvival" >> "Meat" >> _type;

player removeAction s_player_butcher;
s_player_butcher = -1;
_hasChance = 9 > random 100;

if (_hasKnife) then {
	if (_hasChance) then {
		player removeWeapon "ItemKnife";
		player addWeapon "ItemKnifeBlunt";
		cutText [localize "STR_EQUIP_CODE_DESC_4", "PLAIN DOWN"];
	};
};

if ((_hasKnife or _hasKnifeBlunt) and !_hasHarvested) then {
	//Get Animal Type
	_loop = true;	
	_isListed =		isClass (_config);
	_text = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
	
	player playActionNow "Medic";
	[player,"gut",0,false] call dayz_zombieSpeak;
	_item setVariable["meatHarvested",true,true];
	_item setVariable ["timerawmeatHarvested",time,false];
	
	_qty = 2;	
	if (_isListed) then {
		_qty =	getNumber (_config >> "yield");
	};
	
	if (_hasKnifeBlunt) then { _qty = round(_qty / 2); };
	
	_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
	
	_array = [_item,_qty];
	
	if (local _item) then {
		_array spawn local_gutObject;
	} else {
		dayzGutBody = _array;
		publicVariable "dayzGutBody";
	};
	
	sleep 6;
	_string = format[localize "str_success_gutted_animal",_text,_qty];
	cutText [_string, "PLAIN DOWN"];
};