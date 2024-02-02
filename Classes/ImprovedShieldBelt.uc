class ImprovedShieldBelt extends UT_ShieldBelt;

function bool HandlePickupQuery( inventory Item )
{
    local Inventory I;
	local Inventory S;
        
    if (item.class == class) 
    {
		S = Pawn(Owner).FindInventoryType(class'ImprovedShieldBelt');
		ImprovedShieldBelt(S).MyEffect.Destroy(); // remove previous shield belt effect
		
        // remove other armors
        for ( I=Owner.Inventory; I!=None; I=I.Inventory )
            if ( I.bIsAnArmor && (I != self) )
                {
					I.Destroy();
				}
				
		MyEffect = Spawn(class'UT_ShieldBeltEffect', Owner,,Owner.Location, Owner.Rotation); 
		MyEffect.Mesh = Owner.Mesh;
		MyEffect.DrawScale = Owner.Drawscale;
		SetEffectTexture();
    }

    return Super.HandlePickupQuery(Item);
}

function PickupFunction(Pawn Other)
{
	local Inventory I;
 
	MyEffect = Spawn(class'UT_ShieldBeltEffect', Other,,Other.Location, Other.Rotation); 
	MyEffect.Mesh = Owner.Mesh;
	MyEffect.DrawScale = Owner.Drawscale;
 
	if ( Level.Game.bTeamGame && (Other.PlayerReplicationInfo != None) )
		TeamNum = Other.PlayerReplicationInfo.Team;
	else
		TeamNum = 3;
	SetEffectTexture();
 
	// remove other armors
	for ( I=Owner.Inventory; I!=None; I=I.Inventory )
		if ( I.bIsAnArmor && (I != self) )
			I.Destroy();
}