# Arduino Firmware Guide for Python

This Python app talks to the Arduino through `pyfirmata`, so the Arduino needs **StandardFirmata** uploaded.

Important: uploading StandardFirmata replaces the current sketch on the Arduino. If you still need the old MATLAB setup, back up the current firmware first.

## 1. Close Anything Using COM5

Close:

- MATLAB
- Arduino IDE
- Arduino IDE Serial Monitor
- CSBL Jump Plate
- CSBL Agility
- Python app
- Any VS Code serial monitor

Only one program can use `COM5` at a time.

## 2. Back Up Current Arduino Firmware

Find `avrdude.exe`:

```powershell
Get-ChildItem "$env:LOCALAPPDATA\Arduino15\packages\arduino\tools\avrdude" -Recurse -Filter avrdude.exe
```

On this computer it was:

```powershell
C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe
```

Back up the current jump plate firmware:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM5 -b115200 -D -Uflash:r:"C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplate_arduino_backup.hex":i
```

This creates:

```text
C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplate_arduino_backup.hex
```

That file is a compiled firmware backup. It is not editable Arduino source code, but it can be restored later.

## 3. Make A No-Bootloader Restore File

The normal Arduino upload method cannot overwrite the bootloader section. This no-bootloader file helps avoid restore failures near 98%.

Run:

```powershell
cd C:\Users\johan\OneDrive\Desktop\matlabtopy
python make_no_bootloader_backup.py jumpplate_arduino_backup.hex jumpplate_arduino_backup_no_bootloader.hex
```

This creates:

```text
C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplate_arduino_backup_no_bootloader.hex
```

## 4. Upload StandardFirmata

Open Arduino IDE.

Select the board:

```text
Tools -> Board -> Arduino AVR Boards -> Arduino Uno
```

Select the port:

```text
Tools -> Port -> COM5
```

Open StandardFirmata:

```text
File -> Examples -> Firmata -> StandardFirmata
```

If Firmata is missing:

```text
Sketch -> Include Library -> Manage Libraries...
```

Search for:

```text
Firmata
```

Install **Firmata**, then open `File -> Examples -> Firmata -> StandardFirmata`.

Click **Upload**.

After upload completes, close Arduino IDE completely.

## 5. Install Python Dependencies

From VS Code or PowerShell:

```powershell
cd C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplatepy
python -m pip install -r requirements.txt
```

## 6. Test The Python App

Run:

```powershell
python jump_plate_app.py
```

In the app:

1. Enter `COM5`
2. Click **Initialize Arduino**
3. Confirm the COM port box turns green
4. Click **Start Data Collection**

The app reads the jump plate signal from analog pin `A0`.

## 7. Build The EXE

```powershell
cd C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplatepy
powershell -ExecutionPolicy Bypass -File .\build_exe.ps1
```

The app will be created at:

```text
C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplatepy\dist\CSBL Jump Plate.exe
```

## 8. Restore Old Firmware If Needed

If you need the board back the way it was before StandardFirmata, close all programs using `COM5`, then restore the backup.

Use the no-bootloader backup:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM5 -b115200 -D -Uflash:w:"C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplate_arduino_backup_no_bootloader.hex":i
```

If that file does not exist, use the original backup:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM5 -b115200 -D -Uflash:w:"C:\Users\johan\OneDrive\Desktop\matlabtopy\jumpplate_arduino_backup.hex":i
```

If restore fails near 98%, the backup includes the bootloader section. Use `jumpplate_arduino_backup_no_bootloader.hex` instead.

## Common Error

```text
cannot open port COM5: Access is denied
```

This means another program is using the Arduino. Close MATLAB, Arduino IDE, Serial Monitor, Python, and the EXE. If it still happens, unplug the Arduino, wait 5 seconds, plug it back in, and try again.

## Upload Output

This output is normal after compiling/uploading StandardFirmata:

```text
Sketch uses 13172 bytes (40%) of program storage space.
Global variables use 1113 bytes (54%) of dynamic memory.
```

You still need to confirm Arduino IDE says:

```text
Done uploading.
```
