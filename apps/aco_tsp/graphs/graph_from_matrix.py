f = open("gr21.txt")
fwrite = open("gr21_dict.txt",'w')
lines = f.readlines()
for linenum, line in enumerate(lines):
    writeln = f"{linenum+1}=> " + "%{"
    for colnum, num in enumerate(line.split()):
        writeln += f"{colnum+1}=> {num},"
    writeln += "}\n"
    fwrite.write(writeln)

f.close()
fwrite.close()
