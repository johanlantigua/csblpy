from pathlib import Path
import sys


BOOTLOADER_START = 0x7E00


def checksum(record: list[int]) -> int:
    return ((~(sum(record) & 0xFF) + 1) & 0xFF)


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python make_no_bootloader_backup.py input.hex output.hex")
        return 1

    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])
    kept: list[str] = []
    ext_linear = 0
    ext_segment = 0

    for raw in src.read_text().splitlines():
        line = raw.strip()
        if not line:
            continue
        if not line.startswith(":"):
            raise ValueError(f"Bad Intel HEX line: {line}")

        data = bytes.fromhex(line[1:])
        count = data[0]
        addr = (data[1] << 8) | data[2]
        rectype = data[3]
        payload = data[4 : 4 + count]

        if rectype == 0x00:
            base = (ext_linear << 16) + (ext_segment << 4)
            full_addr = base + addr
            if full_addr >= BOOTLOADER_START:
                continue
            if full_addr + count > BOOTLOADER_START:
                payload = payload[: BOOTLOADER_START - full_addr]
                count = len(payload)
            record = [count, (addr >> 8) & 0xFF, addr & 0xFF, rectype, *payload]
            kept.append(":" + bytes(record + [checksum(record)]).hex().upper())
        elif rectype == 0x01:
            continue
        else:
            kept.append(line.upper())
            if rectype == 0x02:
                ext_segment = (payload[0] << 8) | payload[1]
                ext_linear = 0
            elif rectype == 0x04:
                ext_linear = (payload[0] << 8) | payload[1]
                ext_segment = 0

    kept.append(":00000001FF")
    dst.write_text("\n".join(kept) + "\n")
    print(f"Wrote {dst}")
    print(f"Excluded bootloader addresses >= 0x{BOOTLOADER_START:04X}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
