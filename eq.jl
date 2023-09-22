using Plots
using WAV
using FFTW
using DSP.Windows
using LinearAlgebra

function short_time_fourier(y::Array, i::Integer, audio_length::Integer, window_length::Integer)
    radius = div(window_length,2)+1
    if i >= radius && i < audio_length-radius
        y = y[i-radius+1:i+radius]
    elseif i <= radius-1
        overlap = radius-2-i
        y = y[1:i+radius]
        y = append!(zeros(overlap), y)
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

eq = @animate for i in 1:882:audio_length
    frequencies = short_time_fourier(y[:,1], i, audio_length, window_length)
    plot(20:10000, frequencies[20:10000], ylimits=[-250,250], xaxis=:log, yaxis=:log)
end
gif(eq, "eq.gif", fps=50)