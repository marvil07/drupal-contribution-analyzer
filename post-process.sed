# At post-process we need to take care of non-standard messages,
# replacing:

# - simple author replace by errors:
s/Alexander.  You can use this script   to check your code against the Drupal coding style/Alexander/g
s/Jeremy to fix a module loading bug/Jeremy/g
s/with help from Nick/Nick/g
s/Ax to fixe/Ax/g
s/Usability Poobah Chris/factoryjoe/g
s/with help from Nick/Nick/g
s/Jose A Reyero with further cleanup by myself/Jose Reyero/g
s/kkaefer with fixes from myself/kkaefer/g
s/with help from Kristi Wachter/Kristi Wachter/g
s/in patch form by Rob Loach/Rob Loach/g

#- simple author replace by identification basing on usernames at d.o:
s/\"[Dd][Rr][Ii][Ee][Ss]"/\"Dries\"/g
s/\"[Uu][Nn][Cc][Oo][Nn][Ee][Dd]\"/\"Steven\"/g
s/\"[Mm]oshe [Ww]eitzman\"/\"moshe weitzman\"/g
s/\"[Mm]oshe\"/\"moshe weitzman\"/g
s/\"[Dd]amien\"/\"Damien Tournoud\"/g
s/\"[Dd][Aa][Mm][Zz]\"/\"Damien Tournoud\"/g
s/\"Damein Tournoud\"/\"Damien Tournoud\"/g
s/\"Damien Damien Tournoud\"/\"Damien Tournoud\"/g
s/\"[Mm]orbus\"/\"Morbus Iff\"/g
s/\"[Gg]abo[Rr]*\"/\"Gábor Hojtsy\"/g
s/\"[Gg]abo[Rr][ ]*[Hh]ojtsy\"/\"Gábor Hojtsy\"/g
s/\"[Gg]oba"/\"Gábor Hojtsy\"/g
s/\"[Rr]obert[ ][Dd]ouglas[s]*\"/\"robertDouglass\"/g
s/\"[Ee]aton\"/\"eaton\"/g
s/\"add1sum\"/\"add1sun\"/g
s/\"ajk\"/\"AjK\"/g
s/\"Andypost\"/\"andypost\"/g
s/\"andpost\"/\"andypost\"/g
s/\"Aron Noval\"/\"Aron Novak\"/g
s/\"birdmax35\"/\"birdmanx35\"/g
s/\"bohjan\"/\"Bojhan\"/g
s/\"Bohjan\"/\"Bojhan\"/g
s/\"Boombatower\"/\"boombatower\"/g
s/\"boombatwoer\"/\"boombatower\"/g
s/\"bopombatower\"/\"boombatower\"/g
s/\"brightLoudNoise\"/\"BrightLoudNoise\"/g
s/\"carols8f\"/\"carlos8f\"/g
s/\"crell\"/\"Crell\"/g
s/\"cwgordon07\"/\"cwgordon7\"/g
s/\"dave reid\"/\"Dave Reid\"/g
s/\"David Rothenstein\"/\"David_Rothstein\"/g
s/\"David Rothstein\"/\"David_Rothstein\"/g
s/\"EclipseGC\"/\"EclipseGc\"/g
s/\"eigenator\"/\"eigentor\"/g
s/\"florbuit\"/\"flobruit\"/g
s/\"frando\"/\"Frando\"/g
s/\"freso\"/\"Freso\"/g
s/\"Garret Albright\"/\"Garrett Albright\"/g
s/\"Grugnoh2\"/\"Grugnog2\"/g
s/\"gurpartap singh\"/\"Gurpartap Singh\"/g
s/\"JacobSignh\"/\"JacobSingh\"/g
s/\"Jacob Singh\"/\"JacobSingh\"/g
s/\"jamesAn\"/\"JamesAn\"/g
s/\"JBrauer\"/\"jbrauer\"/g
s/\"Jeff Burn\"/\"Jeff Burnz\"/g
s/\"Jody Lunn\"/\"Jody Lynn\"/g
s/\"[Kk]aren[Ss]\"/\"KarenS\"/g
s/\"keith.smitch\"/\"keith.smith\"/g
s/\"Keith.smith\"/\"keith.smith\"/g
s/\"lyrincz\"/\"lyricnz\"/g
s/\"markus_petruxm\"/\"markus_petrux\"/g
s/\"paul.levvik\"/\"paul.lovvik\"/g
s/\"pwoladin\"/\"pwolanin\"/g
s/\"RobLoach\"/\"Rob Loach\"/g
s/\"senpai\"/\"Senpai\"/g
s/\"Sun\"/\"sun\"/g
s/\"UltimateBoy\"/\"ultimateBoy\"/g
s/\"vladimir\"/\"Vladimir\"/g
s/\"VeryMisunderstood\"/\"VM\"/g
s/\"xano\"/\"Xano\"/g

#TODO split one line in two:
#"Mathias with help from Steven": Mathias, Steven
#"keith.smith based on initial suggestions from O Govinda": keith.smith, O Govinda
#"cwgordon7 andSenpai"
#"drewish ad flobruit"
#- join same names with different capitalization
