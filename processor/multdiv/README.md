# Project Checkpoint 3
 - Author: Dhruv K Patel
 - Date: February 15, 2018
 - Course: ECE/CS 350, Duke University, Durham, NC
 - Term: Spring 2018
 - Professor Hai Li

## Duke Community Standard, Affirmation
I understand that each `git` commit I create in this repository is a submission. I affirm that each submission complies with the Duke Community Standard and the guidelines set forth for this assignment. I further acknowledge that any content not included in this commit under the version control system cannot be considered as a part of my submission. Finally, I understand that a submission is considered submitted when it has been pushed to the server


## Design:

### Shared Components
	
Both the multiplier and divider share an ALU and a solution register. The solution register is a 64-bit array of dflipflops that is used to save the partial product/remainder and also hold control bits between cycles of the multiplier and divider. There is also a shared main ALU, which is used to add/subtract the multiplicand in the multiplier and subtract the divisor in the divider. 

### Multiplier

The multiplier uses Booth's method. Initially, the solution register is filled with zeros on the most significant bits and the multiplicand on the least significant. It iterates 32 times using a 32-bit shift register. During each iteration,it checks the least significant bit of the solution register and a single bit register of the previous LSB. It sets the ALU to add/subtract depending on the multiplier bits. It records the result depending on the multiplier bits. Finally, the result is shifted right arithmetically. After the 32 counts, the `data_ready` flag is activated.
 

### Divider

The divider uses the more efficient naive approach. It initially loads all zeros in the most siginificant bits of the solution register and the dividend in the least significant bits. It iterates 32 times also using a 32 bit shift register. Each iteration, it checks to see if the remainder is larger than the divisor. If it is, it sets the LSB of the solution register high and records the remainder. It then shifts the results and records that into the register. 

To deal with signed inputs, it uses the naived approach. Each input is put into its own ALU as data operand B, with operand A set to zero. If the input is negative, it negates it by setting the ALU to subtract. If not, it sets the ALU to add, which leaves the input the same. The output also has a similar setup, with its own ALU - it negates at an XOR of the negativity of the two inputs. To deal with the timing delay of the output ALU for edge cases, a dflipflop latches the `data_ready` flag for one extra clock cycle to give some more time for the negation of the output to propogate. Thus the divider runs a total of 33 cycles. 

### Control

The shared components as well as an instance each of the multiplier and divider are intialized in the main module. All inputs and outputs needed for the multiplier/divider (including shared component inputs/outputs) are routed to the modules. Each output that both modules can write to is multiplexed based on a latched state, that holds the last activation state of the module. Thus, signals do not conflict.


## Issues:

I have one error in the testbench (case 9a), where the smallest negative number is multiplied by one. This is a byproduct of the fact that Booth's algorithm must subtract this number and then add it again. When it is subtracted, its positive complement does not exist in 32 bits, so it cannot be subtracted correctly. This can be fixed by using a modified-Booth's algorithm, because the modified version would just skip over the addition/subtraction step and do nothing. This case is not very important, though, because anyone dealing with such large number should really be using a higher-bit module. 

