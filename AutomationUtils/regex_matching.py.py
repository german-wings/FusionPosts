import os
import re


target_location = r"C:\Users\bhava\OneDrive\bhavar@work\Exports\Master"

target_files = []
target_nc_files = []

print("Preparing Building File Arrays")
for (root , dirs , files) in os.walk(target_location):
    for file in files:
        file_path = os.path.join(root , file)
        target_files.append(file_path)


#filtering out only nc and mpf files for working
for file in target_files:
    target_file_name = os.path.basename(file)
    reg_match = re.findall(".nc|.mpf" , target_file_name)
    if(len(reg_match) > 0):
        target_nc_files.append(file)



bucket_list = []
counter = 0
#start reading files line by line
print("Identifying Thread Patterns")
for file in target_nc_files:
    #print(f"Analyzing File :{os.path.basename(file) } of {counter}/{len(target_nc_files)}")
    with open(file , 'r') as file_object:
        lines = file_object.readlines()
        for line in lines:
            reg_ex = line
            reg_match = re.findall("F[1]\.|F[1]\.[0-9]*" , reg_ex)
            if(len(reg_match) > 0):
                print("Match Detected...")
                print(f"SideLine File {os.path.basename(file)} for {line}")
                bucket_list.append(file)
                break
    counter+=1


print(len(bucket_list))



