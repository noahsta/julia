using Plots
using WAV

filename= "92.wav"
y, fs = wavread(filename)

plot(range(1,size(y)[1]), y, label="soundfile")
savefig("sound.png")