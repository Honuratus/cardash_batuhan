# This Python file uses the following encoding: utf-8
import sys
import can
import threading

from pathlib import Path

from PySide6.QtGui import QGuiApplication, QSurfaceFormat
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Signal, Slot

class CanSimulator(QObject):
    speed = Signal(int)  # Signal to send speed to QML
    rpm = Signal(float)

    def __init__(self):
        super().__init__()
        self.bus = can.interface.Bus(channel='vcan0', interface='socketcan')
        self.running = True

        # Start a thread to listen for CAN messages
        self.listener_thread = threading.Thread(target=self.listen_for_speed)
        self.listener_thread.start()

    def listen_for_speed(self):
        """Listen for speed data on the CAN bus."""
        while self.running:
            msg = self.bus.recv()  # Blocking call to receive a CAN message
            if msg and msg.arbitration_id == 0x123:  # Check for specific CAN ID
                speed = int.from_bytes(msg.data, byteorder='big')  # Decode speed
                print(f"Received speed: {speed} km/h")  # Debugging
                self.speed.emit(speed)  # Emit the speed to QML
                self.rpm.emit(speed / 20)

    def stop(self):
        """Stop the CAN listener."""
        self.running = False
        self.listener_thread.join()

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Setting sample value
    format = QSurfaceFormat()
    format.setSamples(8)
    QSurfaceFormat.setDefaultFormat(format)

    can_simulator = CanSimulator()
    engine.rootContext().setContextProperty("canConnector", can_simulator)

    qml_file = Path(__file__).resolve().parent / "main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    app.aboutToQuit.connect(can_simulator.stop)
    sys.exit(app.exec())
