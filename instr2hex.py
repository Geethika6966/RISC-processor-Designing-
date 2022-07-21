# Converts the string form of an instruction to the corresponding hexadecimal form

import sys

# Usage: python3 instr2hex.py "LW R2 R0 2"

if len(sys.argv) != 2:
    sys.exit('Usage: python3 instr2hex.py "<instruction>"\nExample: python3 instr2hex.py "LW R2 R0 2"')

text = sys.argv[1]

tokens = text.split(" ")

op = tokens[0]

if op in ["ADD", "ADC", "ADZ", "NDU", "NDC", "NDZ"]:

    if op[0] == "A":
        op_bits = "0000"
    else:
        op_bits = "0010"

    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    RC = int(tokens[3][1])

    RA_bits = "{0:03b}".format(RA)
    RB_bits = "{0:03b}".format(RB)
    RC_bits = "{0:03b}".format(RC)

    if op[2] == "C":
        CZ = "10"
    elif op[2] == "Z":
        CZ = "01"
    else:
        CZ = "00"

    binary = op_bits + RA_bits + RB_bits + RC_bits + "0" + CZ

elif op in ["ADI", "LW", "SW", "BEQ"]:

    if op == "ADI":
        op_bits = "0001"
    elif op == "LW":
        op_bits = "0100"
    elif op == "SW":
        op_bits = "0101"
    else:
        op_bits = "1100"

    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    IMM = int(tokens[3])

    RA_bits = "{0:03b}".format(RA)
    RB_bits = "{0:03b}".format(RB)
    IMM_bits = "{0:06b}".format(IMM)

    binary = op_bits + RA_bits + RB_bits + IMM_bits

elif op == "JLR":
    op_bits = "1001"
    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    RA_bits = "{0:03b}".format(RA)
    RB_bits = "{0:03b}".format(RB)
    binary = op_bits + RA_bits + RB_bits + "0" * 6

elif op in ["LA", "SA"]:

    if op == "LA":
        op_bits = "0110"
    elif op == "SA":
        op_bits = "0111"

    RA = int(tokens[1][1])
    RA_bits = "{0:03b}".format(RA)
    binary = op_bits + RA_bits + "0" * 9

elif op in ["LHI", "JAL"]:

    if op == "LHI":
        op_bits = "0011"
    elif op == "JAL":
        op_bits = "1000"

    RA = int(tokens[1][1])
    IMM = int(tokens[2])

    RA_bits = "{0:03b}".format(RA)
    IMM_bits = "{0:09b}".format(IMM)

    binary = op_bits + RA_bits + IMM_bits

# print(binary)
print('x"{0:04x}"'.format(int(binary, 2)))
