Madeline Mariam Younes(z5208494)
ELEC3104 Project checkpoint 2 
Orignal Due date 19/11/2020 1.15pm
Submitted 19/11/2020 11.00am

The main code is in the file 'PartC_D_E.m', DFT function called within the 
main file is in the file 'DFT.m' and the filter function is in the file 
'Filt.m'. Audiofiles tested must be in the same directory and output will be 
stored in a file output.wav in the same directory . 

The Paramaters for the filters can be changed with in the the code, 
specifically to adjust the channel frequency ranges the upper and lower 
frequencies are set using the paramters 'wu','wl'. Running the program will 
prompt asking for the file name in 'file.wav' format, then ask if to 
process it in realtime or not. A window with sliders to adjust the channel 
gains will open. In the case where the gains are adjusted in realtime the 
sliders can be moved and adjusted while the file is processed a rough 
preview of the sound is played and is visable on the spectrogram style plot. 
Although, the live output is very chopping, so it is recommended to listen 
back the 'output.wav' audio file to assess the changes. In the case where 
the gains are not changed in realtime, the sliders are set to the desired 
gain levels. A prompt asking if the gains have been set will be displayed
once this is confirmed the gains will be applied to the channels, displayed, 
played and saved to the output file.


EXAMPLE NORMAL OPERATION 1
PROMPT: Enter the file name in form of [filename.wav]: 
INPUT: 3-tone-test.wav
PROMPT: Do you wish to process in realtime [y/n]?: 
INPUT: n 
INPUT: gain sliders 
PROMPT: Have you set the gains to the desired outputs[y]?:
INPUT: y
OUPUT: figure(1) with energy displayed 
       sound is played through speakers 
       audiofile output.wav is saved to directory
PROGRAM END