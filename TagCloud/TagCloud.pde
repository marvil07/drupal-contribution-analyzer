import java.io.InputStream;
import java.util.List;
import java.util.Iterator;
import java.util.Collections;

import wordookie.Layout;
import wordookie.Word;
import wordookie.parsers.WordWeightParser;

final color BACKGROUND = #FFFFFF;
final String FONT_NAME = "Droid Serif";
int [] cloudColors = { #EC2300, #F89F00, #F88800, #6B001C, #EC3A00, #333A00, #6B0009, #5C6E00, #6C6E00, #303A00, #4C3200 };

WordWeightParser parser;
Layout layout;
List words;
Iterator itr;
PFont font;

int startTime;
float lenght, count, percent;

// this table is used to store all command line parameters
// in the form: name=value
static Hashtable parameters = new Hashtable();
String filename = "";

void setup() {
    filename = param("file");
    size( 1400, 900);
    smooth();

    parser = new WordWeightParser();
    InputStream in = createInput( filename );
    try {
        parser.load( in );
    }
    catch( Exception ex ) {
        ex.printStackTrace();
    }

    words = parser.getWords();
    Collections.sort( words );
    itr = words.iterator();
    lenght = words.size();

    layout = new Layout( this, BACKGROUND );
    layout.setAngleType( layout.MOSTLY_HORIZONTAL );

    background( BACKGROUND );

    font = createFont( FONT_NAME, 120 );
    // Uncomment the following two lines to see the available fonts
    //String[] fontList = PFont.list();
    //println(fontList);

    startTime = millis();
}

void draw() {
    if ( itr.hasNext() ) {
        Word word = (Word)itr.next();
        count++;
        percent = count / lenght * 100;
        System.out.format("%2.1f %% | word: %s | weight: %.0f%n", percent, word.toString(), word.weight);

        int fontSize = (int)map( word.weight, parser.getMinWeight(), parser.getMaxWeight(), 8, 96 );
        word.font = font;
        word.fontSize = fontSize;
        layout.doLayout( word );
        fill( cloudColors[ (int)random(cloudColors.length) ] );
        layout.paintWord( word );

    }
    else {
        int endTime = millis();
        println( "Done: " + (endTime - startTime) + " msec" );
        saveFrame("../../data/tagclouds/" + basename(filename) + ".tif");
        noLoop();
        exit();
    }
}

// see http://wiki.processing.org/w/Setting_width/height_dynamically
static public void main(String args[]) {
    String[] newArgs = new String[args.length+1];
    newArgs[0] = "TagCloud";

    for (int i=0; i<args.length; i++) {
        newArgs[i+1] = args[i];
        if (args[i].indexOf("=") != -1) {
            String[] pair = split(args[i], '=');
            parameters.put(pair[0], pair[1]);
        }
    }

    PApplet.main(newArgs);
}

String param(String id) {
    if (online) {
        return super.param(id);
    }
    else {
        return (String)parameters.get(id);
    }
}

String basename(String path) {
    return (new File(path)).getName();
}
