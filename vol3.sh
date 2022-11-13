#!/bin/bash
arg1=$1
arg2=$2
#Making the script nice 
#& the user need to know the how to use the tool also the versions of the applications

echo -en "\e[32m" "

    _    _   _    _    _  __   ____________ ____
   / \  | \ | |  / \  | | \ \ / /__  / ____|  _ |
  / _ \ |  \| | / _ \ | |  \ V /  / /|  _| | |_) |
 / ___ \| |\  |/ ___ \| |___| |  / /_| |___|  _ <
/_/   \_\_| \_/_/   \_\_____|_| /____|_____|_| \_] 
"
echo -e "\n"
echo -en "\e[33m""Usage : [mem\hdd] [Filename] "
echo -en "\n"
echo -en "\n"
echo -en "please notice, this analyzer works currently only with
volatility standalone 2.6"
echo -e "\n"
sleep 1
#checking if the user input is true
test -e $arg2
if [ $? = 1 ]
 then
  echo -en "\e[31m" "[Filename] does not exist.. please enter a valid [Filename]" 
   exit
fi
if [[ $arg1 = "HDD" ]] || [[ $arg1 = "hdd" ]] || [[ $arg1 = "HdD" ]] || [[ $arg1 = "hdD" ]] 
	then
	 echo
	  elif [[ $arg1 = "Mem" ]] || [[ $arg1 = "MeM" ]] || [[ $arg1 = "meM" ]] || [[ $arg1 = "MEM" ]] || [[ $arg1 = "mEm" ]] || [[ $arg1 = "mem" ]]
	  then 
	   echo
else
	 echo -en "\e[31m""Usage : [mem\hdd] [Filename]
 please type hdd or mem" && exit
fi
#need to know if the user have the right tools in the machine
#here i check if the file exist if true , continue
test -e $arg2
if [ $? = 0 ]
 then
  echo -en "\e[34m" "Do you have these installed in your machine? 
 [*] Binwalk
 [*] Foremost
 [*] Volatility (2.6 standalone -ONLY-, other versions may not work..)
 [*] strings
 [*] Bulk_extractor"
  echo -e "\n" 
  echo -en "\e[32m" 	"1.Yes (continue)"		
  echo -e "\n"
  echo -en "\e[31m"	"2.No (install)" 
  echo -en "\e[34m" 
  echo -en "\n"
fi
#if the user does not have the applications installed then, install, if he has them installed then continue
#all the output of the installation is outputed to /dev/null, except the colatility install, because it may take some time and i dont want the user to worry if the script stopped so i left the output for him to see how much time has left for the procedure.
read arg3
if [[ $arg3 == @(1|Yes|yes|y|YES|yeah|1.) ]] 
	then 
	echo 
	 elif [[ $arg3 == @(2|No|no|n|NO|neh|2.) ]] 
	 then 
echo "installing .." && echo -e "\n" && sudo apt install binwalk -y 1> /dev/null 2> /dev/null && echo "Binwalk installed" && sudo apt install foremost -y 1> /dev/null 2> /dev/null && echo " Foremost installed " && wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip && unzip volatility_2.6_lin64_standalone.zip 2> /dev/null 1> /dev/null 
else
echo -en "\e[31m" "invalid input, please run the script again.. " && sleep 1 && exit
fi 
#starting to analyze the wanted file
echo -e "\n" 
echo -en "\e[34m" "Analyzing $arg2 ..."
echo -en "\n"
rm -r $arg1 2> /dev/null
mkdir -p $arg1
echo -en "\e[34m" "
[*] Running foremost..
"
#here i redirect all the output to /dev/null for the script to be clean and readable (and also pretty) also the output is going to a new dir that is $arg1
#i thought maybe the user will eventualy run the script a couple of times with the same $arg1 and evry time the script was stopped in the middle or some what it would cause  mess and unwanted pile-up of files and dirs..
foremost -i $arg2 -o ./$arg1/foremost 2> /dev/null
echo "[*] Running Bulk_extractor.."
cd $arg1 ; mkdir Bulk_results ; cd .. 
bulk_extractor -o $arg1/Bulk_results $arg2 1> /dev/null
echo "[*] Running volatility.."
./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $arg2 imageinfo --output-file=./$arg1/volatility_imageinf  > /dev/null 2> /dev/null ; ./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $arg2 pslist --output-file=./$arg1/volatility_pslist > /dev/null 2> /dev/null ; ./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $arg2 connscan --output-file=./$arg1/volatility_connscan > /dev/null 2> /dev/null ; ./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $arg2 getsids --output-file ./$arg1/volatility_SID > /dev/null 2> /dev/null ; ./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $arg2 privs --output-file ./$arg1/volatility_privs > /dev/null 2> /dev/null
echo "[*] Running Binwalk.."
binwalk $arg2 > ./$arg1/Binwalk_analysis
echo "[*] Running Strings.."
strings $arg2 > ./$arg1/strings
echo "Analyzer done."
sleep 0.5
echo -en "\e[33m" "The case is ready.."
sleep 1
echo "here are some analysis"
echo -en "\e[37m" 
cat ./$arg1/Binwalk_analysis
echo -en "\n"
sleep 3
echo "--------------------------------"
echo "--------------------------------"
cat ./$arg1/volatility_imageinf
sleep 3 
echo "--------------------------------"
echo "--------------------------------"
echo -en "\n"
cat ./$arg1/volatility_pslist
echo -en "\n"
echo "================================"
echo "================================"
echo -en "\n"
echo -en "\e[34m""These are the results"
echo -en "\n"
echo -en "\e[33m"
cd ./$arg1/
ls -x
sleep 1
echo -en "\n"
echo -en "\e[34m""for more results please go to /$arg1 directory "
echo -en "\n"
echo -en "\n"
echo -en "\e[33m""notice, if you decide to run the script again with the same first argument,
youre current results will be deleated..
so i think saving these results would be the best."
#i notified the user
## _______________
#< By_student_S2 >
# ---------------
#        \   ^__^
#         \  (oo)\_______
#            (__)\       )\/\
#                ||----w |
#                ||     ||
#-----------------------------------
















