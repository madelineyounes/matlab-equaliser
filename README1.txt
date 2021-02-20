Madeline Mariam Younes(z5208494)
ELEC3104 Project checkpoint 1 
Orignal Due date 28/10/2020 extension given to 4/11/2020
Submitted 30/10/2020

The main code is in the file 'PartA_B.m', DFT function called within the 
main file is in the file 'DFT.m'.Audiofiles tested must be in the same 
directory and the Audio Library which contains the function 
audioDeviceReader() is needed to utilise the mic. 

The Paramaters 'tres' and 'fwinSize' can be changed within the code to 
modify the time and frequency resoltion respectively. Running the program 
will prompt asking for the file name in 'file.wav' format, then ask if to 
process it in realtime or not. In the case where the gains are adjusted in
realtime 

EXAMPLE NORMAL OPERATION 1
PROMPT: Would you like to use the mic as audio input [y/n]?:
INPUT: n
PROMPT: Enter the file name in form of [filename.wav]: 
INPUT: chirp.wav
PROMPT: Do you wish to process in realtime [y/n]?: 
INPUT: n 
OUPUT: figure(1) with energy displayed 
PROGRAM END

EXAMPLE NORMAL OPERATION 2
PROMPT: Would you like to use the mic as audio input [y/n]?:
INPUT: y
OUPUT: figure(1) with energy displayed and refreshing
INPUT: Ctrl+C
PROGRAM END


