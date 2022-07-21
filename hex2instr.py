# Converts a hexadecimal instruction to it's human-readable string form

import sys

# Usage: python3 hex2instr.py 33ff

if len(sys.argv) != 2:
    sys.exit("Usage: python3 hex2instr.py <hex_value>\nExample: python3 hex2instr.py c042")

text = sys.argv[1]

binary = "{:016b}".format(int(text, 16))

op_bits = binary[:4]

# ADD, ADC, ADZ
if op_bits == "0000":

    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    RC = int(binary[10:13], 2)

    CZ = binary[-2:]

    if CZ == "00":
        op = "ADD"
    elif CZ == "10":
        op = "ADC"
    elif CZ == "01":
        op = "ADZ"

    s = f"{op} R{RA} R{RB} R{RC} 0 {CZ}"

# NDU, NDC, NDZ
if op_bits == "0010":

    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    RC = int(binary[10:13], 2)

    CZ = binary[-2:]

    if CZ == "00":
        op = "NDU"
    elif CZ == "10":
        op = "NDC"
    elif CZ == "01":
        op = "NDZ"

    s = f"{op} R{RA} R{RB} R{RC} 0 {CZ}"

# ADI
elif op_bits == "0001":
    op = "ADI"
    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    IM = int(binary[-6:], 2)
    s = f"{op} R{RA} R{RB} {IM}"

# LW
elif op_bits == "0100":
    op = "LW"
    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    IM = int(binary[-6:], 2)
    s = f"{op} R{RA} R{RB} {IM}"

# SW
elif op_bits == "0101":
    op = "SW"
    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    IM = int(binary[-6:], 2)
    s = f"{op} R{RA} R{RB} {IM}"

# BEQ
elif op_bits == "1100":
    op = "BEQ"
    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    IM = int(binary[-6:], 2)
    s = f"{op} R{RA} R{RB} {IM}"

# JLR
elif op_bits == "1001":
    op = "JLR"
    RA = int(binary[4:7], 2)
    RB = int(binary[7:10], 2)
    s = f"{op} R{RA} R{RB} " + "0" * 6

# LHI
elif op_bits == "0011":
    op = "LHI"
    RA = int(binary[4:7], 2)
    IM = int(binary[-9:], 2)
    s = f"{op} R{RA} {IM}"

# JAL
elif op_bits == "1000":
    op = "JAL"
    RA = int(binary[4:7], 2)
    IM = int(binary[-9:], 2)
    s = f"{op} R{RA} {IM}"

# LA
elif op_bits == "0110":
    op = "LA"
    RA = int(binary[4:7], 2)
    s = f"{op} R{RA} " + "0" * 9

# SA
elif op_bits == "0111":
    op = "SA"
    RA = int(binary[4:7], 2)
    s = f"{op} R{RA} " + "0" * 9

print(s)
