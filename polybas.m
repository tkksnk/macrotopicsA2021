function T = polybas(kmin,kmax,Np,kgrid)

    % Np: �������̎���-1
    % Ng: �O���b�h�̐�
    Ng = size(kgrid,1);
    x = (2/(kmax-kmin))*(kgrid-kmin) - 1;
    
    % ���֐��̍s��(NgxNp)���ċA�I�ɋ��߂�
    T = zeros(Ng,Np);
    T0 = ones(Ng,1);
    T1 = x;
    T2 = 2*x.*T1 - T0;
    T(:,1) = T1;
    T(:,2) = T2;
    
    for i=3:Np-1
        T(:,i) = 2*x.*T(:,i-1) - T(:,i-2);
    end
    
    T = [T0 T(:,1:(Np-1))];