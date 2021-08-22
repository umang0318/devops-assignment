grep all files with the class details, print the name of the student along with there class

~/
|- class_details
    |-class1.txt
	|-class2.txt
	|-class3.txt

Content of files (example class1.txt)
Name          City          Phone
Ram           Nodia         9875346723
Shyam         Delhi         9875352424
Ved           Pune          9875378353
Umang         Banglore      9875343167


Script-----------------------------------------------
#!/bin/bash
dir = '/home/ubuntu/class_details'
cd $dir
ls | grep "class*" | xargs awk '{print FILENAME,$1}' | grep -v "Name"