//push constant 7
@7
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D
//push constant 8
@8
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D
// add
//    pop -> R13
@SP
D=M-1
M=D
A=M
D=M
@R13
M=D
//    pop -> R14
@SP
D=M-1
M=D
A=M
D=M
@R14
M=D
//    push R13 + R14
@R13
D=M
@R14
D=D+M
@SP
A=M
M=D
D=A+1
@SP
M=D
