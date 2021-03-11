import RPi.GPIO as GPIO
import time
import socket
import random

HOST = '192.168.0.53'  # Standard loopback interface address (localhost)
PORT = 6565        #


# PIN connected to IN1
power_pin = 23
coffe_pin = 26

def coffeRoutine():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(power_pin,GPIO.OUT)
    try:
        powerOn()
        time.sleep(90)
        startCoffe()
        time.sleep(20)
        stopCoffe()
        GPIO.cleanup()
    except KeyboardInterrupt:
        GPIO.cleanup()

def powerOn():
    GPIO.output (power_pin,GPIO.LOW)

def powerOff():
    GPIO.output(power_pin,GPIO.HIGH)


def startCoffe():
    GPIO.setup(coffe_pin,GPIO.OUT)
    GPIO.output (coffe_pin,GPIO.LOW)
    

def stopCoffe():
    GPIO.output (coffe_pin,GPIO.HIGH)
    GPIO.output(coffe_pin,GPIO.LOW)

# Set mode BCM
#Type of PIN - output
if __name__ == "__main__":
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    s.bind((HOST, PORT))

    s.listen()
    try:
        while True:
            conn, addr = s.accept()
            data = conn.recv(1024)
            data = str(data)
            conn.send("coffe command received".encode());
            
            if ("make coffee" in data):
                coffeRoutine()
            
            
        s.close()
    except:
        s.close()
   
    
            

    
