using Plots
using PlotThemes
using WAV
using FFTW
using DSP.Windows
using LinearAlgebra

function short_time_fourier(y::Array, i::Integer, audio_length::Integer, window_length::Integer)
    radius = div(window_length,2)
    if i <= radius-1
        overlap = radius-i
        y = y[1:i+radius]
        y = append!(zeros(overlap), y)
    elseif i >= radius && i < audio_length-radius
        y = y[i-radius+1:i+radius]
    else
        overlap = i-audio_length+radius
        y = y[i-radius:end]
        y = append!(y, zeros(overlap))
    end
    return real(rfft(y.*hanning(window_length, padding=0, zerophase=false)))
end

filename= "92.wav"
y, fs = wavread(filename)
window_length = 44100

audio_length = size(y)[1]

start = 1
stop = 1000000
step = 882

spectrogram = zeros(length(start:step:stop), div(window_length,2)+1)
Threads.@threads  for i in start:step:stop
    spectrogram[div(i-start,step)+1,:] = short_time_fourier(y[:,1], i, audio_length, window_length)
end

eq = @animate for i in 1:div(stop-start,step)
    theme(:dark)
    plot(20:div(window_length,2)+1, spectrogram[i, 20:end], ylimits=[-500,500], xaxis=:log, yaxis=:log, grid=false, ticks=false)
end
gif(eq, "eq.gif", fps=50)