function fig = plot_series_pub(vars, varargin)
%PLOT_SERIES_PUB  从 Dynare 的 oo_/M_ 输出绘制顶刊级别的时间序列/模拟/过渡路径图。
%
%   plot_irfs_pub 的姊妹脚本：IRF 之外的"序列型"产出统一用它出图——随机模拟序列
%   (stoch_simul periods>0)、完全预见过渡路径(perfect_foresight)、或任何 [endo×T] 路径。
%   排版与 plot_irfs_pub 一致："变量=子图、情景=同图叠线"，tiledlayout 紧排、无边框、
%   配色与线型同时变化(黑白可辨)、矢量 PDF 导出。run 脚本应**调用本脚本**，而不是内联 plot。
%
%   读数来源：oo_.<Source>，默认 'endo_simul'（[endo_nbr×T] 矩阵）。stoch_simul 的模拟序列
%   与 perfect_foresight 的过渡路径都落在 oo_.endo_simul，故同一接口通吃。
%
%   用法（最简）：跑完模型后 oo_/M_ 在基础工作区，直接：
%       plot_series_pub({'y','c','k'});
%
%   居中显示（减稳态看偏离；配 Scale=100 看百分比偏离）：
%       plot_series_pub({'y','c'}, 'Center','ss', 'Scale',100, 'Save','fig_sim');
%
%   多情景对比（同变量叠线，黑白可辨）：
%       plot_series_pub({'y','c'}, 'Scenarios',{ooA,ooB}, ...
%                       'ScenarioNames',{'Baseline','Reform'}, 'Save','fig_transition');
%
%   不带参数运行用合成数据画一张演示图，便于即时检查风格：
%       plot_series_pub
%
% 主要参数（名-值对）：
%   'oo_' / 'M_'      Dynare 结构体；缺省从基础工作区读取。
%   'Source'          oo_ 中存放 [endo×T] 路径的字段名。默认 'endo_simul'。
%   'Scenarios'       cell，{oo_1, oo_2, ...}，多模型/多设定对比（每个一条线）。
%   'ScenarioNames'   cell，对应图例名称。
%   'Center'          'none'(默认,画原始水平) | 'ss'(减稳态 oo_.steady_state) | 'mean'(减样本均值)。
%   'Scale'           乘子，默认 1（水平）；Center='ss' 看百分比偏离时配 100。
%   'Time'            自定义横轴向量；默认 1:T。
%   'Horizon'         画多少期，默认全长。
%   'Layout'          [nrows ncols]，默认按变量数自动接近正方形。
%   'Titles'          cell，自定义子图标题；缺省用 long_name / LaTeX 名。
%   'YLabel'/'XLabel' 缺省按 Center 自动选（'Level'/'Percent dev. from SS' ... / 'Period'）。
%   'Save'            文件名(无后缀)；'Formats' 默认 {'pdf'}，可加 'eps'/'png'。
%   'Font'/'FontSize' 默认 'Helvetica' / 9。
%   'Grid'            默认 false。'ZeroLine' 缺省按 Center 自动（居中时画 0 线）。
%   'Colors'/'LineStyles'/'LineWidth'  覆盖默认样式。
%   'FigSize'         [宽 高]（厘米），缺省按 Layout 估算。
%
% 返回：figure 句柄。
%
% 兼容性：tiledlayout/exportgraphics/yline 需 MATLAB R2020a+；更老版本自动回退到
% subplot + print + 手画零线（风格略降级但可用）。

% ----------------------------------------------------------------------
% 0. 无参演示
% ----------------------------------------------------------------------
if nargin == 0
    [vars, oo1, oo2, demo_M] = local_demo_data();
    varargin = {'oo_', oo1, 'M_', demo_M, ...
                'Scenarios', {oo1, oo2}, ...
                'ScenarioNames', {'Baseline','Reform'}};
end

% ----------------------------------------------------------------------
% 1. 参数解析
% ----------------------------------------------------------------------
if ischar(vars) || isstring(vars), vars = cellstr(vars); end

p = inputParser;
p.addParameter('oo_', []);
p.addParameter('M_',  []);
p.addParameter('Source',        'endo_simul');
p.addParameter('Scenarios',     {});
p.addParameter('ScenarioNames', {});
p.addParameter('Center',        'none');   % 'none' | 'ss' | 'mean'
p.addParameter('Scale',         1);
p.addParameter('Time',          []);
p.addParameter('Horizon',       []);
p.addParameter('Layout',        []);
p.addParameter('Titles',        {});
p.addParameter('Interpreter',   'auto');
p.addParameter('YLabel',        '');       % 空 = 按 Center 自动
p.addParameter('XLabel',        'Period');
p.addParameter('Save',          '');
p.addParameter('Formats',       {'pdf'});
p.addParameter('Font',          'Helvetica');
p.addParameter('FontSize',      9);
p.addParameter('Grid',          false);
p.addParameter('ZeroLine',      []);       % 空 = 居中时自动开
p.addParameter('Colors',        []);
p.addParameter('LineStyles',    {'-','--',':','-.'});
p.addParameter('LineWidth',     1.6);
p.addParameter('FigSize',       []);
p.parse(varargin{:});
o = p.Results;

% oo_ / M_ 缺省从基础工作区取（带容错）
if isempty(o.oo_) && isempty(o.Scenarios)
    o.oo_ = evalin('base','oo_');
end
if isempty(o.M_)
    try, o.M_ = evalin('base','M_'); catch, o.M_ = struct(); end
end
M_ = o.M_;
if ~isfield(M_,'endo_names'), M_.endo_names = {}; end

% Center 相关的默认（YLabel / ZeroLine）
ctr = lower(o.Center);
if isempty(o.YLabel)
    switch ctr
        case 'ss',   if o.Scale==100, o.YLabel = 'Percent dev. from SS'; else, o.YLabel = 'Dev. from SS'; end
        case 'mean', o.YLabel = 'Dev. from mean';
        otherwise,   o.YLabel = 'Level';
    end
end
if isempty(o.ZeroLine), o.ZeroLine = ~strcmp(ctr,'none'); end

% 多情景：把主 oo_ 也纳入情景列表
if ~isempty(o.Scenarios), scen = o.Scenarios; else, scen = {o.oo_}; end
nScen = numel(scen);

% 图例名
if ~isempty(o.ScenarioNames)
    seriesNm = o.ScenarioNames;
elseif nScen > 1
    seriesNm = arrayfun(@(j)sprintf('Scenario %d',j), 1:nScen, 'uni',0);
else
    seriesNm = {''};
end

% 默认配色（与 plot_irfs_pub 一致）
if isempty(o.Colors)
    o.Colors = [0.12 0.24 0.45; 0.80 0.22 0.18; 0.20 0.55 0.35; ...
                0.50 0.38 0.66; 0.85 0.55 0.10; 0.35 0.35 0.35];
end

nv = numel(vars);
if isempty(o.Layout)
    nc = ceil(sqrt(nv)); nr = ceil(nv/nc);
else
    nr = o.Layout(1); nc = o.Layout(2);
end
useTiles = exist('tiledlayout','file')==2;

% ----------------------------------------------------------------------
% 2. 绘制（单图：变量=子图、情景=叠线）
% ----------------------------------------------------------------------
fig = figure('Color','w','Units','centimeters');
if isempty(o.FigSize)
    w = max(8, nc*5.0 + 1.2);
    h = max(6, nr*3.8 + 1.4 + (nScen>1)*0.9);
    set(fig,'Position',[2 2 w h]);
else
    set(fig,'Position',[2 2 o.FigSize(1) o.FigSize(2)]);
end
if useTiles
    tl = tiledlayout(fig, nr, nc, 'TileSpacing','compact','Padding','compact');
end

hLeg = gobjects(1, nScen);
for i = 1:nv
    if useTiles, ax = nexttile(tl); else, ax = subplot(nr,nc,i,'Parent',fig); end
    hold(ax,'on');

    if o.ZeroLine
        if exist('yline','file')==2
            yl = yline(ax, 0, '-'); yl.Color = [0.6 0.6 0.6]; yl.LineWidth = 0.5;
            yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
        else
            plot(ax, [0 1e6], [0 0], '-', 'Color',[0.6 0.6 0.6], 'LineWidth',0.5, ...
                 'HandleVisibility','off');
        end
    end

    for k = 1:nScen
        y = local_get_series(scen{k}, M_, vars{i}, o.Source, ctr);
        if isempty(y), continue; end
        H = o.Horizon; if isempty(H), H = numel(y); end
        H = min(H, numel(y));
        if isempty(o.Time), xx = (1:H)'; else, xx = o.Time(1:min(H,numel(o.Time)))'; end
        col = o.Colors(mod(k-1,size(o.Colors,1))+1, :);
        lst = o.LineStyles{mod(k-1,numel(o.LineStyles))+1};
        hl = plot(ax, xx, o.Scale*y(1:H), 'LineStyle',lst, 'Color',col, 'LineWidth',o.LineWidth);
        if i==1, hLeg(k) = hl; end
    end

    local_style_axis(ax, o);

    ttl = local_title(M_, vars{i}, o, i);
    [tstr, tint] = ttl{:};
    title(ax, tstr, 'Interpreter',tint, 'FontWeight','normal', ...
          'FontName',o.Font, 'FontSize',o.FontSize+1);

    isLeftCol   = mod(i-1, nc)==0;
    isBottomRow = (i > nv-nc);
    if isLeftCol,   ylabel(ax, o.YLabel, 'FontName',o.Font,'FontSize',o.FontSize); end
    if isBottomRow, xlabel(ax, o.XLabel, 'FontName',o.Font,'FontSize',o.FontSize); end

    hold(ax,'off');
end

if nScen > 1 && any(~cellfun(@isempty, seriesNm))
    if useTiles && exist('OCTAVE_VERSION','builtin')==0
        lgd = legend(hLeg, seriesNm, 'Orientation','horizontal', ...
                     'FontName',o.Font, 'FontSize',o.FontSize, 'Box','off');
        try, lgd.Layout.Tile = 'south'; catch, end
    else
        legend(hLeg, seriesNm, 'Box','off', 'FontName',o.Font, ...
               'FontSize',o.FontSize, 'Location','best');
    end
end

if ~isempty(o.Save)
    local_export(fig, o.Save, o.Formats);
end
end % ===== 主函数结束 =====


% ======================================================================
% 子函数
% ======================================================================
function y = local_get_series(oo, M_, var, srcField, ctr)
% 从 oo_.<srcField>（[endo×T]）取变量 var 的整条路径，按 ctr 做居中。
y = [];
if ~isfield(oo, srcField) || isempty(oo.(srcField)), return; end
names = cellstr(M_.endo_names);
idx = find(strcmp(names, var), 1);
if isempty(idx), return; end
M = oo.(srcField);
if idx > size(M,1), return; end
y = M(idx, :).';
switch ctr
    case 'ss'
        if isfield(oo,'steady_state') && idx <= numel(oo.steady_state)
            y = y - oo.steady_state(idx);
        end
    case 'mean'
        y = y - mean(y);
end
end

% ----------------------------------------------------------------------
function out = local_title(M_, var, o, i)
% 返回 {字符串, interpreter}。优先 Titles，其次 LaTeX 名，再 long_name，最后变量名。
if ~isempty(o.Titles) && numel(o.Titles) >= i && ~isempty(o.Titles{i})
    out = {o.Titles{i}, local_pick_interp(o.Interpreter,'none')}; return;
end
names = cellstr(M_.endo_names);
idx = find(strcmp(names, var), 1);
tex = ''; lng = '';
if ~isempty(idx)
    if isfield(M_,'endo_names_tex')
        t = M_.endo_names_tex; if iscell(t), tex = t{idx}; else, tex = strtrim(t(idx,:)); end
    end
    if isfield(M_,'endo_names_long')
        l = M_.endo_names_long; if iscell(l), lng = l{idx}; else, lng = strtrim(l(idx,:)); end
    end
end
if ~isempty(tex)
    out = {['$' tex '$'], local_pick_interp(o.Interpreter,'latex')};
elseif ~isempty(lng) && ~strcmp(lng, var)
    out = {lng, local_pick_interp(o.Interpreter,'none')};
else
    out = {var, local_pick_interp(o.Interpreter,'none')};
end
end

function intp = local_pick_interp(userInterp, autoChoice)
if strcmpi(userInterp,'auto'), intp = autoChoice; else, intp = userInterp; end
end

% ----------------------------------------------------------------------
function local_style_axis(ax, o)
set(ax, 'FontName',o.Font, 'FontSize',o.FontSize, 'Box','off', ...
        'TickDir','out', 'TickLength',[0.015 0.015], 'LineWidth',0.6, ...
        'Layer','top', 'XColor',[0.15 0.15 0.15], 'YColor',[0.15 0.15 0.15]);
if o.Grid
    grid(ax,'on'); set(ax,'GridAlpha',0.12, 'GridLineStyle',':');
else
    grid(ax,'off');
end
end

% ----------------------------------------------------------------------
function local_export(fig, base, formats)
for k = 1:numel(formats)
    fmt = lower(formats{k});
    fn  = [base '.' fmt];
    try
        if exist('exportgraphics','file')==2
            switch fmt
                case 'png', exportgraphics(fig, fn, 'Resolution',300);
                otherwise,  exportgraphics(fig, fn, 'ContentType','vector');
            end
        else
            set(fig,'PaperPositionMode','auto');
            switch fmt
                case 'pdf', print(fig, base, '-dpdf', '-painters');
                case 'eps', print(fig, base, '-depsc', '-painters');
                case 'png', print(fig, base, '-dpng', '-r300');
            end
        end
        fprintf('[plot_series_pub] 已导出 %s\n', fn);
    catch ME
        warning('plot_series_pub:export', '导出 %s 失败：%s', fn, ME.message);
    end
end
end

% ----------------------------------------------------------------------
function [vars, oo1, oo2, M] = local_demo_data()
% 合成两情景的过渡路径，用于无参演示。
T = 40; t = (0:T-1)';
vars = {'y','c','k'};
path = @(ss,amp,p) ss + amp*(1 - exp(-t/p));
mk = @(s) [path(1.0,0.10*s,8)'; path(0.7,0.06*s,10)'; path(3.0,0.30*s,12)'];
oo1 = struct('endo_simul', mk(1.0), 'steady_state', [1.0;0.7;3.0]);
oo2 = struct('endo_simul', mk(1.6), 'steady_state', [1.0;0.7;3.0]);
M = struct();
M.endo_names      = {'y';'c';'k'};
M.endo_names_tex  = {'y';'c';'k'};
M.endo_names_long = {'Output';'Consumption';'Capital'};
end
