#!/bin/bash

#email subject
SUBJECT="You job is finished"
#Email To ?
EMAIL="monadynshy@outlook.com"
#Email text/message
#EMAILMESSAGE="/tmp/emailmessage.txt"
EMAILMESSAGE="Thanks"
echo "You job is finisehd"> $EMAILMESSAGE
# send an emal using /bin/mail
mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
