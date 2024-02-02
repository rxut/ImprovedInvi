class ImprovedInviMutator extends Mutator config(ImprovedInvi);

var string GroupName;
var string FriendlyName;
var string Description;
var config bool bEnabled;

function PostBeginPlay()
{
    local UT_Invisibility UT_InvisibilityItem;
    local ImprovedInvi NewUT_Invisibility;
    
    local UT_ShieldBelt shieldBelt;
    local ImprovedShieldBelt newShieldBelt;

    if (bEnabled)
    {   
        foreach AllActors(class'UT_ShieldBelt', shieldBelt)
        {
            if (!shieldBelt.IsA('ImprovedShieldBelt'))
            {
                newShieldBelt = Spawn(class'ImprovedShieldBelt', None,, shieldBelt.Location, shieldBelt.Rotation);
                newShieldBelt.SetBase(shieldBelt.Base);
                shieldBelt.Destroy();
            }
        }

        foreach AllActors(class'UT_Invisibility', UT_InvisibilityItem)
        {
            if (!UT_InvisibilityItem.IsA('ImprovedInvi'))
            {
                NewUT_Invisibility = Spawn(class'ImprovedInvi', None,, UT_InvisibilityItem.Location, UT_InvisibilityItem.Rotation);
                NewUT_Invisibility.SetBase(UT_InvisibilityItem.Base);
                UT_InvisibilityItem.Destroy();
            }
        }
    }

    Super.PostBeginPlay();
}

defaultproperties
{
    GroupName="ImprovedInvi"
    FriendlyName="Improved Invi Mutator"
    Description="Replaces UInvisibility with ImprovedInvi"
    bEnabled=true
}