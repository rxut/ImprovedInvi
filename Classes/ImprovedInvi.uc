class ImprovedInvi extends UT_Invisibility config(ImprovedInvi);

var config int InvisibilityDuration;
var config bool bAllowDrop;
var config bool bEnabled;
var config bool bShowCountdownMessage;
var int lastSecondDisplayed;
var int currentSecond;
var int TeamNum;

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
    function AddShieldBeltEffect()
    {
        local Inventory S;

        S = Pawn(Owner).FindInventoryType(class'ImprovedShieldBelt');

        if ( (S != None) && ImprovedShieldBelt(S).MyEffect.bHidden == true)
        {   
            ImprovedShieldBelt(S).MyEffect = Spawn(class'UT_ShieldBeltEffect', Owner,,Owner.Location, Owner.Rotation);
            ImprovedShieldBelt(S).MyEffect.Mesh = Owner.Mesh;
            ImprovedShieldBelt(S).MyEffect.DrawScale = Owner.Drawscale;
            ImprovedShieldBelt(S).SetEffectTexture();
            ImprovedShieldBelt(S).MyEffect.bHidden = False;
        }
    }

    function RemoveShieldBeltEffect()
    {
        local Inventory S;

        S = Pawn(Owner).FindInventoryType(class'ImprovedShieldBelt');

        if ( (S != None) && (ImprovedShieldBelt(S).MyEffect != None))
        {
            ImprovedShieldBelt(S).MyEffect.bHidden = true;
            ImprovedShieldBelt(S).MyEffect.Destroy();
        }
        
    }

    function endstate()
    {   
        bActive = false;
        
        PlaySound(DeActivateSound);

        Owner.SetDefaultDisplayProperties();

        Pawn(Owner).Visibility = Pawn(Owner).default.Visibility;

        AddShieldBeltEffect();
    }

    function BeginState()
    {
        RemoveShieldBeltEffect();

        bActive = true;

        PlaySound(ActivateSound,,4.0);

        Owner.SetDisplayProperties(ERenderStyle.STY_Translucent, 
                               FireTexture'unrealshare.Belt_fx.Invis',
                               false,
                               true);
        SetTimer(Level.TimeDilation, True);
    }

    function Timer()
    {
        local PlayerPawn PP;
        Charge -= 1;
        currentSecond = Charge;

        if (currentSecond <= 5 && currentSecond > 0 && currentSecond != lastSecondDisplayed)
        {
            lastSecondDisplayed = currentSecond;

            if (Pawn(Owner) != None)
            {
                PP = PlayerPawn(Owner);

                    if (bShowCountdownMessage)
                    {
                        Pawn(Owner).ClientMessage("Your Invisibility will expire in " $ currentSecond $ " seconds.");
                    }
                
                PP.ClientPlaySound(Sound'UnrealI.Generic.Teleport2',,true);
            }
        }
        else if (currentSecond == 0)
            {
                PP = PlayerPawn(Owner);

                if (Pawn(Owner) != None)
                {
                    PP.ClientPlaySound(Sound'LadderSounds.LadderSounds.lcursorMove',,true);
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