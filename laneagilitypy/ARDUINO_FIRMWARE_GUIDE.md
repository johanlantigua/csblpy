# Arduino Firmware Guide for Python

This Python app talks to the Arduino through `pyfirmata`, so the Arduino needs **StandardFirmata** uploaded.

Important: uploading StandardFirmata replaces the current sketch on the Arduino. If you still need the old MATLAB setup, back up the current firmware first.

## 1. Close Anything Using COM4

Close:

- MATLAB
- Arduino IDE Serial Monitor
- CSBL Agility
- Python app
- Any VS Code serial monitor

Only one program can use `COM4` at a time.

## 2. Back Up Current Arduino Firmware

Find `avrdude.exe`:

```powershell
Get-ChildItem "$env:LOCALAPPDATA\Arduino15\packages\arduino\tools\avrdude" -Recurse -Filter avrdude.exe
```

On this computer it was:

```powershell
C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe
```

Back up the current firmware:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM4 -b115200 -D -Uflash:r:"C:\Users\johan\OneDrive\Desktop\matlabtopy\arduino_backup.hex":i
```

This creates:

```text
C:\Users\johan\OneDrive\Desktop\matlabtopy\arduino_backup.hex
```

That file is a compiled firmware backup. It is not editable Arduino source code, but it can be restored later.

## 3. Upload StandardFirmata

Open Arduino IDE.

Select the board:

```text
Tools -> Board -> Arduino AVR Boards -> Arduino Uno
```

Select the port:

```text
Tools -> Port -> COM4
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

## 4. Install Python Dependencies

From VS Code or PowerShell:

```powershell
cd C:\Users\johan\OneDrive\Desktop\matlabtopy\laneagilitypy
python -m pip install -r requirements.txt
```

## 5. Test The Python App

Run:

```powershell
python agility_gui_la_camp.py
```

In the app:

1. Enter `COM4`
2. Click **Initialize Arduino**
3. Confirm the COM port box turns green
4. Click **Start Data Collection**

## 6. Build The EXE

```powershell
cd C:\Users\johan\OneDrive\Desktop\matlabtopy\laneagilitypy
powershell -ExecutionPolicy Bypass -File .\build_exe.ps1
```

The app will be created at:

```text
C:\Users\johan\OneDrive\Desktop\matlabtopy\laneagilitypy\dist\CSBL Agility.exe
```

## 7. Restore Old Firmware If Needed

If you need the board back the way it was before StandardFirmata, close all programs using `COM4`, then restore the backup.

Use the no-bootloader backup if available:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM4 -b115200 -D -Uflash:w:"C:\Users\johan\OneDrive\Desktop\matlabtopy\arduino_backup_no_bootloader.hex":i
```

If that file does not exist, use the original backup:

```powershell
& "C:\Users\johan\AppData\Local\Arduino15\packages\arduino\tools\avrdude\8.0.0-arduino1\bin\avrdude.exe" -v -patmega328p -carduino -PCOM4 -b115200 -D -Uflash:w:"C:\Users\johan\OneDrive\Desktop\matlabtopy\arduino_backup.hex":i
```

If restore fails near 98%, the backup includes the bootloader section. Use `arduino_backup_no_bootloader.hex` instead.

## Common Error

```text
cannot open port COM4: Access is denied
```

This means another program is using the Arduino. Close MATLAB, Arduino IDE, Serial Monitor, Python, and the EXE. If it still happens, unplug the Arduino, wait 5 seconds, plug it back in, and try again.
