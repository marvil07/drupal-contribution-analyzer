<?php
//$subject="#645790 by arianek, jhodgdon, and lisarex: Convert Locale module to new help standard.";
//$subject="#645790: Convert Locale module to new help standard.";
//$subject="by arianek, jhodgdon, and lisarex: Convert Locale module to new help standard.";
//$subject="- Patch #88892 by darthsteven et al: improved the PHPdoc of form_set_value().  Great work.  Much better. :)";
//$subject="#198579 by webernet and hswong3i: a huge set of coding style fixes, including:";
//$subject="#193274 by dmitrig01 and quicksketch: send submit button data with AHAH submissions";
//$subject="#601806 by sun, effulgentsia, and Damien Tournoud: drupal_render() should not set default element properties that make no sense.";
//$subject="#307477 by clemens.tolboom and boombatower: Test how XML-RPC responds to large messages.";
$subject = trim(fgets(STDIN));

// [issue category] #[issue number] by [comma-separated usernames]: [Short summary of the change].
$pattern = '/(?<authors>by [\w\d\s,.]+:)/';

preg_match($pattern, $subject, $matches);
//print_r($matches);

/**
 * TODO
 *
 * some phrases that do not parse correctly:
 * their authors
 * in the following manner
 * Alexander. You can use this script to check your code against the Drupal coding style
 * going to http
 * Jeremy to fix a mod
 * vmole at http
 * Moshe at http
 * Ax. fixed some syntax errrors
 * with help from Nick
 * improve the core doxygen PHPdoc
 * Usability Poob..?
 * moonray with help from Zen
 * after coding style fixes
 * documentation cleaned up by myself
 * Jose A Reyero with further cleanup by myself
 * kkaefer with fixes from myself
 * patch by myself
 * pathc by myself
 * *partap singh slightly modified
 * with help from Kristi Wachter
 * profix898 slightly modified
 * slightly extended
 * various people
 * several people
 * multiple contributors
 * numerous contributors
 * in patch form by Rob Loach
 * tested by Murz
 * keith.smith based on initial suggestions from O Govinda
 * testing by keith.smith
 * tested by Murz
 *
 * post-process
 * join sam names(like Damien and DamZ)
 * join same names with different capitalization
 */
if (!empty($matches['authors'])) {
    $authors_raw = substr($matches['authors'], 3, -1);
    $authors = split(',', $authors_raw);
    foreach ($authors as $author) {
        $author = trim($author);
        // try to avoid common non-standard messages
        if (($pos=strpos($author,'et al')) !== FALSE) {
            $author = trim(substr($author, 0, $pos));
            if (!empty($author)) echo $author . "\n";
        }
        elseif (($pos=strpos($author,'and ')) !== FALSE) {
            $author1 = trim(substr($author, 0, $pos));
            $author2 = trim(substr($author, $pos+4));
            if (!empty($author1)) echo $author1 . "\n";
            if (!empty($author2)) echo $author2 . "\n";
        }
        else {
            if (!empty($author)) echo $author . "\n";
        }
    }
}

?>
