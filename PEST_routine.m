% HOW
% HOW TO: hunting tries attempt manually
%
% 1. Panggil PEST_routine dengan command window dengan nama Afifah
% [estimatedThreshold, confidenceInterval, trialData] = PEST_routine('Afifah', 100, 100, 10000); 
% it can  be 50, 100, etc dan setelah di coba pada nama "Afifah" ada di
% nTrials 100 atau 101
%
% 2. Panggil Visualize
% 
% NOTE:
% Parameters:
% - range: 100, defining the range of stimulus values.
% - nTrials: 100 or 101, trials per simulation, determined manually after hunting. 
%   Found to be sufficient for confidence interval within ±5% of threshold.
% - nMonteCarlo: 10000, total Monte Carlo simulations.


function [estimatedThreshold, confidenceInterval, trialData] = PEST_routine(name, range, nTrials, nMonteCarlo)
    % Inisialisasi
    std = range / 5; % Menentukan slope dari fungsi psikometrik
    % prob = zeros(1, range * 2);
    pLgit = zeros(1, range * 2);
    mlgit = zeros(1, range * 2);

    % Hitung nilai logit
    for i = 1:(range * 2)
        lgit = 1 / (1 + exp((range - i) / std));
        pLgit(i) = log(lgit);
        mlgit(i) = log(1 - lgit);
    end

    % Main program
    thresholdEstimates = zeros(1, nMonteCarlo);

    % Untuk analisis dan visualisasi
    trialData = zeros(nMonteCarlo, nTrials); 

    for mc = 1:nMonteCarlo
        m = range; % Nilai awal stimulus
        prob = zeros(1, range * 2); % Reset probabilitas
        for trial = 1:nTrials
            % Dapatkan respons dari simulateR
            fprintf("Trial %d, Stimulus = %d\n", trial, m); % Menampilkan nilai m
            [response, ~] = simulate(name, m, false);
            r = response * 2 - 1; % Konversi respons ke 1 atau -1

            % Perbarui probabilitas
            maxProb = -Inf;
            p1 = 1; p2 = 1;
            for i = 1:range
                index = range + m - i;
                if index >= 1 && index <= 2 * range
                    if r == 1
                        prob(i) = prob(i) + pLgit(index);
                    else
                        prob(i) = prob(i) + mlgit(index);
                    end

                    if prob(i) > maxProb
                        maxProb = prob(i);
                        p1 = i; p2 = i;
                    elseif prob(i) == maxProb
                        p2 = i;
                    end
                end
            end

            % Hitung nilai stimulus baru
            m = round((p1 + p2) / 2);

            trialData(mc, trial) = m; % Simpan data dari setiap trial
        end
        thresholdEstimates(mc) = m;
    end

    % Hitung ambang batas perkiraan dan interval kepercayaan
    estimatedThreshold = mean(thresholdEstimates);
    confidenceInterval = prctile(thresholdEstimates, [2.5, 97.5]);
end
