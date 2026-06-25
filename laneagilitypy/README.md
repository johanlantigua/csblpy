# Agility GUI Python Version

This folder contains a Python translation of `matlabcode/agility_GUI_LA_camp.m`.

## Run

```powershell
python agility_gui_la_camp.py
```

If `python` is not on your PATH in this Codex workspace, this bundled interpreter worked during verification:

```powershell
C:\Users\johan\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe agility_gui_la_camp.py
```

## Arduino dependency

The app uses `pyfirmata`, so the Arduino must have StandardFirmata uploaded once. After that, the Python app can read A1 without MATLAB.

Install the Python dependencies in the Python environment you plan to run:

```powershell
python -m pip install -r requirements.txt
```

The COM port should match the field in the GUI.

## Build a Windows `.exe`

From this folder, run:

```powershell
.\build_exe.ps1
```

The finished app will be created at:

```powershell
dist\CSBL Agility.exe
```

The `.exe` is built with PyInstaller in windowed mode, so it opens like a normal desktop app instead of showing a console window. The app window, taskbar hover name, and executable are named `CSBL Agility`, and the icon is built from `pics\lablogo.png`.

## Export behavior

The Excel export matches the MATLAB sheet layout:

- test info/results in columns A and B
- raw `Time (s)` and `Signal (V)` data starting at E2/F2
- file name format: `agility_<Player Number>.xlsx`

The original MATLAB code exports to a hard-coded Dropbox folder. The Python version uses that folder if it exists; otherwise it saves in the current working directory.
