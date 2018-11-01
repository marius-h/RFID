#!/usr/bin/env python3

import time
import socket
# import RPi.GPIO as GPIO
import MFRC522
import signal
import hashlib
import sys

continue_reading = True

USER = "Lock1"
PASSWORD = "Password"


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
            print "works"
            s = socket.socket()
            host = "127.0.0.1"
            port = 3030
            s.connect((host, port))
            s.send("USER %s" % USER)
            ans = s.recv(1024)
            if ans.startswith("+OK"):
                s.send("PASS %s" % (hashlib.md5(PASSWORD).hexdigest()))
                ans = s.recv(1024)
                if ans.startswith("+OK"):
                    print("Authentification successful!")
                    s.send("OPEN %s:%s:%s:%s" % (uid[0], uid[1], uid[2], uid[3]))
                    ans = s.recv(1024)
                    if ans.startswith("+OK"):
                        print("Allowed to open.")
                        s.send("STATE")
                        ans = s.recv(1024)
                        if ans.startswith("+OK"):
                            lockstate = ans[4:]
                            if lockstate == "OPEN":
                                print("Lock is currently open.")
                                s.send("SET_STATE CLOSE")
                                ans = s.recv(1024)
                                if ans.startswith("+OK"):
                                    print("Lock successfully closed")
                                else:
                                    print("Lock couldn't be closed.")
                            elif lockstate == "CLOSE":
                                print("Lock is currently closed.")
                                s.send("SET_STATE OPEN")
                                ans = s.recv(1024)
                                if ans.startswith("+OK"):
                                    print("Lock successfully opened")
                                else:
                                    print("Lock couldn't be opened.")
                        else:
                            print("ERR State")
                        s.send("QUIT")
                    else:
                        print(ans[5:])
                else:
                    print("ERR Password")
            else:
                print("ERR User")
            # print "runns"
            # s.send("Card read UID: %s,%s,%s,%s \n" % (uid[0], uid[1], uid[2], uid[3]))
            s.close()
            MIFAREReader.MFRC522_StopCrypto1()
            time.sleep(3)
        else:
            print "Authentication error"
