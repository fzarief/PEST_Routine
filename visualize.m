% Tampilkan hasil
[R1, B] = simulate('Afifah', 5, false); 
fprintf('Real Threshold: %f\n', B(1));
fprintf('Estimated Threshold: %f\n', estimatedThreshold);
fprintf('Confidence Interval: [%f, %f]\n', confidenceInterval(1), confidenceInterval(2));

% Hitung persentase perbedaan untuk batas bawah dan atas
percent_difference_lower = 100 * abs((confidenceInterval(1) - B(1)) / B(1));
percent_difference_upper = 100 * abs((confidenceInterval(2) - B(1)) / B(1));

% Tampilkan hasil
fprintf('Estimated Threshold: %f\n', estimatedThreshold);
fprintf('Confidence Interval: [%f, %f]\n', confidenceInterval(1), confidenceInterval(2));
fprintf('Percent difference from real threshold (Lower Bound): %f%%\n', percent_difference_lower);
fprintf('Percent difference from real threshold (Upper Bound): %f%%\n', percent_difference_upper);


% Periksa apakah keduanya berada dalam jendela ±5%
if percent_difference_lower <= 5 && percent_difference_upper <= 5
    fprintf('Both bounds of the confidence interval fall within ±5%% of the real threshold.\n');
else
    fprintf('One or both bounds of the confidence interval do not fall within ±5%% of the real threshold.\n');
end

% Tampilkan plotting simulasi ke 9995 sampai 10000
plot(trialData(9995:10000, :)', 'LineWidth', 1.5, 'LineStyle','-.' );
xlabel('Trial Number');
ylabel('Estimated Threshold');
title('Threshold Estimates Over Trials');
legend(arrayfun(@(x) sprintf('Simulation %d', x), 9995:10000, 'UniformOutput', false));
grid on;