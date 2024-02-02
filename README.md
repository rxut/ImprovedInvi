ImprovedInvi is an Unreal Tournament 1999 mutator that adds additional features to the Invisibility item.

**Features:**
1) Customize the duration of Invisibility
2) Adds an audio cue for when Invisibility is about to expire, similar to what Damage Amplifier has
3) Has the option to enable a Countdown message for the last 5 seconds when Invisibility is about to expire 
4) Has an option to enable Drop Invisibility on death and allow other players to pick it up

**Bug Fixes:**

ImprovedInvi fixes the base game bug where Invisibility doesn't interact correctly with Shield Belt in online play.

ImprovedInvi adds this logic:
- If a player with a Shield Belt takes Invisibility, he will become invisible.
- If a player with Invisibility takes a Shield Belt, the Shield Belt around him will be visible.

**Server-side installation:**
- Loaded the ImprovedInvi package
- Add ImprovedInvi.ImprovedInviMutator to your mutator list
- Configure the ImprovedInvi.ini file with the settings you prefer

**Default settings for ImprovedInvi.ini:**
```
[ImprovedInvi.ImprovedInvi]
bEnabled=True
InvisibilityDuration=27
bShowCountdownMessage=True
bAllowDrop=False
```

A Drop Invi part of this mutator contains code from the North American UTPure branch.

Special Thanks to Deoad, uZi, Buggie, Silver, and Lockpick for helping with the code and providing feedback.
