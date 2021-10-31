function resid = resid_two_period(a)

global w beta gamma rent

% 1期の限界効用
if w - a > 0.0
    mu1 = mu_CRRA(w - a, gamma);
else
    % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
    mu1 = 10000.0;
end

% 2期の限界効用
mu2 = mu_CRRA((1.0+rent)*a, gamma);

% 残差
resid = beta*(1.0+rent)*(mu2/mu1) - 1.0;