#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import tkinter as tk
from tkinter import messagebox
import time
import serial
import csv
import numpy as np
from datetime import datetime

# ---- Serial Port Setup ----

# Connect to the specified COM port (check in device manager)
uart = serial.Serial('COM4', 9600, timeout=1)

# ---- Data Conversion Functions ----
def to_hex(txt):
    """
    Converts a text string to its hexadecimal representation.
    """
    return txt.encode('utf-8').hex()

def to_decimal(hex_data):
    """
    Converts a hexadecimal string into a list of decimal byte values.
    Each pair of hex digits is converted into an integer.
    """
    counts_per_sec = []
    for i in range(0, len(hex_data), 2):
        byte = hex_data[i:i+2]
        counts = int(byte, 16)
        counts_per_sec.append(counts)
    return counts_per_sec

# ---- Data Collection and CSV Writing ----
def start_recording():
    """
    Main function to execute when the 'Start Recording' button is clicked.
    It collects the input, starts reading UART data for 60 seconds,
    and writes the input information along with count data to a CSV file.
    """
    # Read inputs from GUI fields
    voltage = voltage_entry.get()
    date_time = datetime_entry.get()
    label = label_entry.get()

    # Check all input fields are filled
    if not (voltage and date_time and label):
        messagebox.showerror("Missing Input", "Please fill in all fields.")
        return

    # Open UART port (if not already open)
    if not uart.is_open:
        uart.open()

    print('Reading data...')
    data_log = []  # List to store timestamp, count, etc. 

    # Record data for 60 seconds (can change based on the test)
    start = time.time()
    duration = 60
    while time.time() - start < duration:
        data = uart.readline()  # Read one line from serial port
        if data:
            txt = data.decode('utf-8').strip()  # Convert bytes to string
            hex_data = to_hex(txt)              # Convert to hex
            count = to_decimal(hex_data)        # Convert hex to list of decimal values
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(count)
            data_log.append([timestamp, count])  # Save with timestamp

    uart.close()
    print("Done reading data.")

    # ---- CSV Output ----
    filename = f"counts_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Write header metadata
        writer.writerow(["Voltage", voltage])
        writer.writerow(["Date/Time", date_time])
        writer.writerow(["Label", label])
        writer.writerow([])  # Empty line
        writer.writerow(["Timestamp", "Counts"])  # Column headers for data
        # Write each data entry
        for row in data_log:
            writer.writerow(row)

    # Show confirmation popup
    messagebox.showinfo("Done", f"Data saved to {filename}")

# ---- GUI Setup ----
# Create main application window
root = tk.Tk()
root.title("UART Particle Counter Input")
root.geometry("400x300")  # Set window size

# Create and place GUI widgets for inputs
tk.Label(root, text="Voltage (V):").pack(pady=5)
voltage_entry = tk.Entry(root)
voltage_entry.pack()

tk.Label(root, text="Date & Time (e.g., 2025-05-08 14:00):").pack(pady=5)
datetime_entry = tk.Entry(root)
datetime_entry.pack()

tk.Label(root, text="Label (e.g., Experiment ID):").pack(pady=5)
label_entry = tk.Entry(root)
label_entry.pack()

# Create and place the 'Start Recording' button
tk.Button(root, text="Start Recording", command=start_recording).pack(pady=20)

# Start the GUI event loop
root.mainloop()

