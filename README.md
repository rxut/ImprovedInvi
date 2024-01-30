ImprovedInvi is an Unreal Tournament 1999 mutator that adds additional features to the Invisibility item.

Features:
1) Customize the duration of Invisibility
2) Add a timer and audio cue for when Invisibility is about to expire, similar to what Damage Amplifier has
3) Has the option to enable Drop Invisibility on death and allow other players to pick it up

Server-side installation:
- Loaded the ImprovedInvi package
- Add ImprovedInvi.ImprovedInviMutator to your mutator list
- Configure the ImprovedInvi.ini file with the settings you prefer

Default settings for ImprovedInvi.ini:

```
[ImprovedInvi.ImprovedInvi]
bEnabled=True
InvisibilityDuration=27
bAllowDrop=True
```

A Drop Invi part of this mutator contains code from the North American UTPure branch.

Special thanks to Deoad and uZi for reviewing the code and giving optimization tips.
