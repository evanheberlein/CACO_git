function [velocity, angle] = stiv_angle(A, t, s, skip)
%------------------------------------------------------------------
% stiv_angle Computes the angle and velocity of a STIV image.

% Parameters
%   A       : STIV image. (rows, cols) = (distance, time)
%   t       : Time array.
%   s       : Distance array.
%   skip    : Number of rows to skip in along the distance axis.
%
% Return
%   velocity: Velocity computed from STIV image.
%   angle   : Angle of the STIV lines.
%------------------------------------------------------------------

% Correlate rows.
N = size(A, 1);
row_idx = 1:skip:N-skip;
max_lags = zeros(size(row_idx)-1);
for i = 1:length(row_idx)-1
    % % Taking mean.
    % row1 = mean(Z(row_idx(i):row_idx(i)+skip,:),1);
    % row2 = mean(Z(row_idx(i+1):row_idx(i+1)+skip,:),1);

    % No mean.
    row1 = A(row_idx(i),:);
    row2 = A(row_idx(i+1),:);
    
    % Periodic correlation.
    [r, lags] = xcorr(row1-mean(row1), row2-mean(row2));
    
    % Lag with maximum cross-correlation.
    [~, rmax_idx] = max(r);
    max_lag = lags(rmax_idx);
    max_lags(i) = max_lag;

end

% Compute velocity.
dt = t(-mode(max_lags));
ds = s(skip);
velocity = ds / dt;

% Angle.
angle = rad2deg(atan(velocity));

% Center of image for plotting angle line.
sc = s(floor(length(s) / 2));
tc = t(floor(length(t) / 2));
b = -velocity * tc + sc;

figure()
imagesc(t, s, A)
hold on
plot(t, t .* velocity + b, 'color', 'w', 'linewidth', 1.5)
axis image
% set(gca,'YDir','normal')
ylim([0 10])

end

%% Written by Alex Young 1/28/25