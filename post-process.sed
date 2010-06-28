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
s/\"[Mm]orbus\"/\"Morbus Iff\"/g
s/\"[Gg]abo[Rr]*\"/\"Gábor Hojtsy\"/g
s/\"[Gg]abo[Rr][ ]*[Hh]ojtsy\"/\"Gábor Hojtsy\"/g
s/\"[Rr]obert[ ][Dd]ouglas[s]*\"/\"robertDouglass\"/g
s/\"[Ee]aton\"/\"eaton\"/g

#TODO split one line in two:
#"Mathias with help from Steven": Mathias, Steven
#"keith.smith based on initial suggestions from O Govinda": keith.smith, O Govinda
#- join same names with different capitalization
