from numpy import binary_repr, base_repr
from sys import argv
import sys
import shutil
import fileinput
import math
import re

try:
    file1 = open(argv[1], 'r')
    print("Text file: " + argv[1])
except:
    if not argv[1]:
        print "Error: instruction file not specified"
    else:
        print "Error: cannot open file:", argv[1]
    sys.exit()

instructions = file1.readlines()
instructions = [x.strip() for x in instructions]
file1.close()

try:
    if argv[2][-1] != '/':
        argv[2] += '/'
    outputFile = open(str(argv[2]) + 'imem.mif','w')
    print("MIF file: " + argv[2] + 'imem.mif')
except:
    outputFile = open('../processor/imem.mif', 'w')
    print("MIF file: " + '../processor/' + 'imem.mif')


newLine = lambda: outputFile.write('\n')
outputFile.write('-- Compiled from text: ' + argv[1])
newLine()
outputFile.write('WIDTH=32;')
newLine()
outputFile.write('DEPTH=4096;')
newLine()
outputFile.write('ADDRESS_RADIX=UNS;')
newLine()
outputFile.write('DATA_RADIX=BIN;')
newLine()
outputFile.write('CONTENT BEGIN')
newLine()

tests = {
    'cycles': len(instructions),
    'checkRegister': []
}

counter = 0;
opcode = {'add':'00000',
          'addi':'00101',
          'sub':'00000',
          'and':'00000',
          'or':'00000',
          'sll':'00000',
          'sra':'00000',
          'mul':'00000',
          'div':'00000',
          'sw':'00111',
          'lw':'01000',
          'j':'00001',
          'bne':'00010',
          'jal':'00011',
          'jr':'00100',
          'blt':'00110',
          'bex':'10110',
          'setx':'10101',
          'beq':'01001',
          'led':'01011',
          'cap':'01100'
          }

replacements = {
    '$v0' : '$r1',
    '$v1' : '$r2',
    '$a0' : '$r3',
    '$a1' : '$r4',
    '$a2' : '$r5',
    '$a3' : '$r6',
    '$t0' : '$r7',
    '$t1' : '$r8',
    '$t2' : '$r9',
    '$t3' : '$r10',
    '$t4' : '$r11',
    '$t5' : '$r12',
    '$t6' : '$r13',
    '$t7' : '$r14',
    '$t8' : '$r15',
    '$t9' : '$r16',
    '$t10' : '$r17',
    '$t11' : '$r18',
    '$t12' : '$r19',
    '$s0' : '$r20',
    '$s1' : '$r21',
    '$s2' : '$r22',
    '$s3' : '$r23',
    '$s4' : '$r24',
    '$s5' : '$r25',
    '$s6' : '$r26',
    '$s7' : '$r27',
    '$sp' : '$r28',
    '$rm' : '$r29',
    '$rstatus' : '$r30',
    '$ra' : '$r31'
}

counter = 0
for instrLine in instructions:
    try:
        if not instrLine.rstrip():
            continue
        instr = instrLine.split()
        instr = [x.strip(',') for x in instr]
        if instr[0][-1] == ':':
            replacements[instr[0][:-1]] = str(counter)
            instr.pop(0)
        if instr[0] != '#' and instr[0] != 'checkreg' and instr[0] != 'cycles':
            counter += 1
    except Exception as e:
        print "Syntax Error:", str(instrLine)
        print "Details:", e
        sys.exit()

counter = 0
for instrLine in instructions:
    try:
        if not instrLine.rstrip():
            continue

        instr = instrLine.split()
        instr = [x.strip(',') for x in instr]

        if instr[0][-1] == ':':
            instr.pop(0)

        for variable in replacements.keys():
            instr = [w if w != variable else replacements[variable] for w in instr]
          
        if instr[0][0] == "#":
            continue

        line = str(counter) + ' : '
        if instr[0] == 'add':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00000'
            line += str(binary_repr(0,2))


        elif instr[0] == 'addi':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3]),17))


        elif instr[0] == 'sub':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00001'
            line += str(binary_repr(0,2))


        elif instr[0] == 'and':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00010'
            line += str(binary_repr(0,2))


        elif instr[0] == 'or':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00011'
            line += str(binary_repr(0,2))


        elif instr[0] == 'sll':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(0,5))
            line += str(binary_repr(int(instr[3]),5))
            line += '00100'
            line += str(binary_repr(0,2))


        elif instr[0] == 'sra':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(0,5))
            line += str(binary_repr(int(instr[3]),5))
            line += '00101'
            line += str(binary_repr(0,2))


        elif instr[0] == 'mul':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00110'
            line += str(binary_repr(0,2))


        elif instr[0] == 'div':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3][2:]),5))
            line += str(binary_repr(0,5))
            line += '00111'
            line += str(binary_repr(0,2))

        elif instr[0] == 'sw' or instr[0] == 'lw':
			for r in replacements.keys():
				instr[2] = instr[2].replace(r, replacements[r])
			line += opcode[instr[0]]
			line += str(binary_repr(int(instr[1][2:]),5))
			pt2 = re.findall(r'\d+', instr[2])
			line += str(binary_repr(int(pt2[1]),5))
			line += str(binary_repr(int(pt2[0]),17))

        elif instr[0] =='j':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1]),27))

        elif instr[0] == 'bne':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3]),17))

        elif instr[0] =='jal':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1]),27))

        elif instr[0] =='jr':
            a = ''.join(c for c in instr[1] if c.isdigit())
            b = str(binary_repr(int(a),6))
            line += opcode[instr[0]]
            line += b[1:6]
            line += str(binary_repr(0,22))

        elif instr[0] == 'blt':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3]),17))

        elif instr[0] =='bex':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1]),27))

        elif instr[0] =='setx':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1]),27))

        elif instr[0] == 'nop':
            line += str(binary_repr(0, 32))

        elif instr[0] == 'beq':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(int(instr[3]),17))

        elif instr[0] == 'led':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(0,17))

        elif instr[0] == 'cap':
            line += opcode[instr[0]]
            line += str(binary_repr(int(instr[1][2:]),5))
            line += str(binary_repr(int(instr[2][2:]),5))
            line += str(binary_repr(0,17))

        # Tests
        elif instr[0] == 'checkreg':
            tests['checkRegister'].append((int(instr[1]), int(instr[2])))

        elif instr[0] == 'cycles':
            tests['cycles'] = instr[1]

        if instr[0] != '#' and instr[0] != 'checkreg' and instr[0] != 'cycles':
            line += ';'
            outputFile.write(line)
            newLine()
            counter += 1
			
        print str(counter - 1) + ":\t" + str(instr)

    except Exception as e:
        print "Syntax Error:", str(instrLine)
        print "Details:", e
        sys.exit()

if counter <= 4096:
    line = '[' + str(counter) + '..' + '4095]' + ':' + str(binary_repr(0,32)) + ';'
    outputFile.write(line)
    newLine()

outputFile.write('END;')


# Write tests to testbench
# try:
#     tb_path = argv[2] + 'processor_tb_auto.v'
# except IndexError:
#     tb_path = '../processor/processor_tb_auto.v'
# print "Testbench file: " + tb_path

# tests_str = ''
# for test_type in tests:
#     if test_type == 'cycles':
#         continue
#     for test in tests[test_type]:
#         sgn = ['-' if t < 0 else '' for t in test]
#         test = [math.fabs(t) for t in test]
#         tests_str += "\t\t%s(%s32\'d%d, %s32\'d%d);\n" % (test_type, sgn[0], test[0], sgn[1], test[1])

# # change file
# with open(tb_path,'w') as tb:
#     for line in open("./processor_tb_base.v"):
#        line = line.replace("CYCLE_LIMIT_AUTO_GENERATE", str(tests['cycles']))
#        tb.write(line)

#     tb.write('\n\ttask performTests; begin\n')
#     tb.write(tests_str)
#     tb.write('\tend endtask\n\n')
#     tb.write('endmodule\n')
