#!/bin/sh

# it is VERY IMPORTANT this file is saved with LF line-ending (not CRLF) or it won't work!

# note, this is similar to what's in the dockerfile
# we COULD remove it from the dockerfile, but then it would be difficult if we ever wanted to remove the startup.sh setup
# so we keep both for now, so the dockerfile is enough to run 

echo "---> Step 1: updating pcap2qlog"
cd /srv/pcap2qlog/
git pull origin master
npm install
./node_modules/typescript/bin/tsc -p ./

echo "---> Step 2: updating qvisserver"
cd /srv/qvisserver 
# this one is already pulled by the global startup.sh
npm install
./node_modules/typescript/bin/tsc -p .

echo "---> Step 3: updating qvis"
cd /srv/qvis/visualizations
git pull origin master
npm install
npm run build
cp -ur /srv/qvis/visualizations/dist/* /srv/qvisserver/out/public # -u only copies if files are newer or don't exist yet 

echo "---> Step 4 (final): launching qvisserver"
cd /srv/qvisserver/out  # must be in this folder or the working directory will be wrong inside node 
node index.js "$@" # this will start the actual web server

tail -f /dev/null # keep container around even after possible crash, so we can look at logs later 
