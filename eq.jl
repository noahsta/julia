using Plots
using WAV
using FFTW
using DSP.Windows
using LinearAlgebra

function hann_filter(index::Integer, signal_length::Integer, filter_length::Integer)
    hann_function = hanning(filter_length, padding=0, zerophase=false)
    hann_filter = zeros(signal_length)
    peak = div(filter_length, 2)
    if index <= peak
        cutoff = peak-index
        hann_filter[1:index+peak] = hann_function[cutoff+1:end]
    elseif index > peak && index <= signal_length - peak
        hann_filter[index-peak:index+peak-1] = hann_function
    else
        cutoff = peak + index - signal_length - 1
        hann_filter[index-peak:end] = hann_function[1:end-cutoff]
    end
    return hann_filter
end


filename= "92.wav"
y, fs = wavread(filename)

y = y[1000000:1000:1100000]

audio_length = size(y)[1]

short_time_fourier = zeros(audio_length, audio_length)

for i in range(1, audio_length)
    fourier = real.(fft(y[1,:].*hann_filter(i, audio_length, 100)))
    short_time_fourier[i,:] = fourier
end
heatmap(1:audio_length,1:audio_length,short_time_fourier)   
savefig("sound.png")