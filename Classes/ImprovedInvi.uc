class ImprovedInvi extends UT_Invisibility config(ImprovedInvi);

var config int InvisibilityDuration;
var config bool bAllowDrop;
var config bool bEnabled;
var config bool bShowCountdownMessage;
var int lastSecondDisplayed;
var int currentSecond;

event PostBeginPlay()
{
    if (!bEnabled)
    {
        Destroy();
        return;
    }
    Super.PostBeginPlay();
    Charge=InvisibilityDuration;
}

function DropInventory()
{
    local float Speed;
    local vector X, Y, Z;

    if (!bAllowDrop) // Check if dropping is allowed
    {
        return;
    }

    if (Charge > 0)
    {
        Speed = VSize(Owner.Velocity);
        if (Speed != 0)
            Velocity = Normal(Owner.Velocity/Speed + 0.5 * VRand()) * (Speed + 280);
        else
            Velocity = vect(0,0,0);

        GetAxes(Owner.Rotation, X, Y, Z);
        DropFrom(Owner.Location + 0.8 * Owner.CollisionRadius * X + - 0.5 * Owner.CollisionRadius * Y);
    }
}


function DropFrom(vector StartLocation)
{
    local int i;
    local ImprovedInvi copy;

    if (!SetLocation(StartLocation))
        return;

    copy = Spawn(class'ImprovedInvi',,, StartLocation);
    copy.PickupViewMesh = PickupViewMesh;
    copy.PickupViewScale = PickupViewScale;
    copy.PlayerViewMesh = PlayerViewMesh;
    copy.PlayerViewScale = PlayerViewScale;
    copy.ThirdPersonMesh = ThirdPersonMesh;
    copy.ThirdPersonScale = ThirdPersonScale;
    copy.Texture = Texture;
    copy.Skin = Skin;
    copy.DrawScale = DrawScale;
    copy.bMeshCurvy = bMeshCurvy;
    copy.bMeshEnviroMap = bMeshEnviroMap;
    for (i = 0; i < 8; i++)
        copy.MultiSkins[i] = MultiSkins[i];

    copy.bSimFall = true;
    copy.bHeldItem = true;
    copy.RespawnTime = 0.0;
    copy.Charge = Charge;
    copy.SetPhysics(PHYS_Falling);
    copy.Velocity = Velocity;
    copy.BecomePickup();
    copy.GoToState('PickUp', 'Dropped');
}

state Activated
{
    function endstate()
    {
        local Inventory S;

        bActive = false;        
        PlaySound(DeActivateSound);

        Owner.SetDefaultDisplayProperties();
        Pawn(Owner).Visibility = Pawn(Owner).default.Visibility;
        S = Pawn(Owner).FindInventoryType(class'UT_ShieldBelt');
        if ( (S != None) && (UT_Shieldbelt(S).MyEffect != None) )
            UT_Shieldbelt(S).MyEffect.bHidden = false;
    }

    function BeginState()
    {
    local Inventory S;

    bActive = true;
    PlaySound(ActivateSound,,4.0);

    Owner.SetDisplayProperties(ERenderStyle.STY_Translucent, 
                               FireTexture'unrealshare.Belt_fx.Invis',
                               false,
                               true);
        SetTimer(Level.TimeDilation, True);
        S = Pawn(Owner).FindInventoryType(class'UT_ShieldBelt');
        if ( (S != None) && (UT_Shieldbelt(S).MyEffect != None) )
        UT_Shieldbelt(S).MyEffect.bHidden = true;
    }


    function Timer()
    {
        Charge -= 1;
 
        currentSecond = Charge;

        if (currentSecond <= 5 && currentSecond > 0 && currentSecond != lastSecondDisplayed)
    {
        lastSecondDisplayed = currentSecond;
        if (Pawn(Owner) != None)
        {
            if (bShowCountdownMessage)
            {
                Pawn(Owner).ClientMessage("Your Invisibility will expire in " $ currentSecond $ " seconds.");
            }
            
            Pawn(Owner).PlaySound(Sound'UnrealI.Generic.Teleport2',,1.0);
        }
            }
            else if (currentSecond == 0)
            {
                if (Pawn(Owner) != None)
                {
                    Pawn(Owner).PlaySound(Sound'LadderSounds.LadderSounds.lcursorMove',,16.0);
                }
            }

        if (Charge <= 0)
        {
            UsedUp();
        }
    }

}


auto state Pickup
{
    simulated function Landed(Vector HitNormal)
    {
    SetTimer(Level.TimeDilation, True);
    }

   function Timer()
    {
    Charge -= 1;

    if (Charge <= 0)
        Destroy();
    }

}

defaultproperties
{
    bEnabled=True
    InvisibilityDuration=27 // Set the default invisibility duration
    bShowCountdownMessage=True
    bAllowDrop=False
}