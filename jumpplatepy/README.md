# CSBL Jump Plate

Python translation of `jumpplatematlab/jump_plate_executable.m`.

## Run

```powershell
python jump_plate_app.py
```

The Arduino must have StandardFirmata uploaded. The app reads analog pin `A0`, matching the MATLAB jump plate signal.

## Build EXE

```powershell
powershell -ExecutionPolicy Bypass -File .\build_exe.ps1
```

The executable will be created at:

```powershell
dist\CSBL Jump Plate.exe
```

## Export

The Excel export matches the MATLAB layout:

- file name: `vertical_<Player Number>.xlsx`
- test info/results in columns A and B
- raw data starts at E2 with `Time (s)`, `Signal Jump Plate (V)`, and `Signal Laser (V)`
