#!/usr/bin/env python3
# coding=utf-8

import time
import socket
# import RPi.GPIO as GPIO
import MFRC522
import signal
import hashlib
import sys
import requests

continue_reading = True

LOCKOPEN = False  # Status des Schlosses False = zu True = offen


# Userdaten und Passwort aus Zeitgründen unten


server_ip = "192.168.178.54"
LOCK = 1

# Capture SIGINT for cleanup when the script is aborted
def end_read(signal, frame):
    global continue_reading
    print "Ctrl+C captured, ending read."
    continue_reading = False
    # GPIO.cleanup()
    sys.exit()


# Hook the SIGINT
signal.signal(signal.SIGINT, end_read)

# Create an object of the class MFRC522
MIFAREReader = MFRC522.MFRC522()

# Welcome message
print "Welcome to the MFRC522 data read example"
print "Press Ctrl-C to stop."

# This loop keeps checking for chips. If one is near it will get the UID and authenticate
while continue_reading:
    # Scan for cards    
    (status, TagType) = MIFAREReader.MFRC522_Request(MIFAREReader.PICC_REQIDL)

    # If a card is found
    if status == MIFAREReader.MI_OK:
        print "Card detected"

    # Get the UID of the card
    (status, uid) = MIFAREReader.MFRC522_Anticoll()

    # If we have the UID, continue
    if status == MIFAREReader.MI_OK:

        # Print UID
        print "Card read UID: %s,%s,%s,%s" % (uid[0], uid[1], uid[2], uid[3])

        # This is the default key for authentication
        key = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]

        # Select the scanned tag
        MIFAREReader.MFRC522_SelectTag(uid)

        # Authenticate
        status = MIFAREReader.MFRC522_Auth(MIFAREReader.PICC_AUTHENT1A, 8, key, uid)

        # Check if authenticated
        if status == MIFAREReader.MI_OK:
            PASSWORD = "%s:%s:%s:%s" % (uid[0], uid[1], uid[2], uid[3])
            LINK = "http://%s:8080/keyless/user/openDoor?id=%s&password=&%s" % (server_ip, LOCK, PASSWORD)

            r = requests.get(LINK)
            if "true" in r.text:
                print("Authentifikation erfolgreich!")
                if LOCKOPEN:
                    LOCKOPEN = False
                    print("Das Schloss ist jetzt zu!")
                else:
                    LOCKOPEN = True
                    print("Das Schloss ist jetzt offen!")
            else:
                print("Fehler bei der Authentifikation!")
            # print "runns"
            # s.send("Card read UID: %s,%s,%s,%s \n" % (uid[0], uid[1], uid[2], uid[3]))
        MIFAREReader.MFRC522_StopCrypto1()
        time.sleep(3)
else:
    print "Authentication error"
