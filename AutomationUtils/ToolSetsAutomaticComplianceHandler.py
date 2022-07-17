

'''

Purpose of this Script

To Identify and filter bad and too long names containing from Fusion Tool Lists
To Standardize naming conventions of the Tools based on its Type Dia Category

Download the File paste is next to this python file
Run the Script 
It will show what has been changed and generate a new tool sets file
upload that file on fusion and use it.

'''

def contains_bad_words(tool_name):
    for word in filter_words:
        if(word in tool_name):
            return True


import json
from random import uniform

filename = "Shakti Enterprise Milling & Turning Tool Sets.json"

new_tools = []
filter_words = ["FLOW","FLOWDRILL","SHORT","TUNGALOY","TAEGU","TEC","FLATE","HIGH FEED","HIGH","FEED","REVERSED/","ATUM","ISCAR","SANDVIK","U DRILL","GARR","HITACHI-EDMT","JDMT","HITACHI-JDMT"]

with open(filename , "r") as rf:
    tool_set_file = json.load(rf)


for tools in tool_set_file['data']:

    tool_name = str(tools['description']).upper()
    print("\n**************EVALUATING "+tool_name)

    if(contains_bad_words(tool_name)):
        #yes contains bad words
        print("FILTERING OUT BAD WORDS "+ tool_name)
        print("Passing " + tools['description'])
        new_tool_profile = tools
        new_tools.append(new_tool_profile)
        pass

    else:
        if(tools["type"] == "flat end mill"):
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_material = tools["BMC"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"{tool_material} ENDMILL {tool_dia}MM".upper()
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        
        elif(tools['type'] == "drill"):
            tool_drill_angle = tools["geometry"]["SIG"]
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_material = tools["BMC"]
            new_tool_profile = tools

            if(tool_drill_angle != 118):
                #this is a special type of tool
                print("Passing " + tools['description'])
                new_tool_profile = tools
                new_tools.append(new_tool_profile)
                pass
            elif(tool_drill_angle == 118):
                #this is a regular drill
                new_tool_profile['description'] = f"{tool_material} DRILL {tool_dia}MM".upper()
                print("Adding "+new_tool_profile['description'])
                new_tools.append(new_tool_profile)
            if(tool_drill_angle == 180):
                new_tool_profile['description'] = f"{tool_material} FLAT DRILL {tool_dia}MM".upper()
                print("Adding "+new_tool_profile['description'])
                new_tools.append(new_tool_profile)

        elif(tools['type'] == "tap right hand"):
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_pitch = tools["geometry"]["TP"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"RIGHT HAND TAP M{tool_dia } X {tool_pitch}MM".upper()
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)
        
        elif(tools['type'] == "tap left hand"):
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_pitch = tools["geometry"]["TP"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"RIGHT HAND TAP M{tool_dia} X {tool_pitch}MM".upper()
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        elif(tools['type'] == "bull nose end mill"):
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_corner_radii = round(tools["geometry"]["RE"],2)
            tool_material = tools["BMC"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"{tool_material} BULL ENDMILL {tool_dia}MM R{tool_corner_radii}".upper()
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        elif(tools['type'] == "ball end mill"):
            tool_dia = round(tools["geometry"]["DC"],2)
            tool_material = tools["BMC"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"{tool_material} FULL BALL ENDMILL {tool_dia}MM".upper()
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        elif(tools['type'] == "tapered mill"):
            if(tools['tapered-type'] == "tapered_bull_nose"):
                tool_dia = round(tools["geometry"]["DC"],2)
                tool_corner_radii = round(tools["geometry"]["RE"],2)
                tool_taper_angle = round(tools["geometry"]["TA"],2)
                tool_material = tools["BMC"]
                new_tool_profile = tools
                new_tool_profile['description'] = f"{tool_material} TAPER ENDMILL D{tool_dia} R{tool_corner_radii} - {tool_taper_angle}DEGREES".upper()
                print("Adding "+new_tool_profile['description'])
                new_tools.append(new_tool_profile)
            elif(tools['tapered-type'] == "tapered_ball"):
                tool_dia = round(tools["geometry"]["DC"],2)
                tool_corner_radii = round(tools["geometry"]["RE"],2)
                tool_taper_angle = round(tools["geometry"]["TA"],2)
                tool_material = tools["BMC"]
                new_tool_profile = tools
                new_tool_profile['description'] = f"{tool_material} TAPER ENDMILL D{tool_dia} R{tool_corner_radii} - {tool_taper_angle}DEGREES".upper()
                print("Adding "+new_tool_profile['description'])
                new_tools.append(new_tool_profile)

        

        elif(tools['type'] == "turning general"):
            insert_standard_code = {'0':'N','7':'C','5':'B'}
            tool_ic = round(tools["geometry"]["INSD"],0)
            tool_corner_radii = round(tools["geometry"]["RE"],2)
            insert_bottom_relief = insert_standard_code[str(tools["geometry"]["RA"])]
            insert_tolearance_class = tools["geometry"]["TC"]
            insert_screw_type = tools["geometry"]["SCTY"]
            insert_size_code = tools["geometry"]["SC"]
            new_tool_profile = tools
            new_tool_profile['description'] = f"OD TURN {insert_size_code}{insert_bottom_relief}{insert_tolearance_class}{insert_screw_type} - R{tool_corner_radii}"
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        elif(tools['type'] == "turning boring"):
            insert_standard_code = {'0':'N','7':'C','5':'B'}
            boring_bar_incl = {"boring bar p" : 'P' , "boring bar l" : 'L' , "boring bar f" : 'F' , "boring bar q" : "Q" , "boring bar u" : "U",
            "boring bar k" : "K" , "boring bar j" : "J" , "custom" : "X"}
            tool_ic = round(tools["geometry"]["INSD"],0)
            tool_corner_radii = round(tools["geometry"]["RE"],2)
            insert_bottom_relief = insert_standard_code[str(tools["geometry"]["RA"])]
            insert_tolearance_class = tools["geometry"]["TC"]
            insert_screw_type = tools["geometry"]["SCTY"]
            insert_size_code = tools["geometry"]["SC"]
            holder_size = tools["holder"]["W"]
            holder_style = boring_bar_incl[tools["holder"]["THSC"]]
            dmin = tools["holder"]['CW'] + (holder_size/2)
            new_tool_profile = tools
            new_tool_profile['description'] = f"ID BORE {holder_size}MM Holder Type {holder_style} {insert_size_code}{insert_bottom_relief}{insert_tolearance_class}{insert_screw_type} - R{tool_corner_radii} DMIN {dmin}"
            print("Adding "+new_tool_profile['description'])
            new_tools.append(new_tool_profile)

        
        
        else:
            print("Passing " + tools['description'])
            new_tool_profile = tools
            new_tools.append(new_tool_profile)



print("Beginning Duplicate Checks")

unique_new_tools = []

for items in new_tools:
    if items not in unique_new_tools:
        unique_new_tools.append(items)

    else:
        print(f"{items['description']} already present")


new_tools = unique_new_tools


tool_data = {}
tool_data['data'] = new_tools

length_of_input_data = len(tool_set_file['data'])
length_of_modified_data = len(tool_data['data'])

print(f'\nLength of Input File Data {length_of_input_data} & Length of Output File Data {length_of_modified_data}')

with open("Modified-Shakti Enterprise Milling & Turning Tool Sets.json",'w') as modified_tool_list:
    json.dump(tool_data , modified_tool_list )
    print("Created Modified Tool List")
