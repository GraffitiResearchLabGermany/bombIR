--------------------------------------------------------------------- 

  OBAMA GML PLAYA 

  by Golan Levin & Jerome Saint-Clair 
  for GraffitiMarkupLanguage + F.A.T. Lab.
  
  http://www.flong.com
  http://www.saint-clair.net
  http://www.graffitimarkuplanguage.com
  http://www.fffff.at

--------------------------------------------------------------------- 

REQUIREMENTS

You can run this code using the Processing IDE.
Processing download page: http://processing.org/download

You'll also need the GML4U Processing library which
you can find at http://github.com/01010101/GML4U/downloads
Extract the zip content inside your Processing sketchbook's "libraries"
folder.

+--Processing
  +-- any sketch name
  +-- libraries
    +-- GML4U
      +-- examples
      +-- library
      +-- reference
      +-- src
  +-- other sketch name
  

--------------------------------------------------------------------- 
ABOUT GML

http://www.graffitimarkuplanguage.com/

Overview:
Graffiti Markup Language (.gml) is a universal, XML-based, open file 
format designed to store graffiti motion data (x coordinates, y coordinates 
and time). The format is designed to maximize readability and ease of 
implementation for even hobbyist programmers, artists and graffiti writers. 
Popular applications currently implementing GML include Graffiti Analysis 
and EyeWriter. Beyond storing data, a main goal of GML is to spark interest 
surrounding the importance (and fun) of open data and introduce open source 
collaborations to new communities. GML is intended to be a simple bridge between 
ink and code, promoting collaborations between graffiti writers and hackers.

GML is todayÕs new digital standard for tomorrowÕs vandals.

Credits:
Project lead: Evan Roth
Technical lead: Jamie Wilkinson
Originally created by: Evan Roth, Chris Sugrue, Jamie Wilkinson and Theo Watson
The GML v1.0 Spec Doc was created by: Golan Levin, Evan Roth, JŽr™me Saint-Clair,
Chris Sugrue, Jamie Wilkinson and Theo Watson (most of which are card carrying 
members of F.A.T. Ð Free Art & Technology).

The GML specifications:
http://www.graffitimarkuplanguage.com/g-m-l-spec/

--------------------------------------------------------------------- 

ABOUT THE GML4U LIBRARY
 
GML4U is a GML library for Processing.
The main idea behind this library is to provide a maximum help 
in the parsing and manipulation of the gml elements and allow people
to focus on the drawing side by implementing their own way to draw.

You can post your realizations to:
Flickr group: http://flickr.com/groups/gml4u
Vimeo group: http://vimeo.com/groups/gml4u
Vimeo channel: http://vimeo.com/channels/gml4u

If you want to share your custom drawer's code, please get in
touch with me (see contact info below) and I'll compile the
submissions in a gml4u.drawers package. 

Links:
Source code: http://github.com/01010101/GML4U
Packaged library: http://github.com/01010101/GML4U/downloads

Contact:
If you want to be keep track of the developments, releases and uses
of this library
- either follow @gml4u on Twitter
- or drop me a mail at gml@01010101.org

Any suggestions, contributions, bug reports are welcomed.

--------------------------------------------------------------------- 

INSTALLATION

Make sure that your environment complies with requirements (see above).

The Obama GML Playa can be executed in two ways.
- Either as an application
- Or as an applet (web based)

* PROCESSING APPLICATION
Copy the ObamaGmlPlaya folder to your Processing sketchs folder.
Open the ObamaGmlPlaya.pde file and run it.
Note: if you're offline, edit the "local" variable and set it to true.
By doing so, the Playa will use demo files stored localy.


* PROCESSING APPLET
Copy the ObamaGmlPlaya folder to your Processing sketchs folder.
Open the ObamaGmlPlaya.pde file.
Export the app as an Applet (File -> Export).
This will create an "applet" folder.

To avoid having to sign the java applet when accessing the 000000book.com
website to get gml files, we use a proxy file.
Doing it this way, the applet sees as local files what's hosted on another domain.

Copy the following files to the applet folder:
OOOOOObookproxy.php
proxyURL.txt

Then, edit the "proxyURL.txt" file's first line to match the exact 
url to your OOOOOObookproxy.php file.
ie: http://www.yourdomain/appletpath/OOOOOObookproxy.php

Then copy the applet folder to your website and you're done.

Note: needless to say that it only works if your server can run php files.
If not, you'll have to do a proxy from scratch using
the same mechanisms as the OOOOOObookproxy.php to load
gml files. See the PROXY HOW-TO SECTION below

------------------------------------------------------------

PROXY HOW-TO

If you have to build a proxy yourself
The proxy file is called in three ways: 

http://www.yourdomain/appletpath/your000000bookproxyfile?api=random
Will retrieve a random gml file
by calling http://000000book.com/random.gml

http://www.yourdomain/appletpath/your000000bookproxyfile?api=latest
Will retrieve the latest submitted gml file
by calling http://000000book.com/latest.gml

http://www.yourdomain/appletpath/your000000bookproxyfile?tagid=19518
Will retrieve the tag id (ie: 19518) that you specified 
by calling  http://000000book.com/data/19518.gml

See the API section of http://jamiedubs.com/wikis/blackbook/ for more info

--------------------

Enjoy