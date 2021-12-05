import math
f = open("a280.txt")
fwrite = open("a280_matrix.txt",'w')
lines = f.readlines()
for linenum1, line1 in enumerate(lines):
    writeln = f"{linenum1+1}=> " + "%{"
    for linenum2, line2 in enumerate(lines):
        if linenum1 == linenum2:
            writeln += f"{linenum1+1}=> 0,"
        else:
            idx1, x1, y1 = line1.split()
            idx2, x2, y2 = line2.split()
            dist = math.sqrt(math.pow(int(x1)-int(x2),2) + math.pow(int(y1)-int(y2),2))
            writeln += f"{idx2}=> {dist},"
    writeln += "},\n"
    fwrite.write(writeln)

f.close()
fwrite.close()
