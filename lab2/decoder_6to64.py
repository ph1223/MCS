import math

num_addr = 4

def vector():
    vf = open("input.vec","w")
    vf.write("RADIX 1 1 1 1 1 1 1\n")
    vf.write("VNAME clk Addr[5] Addr[4] Addr[3] Addr[2] Addr[1] Addr[0]\n")
    vf.write("IO I I I I I I I\n")
    vf.write("tunit ns\n")
    vf.write("slope  0.05\n")
    vf.write("tdelay 0.0\n")
    vf.write("vih 0.7\n")
    vf.write("vil 0\n\n")
    count = 0
    for i in range(64):
        vf.write(str(count*1) + "\t\t" + "0 " + ("0 " if (int)(i/32)%2 == 0 else "1 ")
                    + ("0 " if (int)(i/16)%2 == 0 else "1 ") + ("0 " if (int)(i/8)%2 == 0 else "1 ")
                    + ("0 " if (int)(i/4)%2 == 0 else "1 ") + ("0 " if (int)(i/2)%2 == 0 else "1 ")
                    + ("0 " if i%2 == 0 else "1 ") +"\n")
        vf.write(str(count*1+0.5) + " \t" + "1 " + ("0 " if (int)(i/32)%2 == 0 else "1 ")
                    + ("0 " if (int)(i/16)%2 == 0 else "1 ") + ("0 " if (int)(i/8)%2 == 0 else "1 ") 
                    + ("0 " if (int)(i/4)%2 == 0 else "1 ") + ("0 " if (int)(i/2)%2 == 0 else "1 ") + ("0 " if i%2 == 0 else "1 ") +"\n")
        count+=1

    vf.close()
    

################################
#-------------CMOS-------------#
################################
def INV(file):
    string = ".subckt inverter vin vout\n"\
            "M1 vout  vin  GND   x  nmos_sram\tm=1\n"\
            "M2 vout  vin  VDD   x  pmos_sram\tm=1\n"\
            ".ends\n\n"\
            ".subckt inv_chain vin vout\n"\
            "X1 vin net0 inverter\n"\
            "x2 net0 vout inverter\n"\
            ".ends\n\n"
    file.write( string )

number_mos = 3
number_node = 0

def NAND(file,num_addr):
    global number_mos,number_node
    string = ".subckt nand_"+str(num_addr)
    str1 = ""
    for i in range(num_addr):
        str1 = str1 + "\tin" + str(i) + "\t"
    string = string + str1 +  "\tout\n"
    
    str1 = ""
    for i in range(num_addr):
        if i==0:
            str1 = str1 + "M"+str(number_mos)+"\t" + "n" + str(number_node)+"\tin"+str(i) + "\tGND" + "\tx\tnmos_sram\tm=1\n"
            number_node = number_node + 1
        elif i==(num_addr-1):
            str1 = str1 + "M"+str(number_mos)+"\t" + "out"+"\tin"+str(i) + "\t" + "n" + str(i-1) + "\tx\tnmos_sram\tm=1\n"
        else:
            str1 = str1 + "M"+str(number_mos)+"\t" + "n" + str(number_node) + "\tin"+str(i) + "\t" + "n" + str(number_node-1) + "\tx\tnmos_sram\tm=1\n"
            number_node = number_node + 1
        number_mos = number_mos + 1
            
    string = string + str1
    str1 = ""
    for i in range(num_addr):
        str1 = str1 + "M"+str(number_mos)+"\tout"+"\tin"+str(i)+"\tVDD" +"\tx\tpmos_sram\tm=1\n"
        number_mos = number_mos + 1
    string = string + str1 + ".ends\n\n"
    file.write(string)
    

def AND(file,num_addr):
    global number_node
    string = ".subckt and_"+str(num_addr)
    str1 = ""
    for i in range(num_addr):
        str1 = str1 + "\tin" + str(i) + "\t"
    string = string + str1 +  "out\n"

    string = string + "x3" + str1 + "n" + str(number_node) + "\tnand_"+str(num_addr)+"\n"
    string = string + "x4\t" + "n" + str(number_node) +"\tout\tinverter\n"
    number_node = number_node + 1
    string = string + ".ends\n\n"
    file.write(string)

number_sub = 5 

def decoder_3to8(file):
    global number_node
    global number_sub
    string = ".subckt decoder_3to8"
    str1 = ""
    for i in range(3):
        str1 = str1 + "\tin" + str(i) + "\t"
    string = string + str1
    str1 = ""
    for i in range(8):
        str1 = str1 + "\tout" + str(i)
    string = string + str1 +  "\ten\n"
    str1 = ""
    for i in range(3):
        str1 = str1 + "x" + str(number_sub) + "\tin" + str(i) + "\t" + "n" + str(number_node) +"\tinverter\n"
        number_sub = number_sub + 1
        number_node = number_node + 1
    number_node = number_node - 3
    string = string + str1
    str1 = ""
    for i in range(8):
        str1 = str1 + "x" +  str(number_sub) + "\t" + ("n" + str(number_node) if i%2 == 0 else "in" + str(0))\
        + ( "\tn" + str(number_node+1) if (int)(i/2)%2 == 0 else "\tin" + str(1)) \
        + ("\tn" + str(number_node+2)  if (int)(i/4)%2 == 0 else "\tin" + str(2)) + "\ten\t" + "out" + str(i) + "\tand_4\n"
        number_sub = number_sub + 1 
    string = string + str1

    string = string + ".ends\n\n"
    file.write(string)

def decoder_6to64(file):
    global number_sub
    string = ".subckt decoder_6to64"
    str1 = ""
    for i in range(6):
        str1 = str1 + "\tin" + str(i) + "\t"
    string = string + str1
    str1 = ""
    for i in range(64):
        str1 = str1 + "\tout" + str(i)
    string = string + str1 +  "\ten\n"
    str1 = ""
    for i in range(8):
        str1 = str1 + "x" + str(number_sub) + "\tin0\tin1\tin2"  + "".join([ ("\tout" + str(i*8+j) ) for j in range(8) ]) + "\ten" + str(i) + "\tdecoder_3to8\n"
        number_sub = number_sub + 1
    string = string + str1
    str1 = ""
    for i in range(1):
        str1 = str1 + "x" +  str(number_sub) + "\tin3\tin4\tin5"  + "".join([ ("\ten" + str(i+j) ) for j in range(8) ]) +  "\ten\tdecoder_3to8\n"
        number_sub = number_sub + 1 
    string = string + str1

    string = string + ".ends\n\n"
    file.write(string)

def init(file,num_addr):
    file.write(".TITLE  Decoder\n\n")
    file.write(".protect\n"\
             ".include '/RAID2/COURSE/mcs/mcs020/Technology_files/7nm_TT.pm'\n"\
             ".unprotect\n\n")
    file.write(".vec 'input.vec'\n\n")
    file.write(".global VDD GND\n")
    #NAND_2(file)
    INV(file)
    NAND(file,num_addr)
    AND(file,num_addr)
    decoder_3to8(file)
    decoder_6to64(file)
    

def circuit_construct(file):
    string = ""
    str1 = ""
    for i in range(6):
        str1 = str1 + "Xin"+ str(i) + "\tAddr" + "[" + str(i) + "]" + "\tin_i" + "[" + str(i) + "]"  + "\tinv_chain\n"
    string = string + str1 +"\n"

    str1 = ""
    for i in range(1):
        str1 = str1 + "Xx"+ str(i) + "\t" + "".join([ ("\tin_i" + "[" + str(j) + "]") for j in range(6) ]) \
                    + "".join([ ("\tWL" + "[" + str(j) + "]") for j in range(64) ]) + "\tclk\tdecoder_6to64\n"
    string = string + str1 +"\n"

    str1 = ""
    for i in range(64):
        str1 = str1 + "C"+ str(i) + "\tWL" + "[" + str(i) + "]\t" + "GND\t" + "22.2592a\n"
    string = string + str1 +"\n"

    file.write(string)

        
##########################        
#---------main-----------#
##########################

fo = open("decoder_6to64.sp", "w")
vector()
init(fo,num_addr)
circuit_construct(fo)
fo.write("Vvdd VDD GND dc 0.7v\n\n"\
         ".op\n"\
         ".option post     \n"\
         ".options probe   \n"\
         ".probe v(*) i(*) \n"\
         ".option captab   \n"\
         ".tran 0.01ns 70ns\n\n")
fo.write(".measure TRAN pwr avg power\n"\
         ".TEMP 25\n\n"\
         ".end\n")
fo.close()