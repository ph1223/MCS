vf = open("input.vec","w")
vf.write("RADIX 1 1 1 \n")
vf.write("VNAME pre  WL0  SEN\n")
vf.write("IO I I I\n")
vf.write("tunit ns\n")
vf.write("slope  0.05\n")
vf.write("tdelay 0.0\n")
vf.write("vih 0.7\n")
vf.write("vil 0\n\n")
count = 0
for i in range(10):
    vf.write(str(count*1) + "   \t0 0 0\n")
    vf.write(str(count*1+0.25) + "\t1 1 0\n")
    vf.write(str(count*1+0.5) + " \t1 0 1\n")
    vf.write(str(count*1+0.75) + "\t1 0 1\n")
    count+=1
vf.close()