% PEST routine with looping to find many trials (simulated responses) are required 
% HOW TO : automatically using looping 
%
% 1. Pemanggilan fungsi simulate untuk mendapatkan realThreshold dengan nama "Afifah"
% [~, B] = simulate('Afifah', 50, false);
% realThreshold = B(1);
% 
% 2. run PEST_routine_auto dengan realThreshold sudah terpanggil
% [nTrialsOptimal, estimatedThreshold, confidenceInterval, trialData] = PEST_routine_auto('Afifah', 100, 10000, realThreshold);
% 
% 3. Panggil visualize
% visualize

function [nTrialsOptimal, estimatedThreshold, confidenceInterval, trialData] = PEST_routine_auto(name, range, nMonteCarlo, realThreshold)
    std = range / 5;
    pLgit = zeros(1, range * 2);
    mlgit = zeros(1, range * 2);

    % Inisialisasi untuk logit
    for i = 1:(range * 2)
        lgit = 1 / (1 + exp((range - i) / std));
        pLgit(i) = log(lgit);
        mlgit(i) = log(1 - lgit);
    end

    % Inisialisasi untuk pencarian jumlah trials optimal
    minTrials = 10;
    maxTrials = 200; % needs to estimate the max nTrials, it can be adjusted
    nTrialsOptimal = maxTrials;

    for nTrials = minTrials:maxTrials
        thresholdEstimates = zeros(1, nMonteCarlo);
        trialData = zeros(nMonteCarlo, nTrials); 

        % Simulasi Monte Carlo
        for mc = 1:nMonteCarlo
            m = range;
            prob = zeros(1, range * 2); % Reset probabilitas
            for trial = 1:nTrials
                [response, ~] = simulate(name, m, false);
                r = response * 2 - 1; % Konversi respons

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

                trialData(mc, trial) = m;
            end
            thresholdEstimates(mc) = m;
        end

        % Evaluasi hasil
        estimatedThreshold = mean(thresholdEstimates);
        confidenceInterval = prctile(thresholdEstimates, [2.5, 97.5]);

        % Periksa apakah interval kepercayaan memenuhi kriteria
        lowerBound = realThreshold * 0.95;
        upperBound = realThreshold * 1.05;
        if confidenceInterval(1) >= lowerBound && confidenceInterval(2) <= upperBound
            nTrialsOptimal = nTrials;
            break;
        end
    end
end

