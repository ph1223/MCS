fo = open("sram.txt", "w")

string = ""
str1 = ""

for i in range(512):
    if i%16 == 0:
        str1 = str1 +"\n"
    str1 = str1 + "X"+ str(i) + "  \tWLL\tBL\tBLB\tSRAM\n"
    
                
string = string + str1 +"\n"

fo.write(string)
fo.close()