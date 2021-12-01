function k = polygrid(kmin,kmax,N)

    temp = linspace(0,N-1,N)'; %[0:N-1:1]'; % �`�F�r�V�F�t�ɒl�_
    x = -cos((pi/(N-1))*temp);
%     temp = linspace(0,N-1,N)'; %[0:N-1:1]'; % �`�F�r�V�F�t�[���_
%     x = [0; -cos((pi/2/(N-1))*(2*temp - 1))];
    
    % x����k�ɕϊ�
    k = 0.5*(kmax-kmin)*(x+1) + kmin;