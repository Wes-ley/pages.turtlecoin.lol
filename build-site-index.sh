#!/usr/bin/env/ bash

# This file builds the index.html for pages.turtlecoin.lol
# every 30 seconds. It uses standard Unix tools to generate
# a directory of the most recently modified pages hosted
# on this server.

# Put a timestamp in the terminal so we know when the process started
echo `date` -- generating index.html

# This statement is unique
# Using > instead of >> ensures we start with a blank file
echo '<!doctype html>' > /var/www/html/index.html

# This line, and those after it use >> to append a new line
# rather than a line into a fresh file.
echo '<html lang="en">' >> /var/www/html/index.html
echo '  <head>' >> /var/www/html/index.html

# This should auto refresh the page every 30 seconds
echo '<meta http-equiv="refresh" content="30">' >> /var/www/html/index.html

# This is just a plain bootstrap include to bring in some
# basic style and grid/viewport management
echo '    <meta charset="utf-8">' >> /var/www/html/index.html
echo '    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">' >> /var/www/html/index.html
echo '' >> /var/www/html/index.html
echo '    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">' >> /var/www/html/index.html
echo '' >> /var/www/html/index.html
echo '    <title>TurtleCities&trade;</title>' >> /var/www/html/index.html
echo '		</head>' >> /var/www/html/index.html

# Inline styles might not be the most space effective
# Could change this later.
echo '  <body style="line-height: 100%;" >' >> /var/www/html/index.html
echo '<br><br><br>' >> /var/www/html/index.html

# A helpful thing to remember about Bootstrap, divs needs to be in order.
# You always go div-container -> div-row -> div-col.
echo '<div class="container">' >> /var/www/html/index.html
echo '	<div class="row">' >> /var/www/html/index.html
echo '	<div class="col">' >> /var/www/html/index.html
echo '<h1>TurtleCities&trade;</h1>' >> /var/www/html/index.html
echo '<hr style="border-top: 2px solid #000"><br><br>' >> /var/www/html/index.html
echo '<pre>' >> /var/www/html/index.html

# Screenfetch is a tool to make a terminal welcome message
# to generate some quick aesthetic system stats.
screenfetch -N -d '-host;-shell'>> /var/www/html/index.html

echo '<br></pre>' >> /var/www/html/index.html

# This is the script to generate the most recently active users
# using -t with ls will sort by last modified.
# awk is used to trim off the first two lines, which are just status messages.
echo '<p><strong>recently updated<br></strong>' >> /var/www/html/index.html
ls -t /var/www/html | awk '{if(NR>1)print}' > ~/activeusers.txt

# These next few lines iterate through the list of directories/users
# and prepend+append the code around the directory names to make links.
# Since I can't use the directory name as a variabel, I use a turtle.
sed 's,^,<a href="/,' ~/activeusers.txt > ~/activeusers.prepended.txt
sed 's,$," target=_blank>ðŸ¢</a>,' ~/activeusers.prepended.txt > ~/activeusers.appended.txt

# I use tail -n+3 to trim some lines which are malformed links
# from directories that don't translate to anything useful.
tail -n+3 ~/activeusers.appended.txt > ~/activeusers.formatted.txt

# This entire time we've been manipulating the directory/user list in
# an external file. This next line takes that work and reunites it
# with the main index.html
cat ~/activeusers.appended.txt >> /var/www/html/index.html

# This doesnt have to be in any particular place, so I put it here.
# For some reason, when I create the ftp accounts, the user directory
# has the wrong permissions to be viewed from a web browser.
# This is basically a standard Unix perms reset that respects the
# difference between files and folders. Files without read permission
# for 'other' will continue to withhold read permissions.
sudo find /var/www/ -type d -exec chmod 755 {} \;
sudo find /var/www/ -type f -perm -o+r -exec chmod 644 {} \;
sudo find /var/www/ -type f ! -perm -o+r -exec chmod 600 {} \;


echo '</p>' >> /var/www/html/index.html
echo '</div>' >> /var/www/html/index.html
echo '</div><br>' >> /var/www/html/index.html
echo '<div class="row">' >> /var/www/html/index.html
echo '	<div class="col">' >> /var/www/html/index.html

# This is the who what why how section of the page
# Eventually, this description could be improved, and maybe
# we should automate signups.
echo '<p><strong>who<br></strong> http://pages.turtlecoin.lol/<em>~username</em></p><br>' >> /var/www/html/index.html
echo '<p><strong>what<br></strong> free hosting for TurtleCoin users and contributors. 1.44MB of floppy disk space, no database</p><br>' >> /var/www/html/index.html
echo '<p><strong>why<br></strong> this is just a project for fun to see what people can do with a floppy worth of web space to express themselves. make something cool, do as much as you can and be creative as possible.</p><br>' >> /var/www/html/index.html
echo '<p><strong>how<br></strong> if you would like to have your own page, you can sign up by filling out this form <a href="https://goo.gl/forms/r3MfvbefMYFY8ht23">here</a>. accounts are created manually, and can be terminated at any time, so please be nice and do not abuse the system.</p><br>' >> /var/www/html/index.html
echo '<br><br><br><p class="text-center">' >> /var/www/html/index.html

# I wanted to have one of those throwback "last modified" things
# on the page, so let's throw in another timestamp so that at a glance
# we can tell when the last time the page was successfully built.
echo "<br><small><a href='https://www.gnu.org/software/bash/' target=_blank>Built on `date -R` with BASH</a></small>" >> /var/www/html/index.html

echo '</p>' >> /var/www/html/index.html
echo '</center>' >> /var/www/html/index.html
echo '</div>' >> /var/www/html/index.html
echo '</div>' >> /var/www/html/index.html
echo '</div>' >> /var/www/html/index.html
echo '  </body>' >> /var/www/html/index.html
echo '</html>' >> /var/www/html/index.html

# Tell the people watching the terminal that we've finished
# generating the index.html
echo `date` -- successfully created index.html

# Wait 30 seconds and do it all again!
echo waiting ...
sleep 30
