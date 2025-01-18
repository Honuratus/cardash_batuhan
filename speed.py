import subprocess
from pynput import keyboard

speed = 0
ivme = 1
key_pressed = False 

def send_speed(speed):
    hex_speed = f"{int(speed):02X}" 
    command = f"cansend vcan0 123#{hex_speed}"
    subprocess.run(command, shell=True)
    print(f"Sent speed: {speed:.1f} km/h as {hex_speed} over CAN")

def on_press(key):
    global speed
    global ivme
    global key_pressed
    key_pressed = True 
    try:
        if key.char == 'w':  
            speed += 0.3 * ivme
            ivme += 0.001
        elif key.char == 's':
            speed -= 1
            if speed < 0:
                speed = 0
    except AttributeError:
        pass

def on_release(key):
    global key_pressed
    global ivme
    key_pressed = False  
    ivme = 1  

def main():
    global speed
    global key_pressed

    while True:
        if not key_pressed:
            speed -= 1  
            if speed < 0:  
                speed = 0
        send_speed(speed)  

listener = keyboard.Listener(on_press=on_press, on_release=on_release)
listener.start()

try:
    main()
except KeyboardInterrupt:
    print("Program interrupted.")
