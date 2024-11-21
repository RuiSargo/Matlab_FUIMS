function path = get_path2(beacons)
    %
    %  path = get_path2(beacons)
    %
    % Função para adquirir graficamente pontos de spline e calcular
    % um caminho ajustado que pode incluir loops ou voltar em x.
    %
    % Inputs:
    % - beacons: 2xN matriz de localizações (x,y) dos beacons
    % Outputs:
    % - path: 2xM matriz de pontos (x,y) do caminho interpolado
    %

    % Inicializar o ambiente gráfico
    globals;
    figure(PLAN_FIG);
    clf;
    axis([0 WORLD_SIZE 0 WORLD_SIZE]);
    hold on;
    plot(beacons(:, 1), beacons(:, 2), 'go'); % Plotar os beacons

    % Variáveis para armazenar pontos
    pin = 1;
    npoints = 0;
    points = zeros(2, 1);
    xi=[];

    % Obter pontos de entrada gráficos
    while pin
        [x, y] = ginput(1);
        pin = ~isempty(x);
        if pin
            npoints = npoints + 1;
            plot(x, y, 'rx'); % Mostrar ponto selecionado
            points(1, npoints) = x;
            points(2, npoints) = y;
        end
    end

    % Calcular o comprimento do arco dos pontos
    diffs = diff(points, 1, 2); % Diferenças entre pontos consecutivos
    segment_lengths = sqrt(sum(diffs.^2, 1)); % Comprimento de cada segmento
    arc_lengths = [0, cumsum(segment_lengths)]; % Comprimento acumulado

    % Interpolação usando comprimento do arco
    num_interp_points = 10000; % Número de pontos para interpolação
    s_interp = linspace(0, arc_lengths(end), num_interp_points); % Comprimento interpolado    
    xi = interp1(arc_lengths, points(1, :), s_interp, 'spline'); % Interpolar x
    yi = interp1(arc_lengths, points(2, :), s_interp, 'spline'); % Interpolar y

    % Plotar o caminho interpolado
    plot(xi, yi, 'r');

    % Gerar a saída no formato solicitado
    path = [xi; yi];
    hold off;
end
