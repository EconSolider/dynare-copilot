function fig = plot_irfs_pub(vars, shocks, varargin)
%PLOT_IRFS_PUB  从 Dynare 的 oo_/M_ 输出绘制顶刊级别的脉冲响应(IRF)图。
%
%   读取 stoch_simul 写入的 oo_.irfs.<变量>_<冲击>，按"变量=子图、情景/冲击=同图叠线"
%   的方式排版。默认风格对标 AER/JME/Econometrica：tiledlayout 紧排、零线、无边框、
%   极淡或无网格、配色与线型同时变化（保证黑白打印下可区分）、矢量 PDF 导出。
%
%   用法（最简）：跑完 stoch_simul 后，oo_/M_ 已在基础工作区，直接：
%       plot_irfs_pub({'y','c','invest','l'}, 'eps_z');
%
%   多情景对比（同一组变量、同一冲击，叠加多条线）：
%       plot_irfs_pub({'y','pi','r'}, 'eps_a', ...
%           'Scenarios',     {oo_base, oo_alt}, ...
%           'ScenarioNames', {'Baseline','Sticky wages'}, ...
%           'Save', 'fig_irf_techshock');
%
%   多冲击叠加在同一张图（每个子图里按冲击着色）：
%       plot_irfs_pub({'y','c'}, {'eps_a','eps_g'}, 'OverlayShocks', true);
%
%   不带参数运行会用合成数据画一张演示图，便于即时检查风格：
%       plot_irfs_pub
%
% 主要参数（名-值对）：
%   'oo_' / 'M_'      Dynare 结构体；缺省从基础工作区读取。
%   'Scenarios'       cell，{oo_1, oo_2, ...}，多模型/多设定对比（每个一条线）。
%   'ScenarioNames'   cell，对应图例名称。
%   'OverlayShocks'   true 时把多个冲击叠在同一张图（互斥于 Scenarios）。默认 false。
%   'Bands'           置信带，仅单情景单冲击时生效。{lower, upper}，各为 H×nv 或
%                     struct，字段名 <var>_<shock>。两段时给嵌套 cell：
%                     {{l68,u68},{l90,u90}}（外宽内窄，深浅两层灰）。
%   'Scale'           IRF 乘子，默认 100（小数偏离 → 百分比）。levels 变量设为 1。
%   'Horizon'         画多少期，默认全长。
%   'Layout'          [nrows ncols]，默认按变量数自动接近正方形。
%   'Titles'          cell，自定义子图标题；缺省用 long_name / LaTeX 名。
%   'YLabel'/'XLabel' 默认 'Percent dev. from SS' / 'Quarters'。
%   'Save'            文件名(无后缀)；'Formats' 默认 {'pdf'}，可加 'eps'/'png'。
%   'Font'/'FontSize' 默认 'Helvetica' / 9。
%   'Grid'/'ZeroLine' 默认 false / true。
%   'Colors'/'LineStyles'/'LineWidth'  覆盖默认样式。
%   'FigSize'         [宽 高]（厘米），缺省按 Layout 估算。
%
% 返回：figure 句柄（OverlayShocks 或单冲击为单图；多冲击分图时返回最后一张）。
%
% 兼容性：tiledlayout/exportgraphics/yline 需 MATLAB R2020a+。更老版本自动回退到
% subplot + print + 手画零线（风格略降级但可用）。

% ----------------------------------------------------------------------
% 0. 无参演示
% ----------------------------------------------------------------------
if nargin == 0
    [vars, shocks, oo1, oo2, demo_M] = local_demo_data();
    varargin = {'oo_', oo1, 'M_', demo_M, ...
                'Scenarios', {oo1, oo2}, ...
                'ScenarioNames', {'Baseline','Low persistence'}};
end

% ----------------------------------------------------------------------
% 1. 参数解析
% ----------------------------------------------------------------------
if nargin < 2 || isempty(shocks), shocks = {}; end
if ischar(vars) || isstring(vars),   vars   = cellstr(vars);   end
if ischar(shocks) || isstring(shocks), shocks = cellstr(shocks); end

p = inputParser;
p.addParameter('oo_', []);
p.addParameter('M_',  []);
p.addParameter('Scenarios',     {});
p.addParameter('ScenarioNames', {});
p.addParameter('OverlayShocks', false);
p.addParameter('Bands',         {});
p.addParameter('Scale',         100);
p.addParameter('Horizon',       []);
p.addParameter('Layout',        []);
p.addParameter('Titles',        {});
p.addParameter('Interpreter',   'auto');   % 'auto' | 'latex' | 'tex' | 'none'
p.addParameter('YLabel',        'Percent dev. from SS');
p.addParameter('XLabel',        'Quarters');
p.addParameter('Save',          '');
p.addParameter('Formats',       {'pdf'});
p.addParameter('Font',          'Helvetica');
p.addParameter('FontSize',      9);
p.addParameter('Grid',          false);
p.addParameter('ZeroLine',      true);
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
% M_ 不全时补默认字段，标题回退到变量名/冲击名
if ~isfield(M_,'endo_names'), M_.endo_names = {}; end
if ~isfield(M_,'exo_names'),  M_.exo_names  = {}; end

% 多情景：把主 oo_ 也纳入情景列表
if ~isempty(o.Scenarios)
    scen = o.Scenarios;
else
    scen = {o.oo_};
end
nScen = numel(scen);

% 变量/冲击缺省推断
if isempty(vars) || isempty(shocks)
    [iv, ish] = local_infer(scen{1}, M_);
    if isempty(vars),   vars   = iv;  end
    if isempty(shocks), shocks = ish; end
end
nv = numel(vars);

% 默认配色：深→浅、冷暖交替，色盲友好且黑白可辨（配合线型）
if isempty(o.Colors)
    o.Colors = [0.12 0.24 0.45;    % 海军蓝
                0.80 0.22 0.18;    % 砖红
                0.20 0.55 0.35;    % 墨绿
                0.50 0.38 0.66;    % 紫
                0.85 0.55 0.10;    % 琥珀
                0.35 0.35 0.35];   % 灰
end

% ----------------------------------------------------------------------
% 2. 决定"图"与"叠线"的维度
% ----------------------------------------------------------------------
% 叠线维度(series)：OverlayShocks 时为各冲击；否则为各情景。
% 分图维度(figures)：OverlayShocks 时单图；否则每个冲击一张图。
if o.OverlayShocks
    figLoop  = {[]};            % 单图
    seriesNm = shocks;
    seriesGet = @(k, sh, vr) local_get(scen{1}, vr, shocks{k});
    nSeries  = numel(shocks);
else
    figLoop  = shocks;
    if ~isempty(o.ScenarioNames)
        seriesNm = o.ScenarioNames;
    elseif nScen > 1
        seriesNm = arrayfun(@(j)sprintf('Scenario %d',j), 1:nScen, 'uni',0);
    else
        seriesNm = {''};
    end
    seriesGet = @(k, sh, vr) local_get(scen{k}, vr, sh);
    nSeries  = nScen;
end

% 子图网格
if isempty(o.Layout)
    nc = ceil(sqrt(nv)); nr = ceil(nv/nc);
else
    nr = o.Layout(1); nc = o.Layout(2);
end

useTiles = exist('tiledlayout','file')==2;
fig = [];

% ----------------------------------------------------------------------
% 3. 逐图绘制
% ----------------------------------------------------------------------
for f = 1:numel(figLoop)
    sh = figLoop{f};

    fig = figure('Color','w','Units','centimeters');
    if isempty(o.FigSize)
        w = max(8, nc*5.0 + 1.2);
        h = max(6, nr*3.8 + 1.4 + (nSeries>1)*0.9);
        set(fig,'Position',[2 2 w h]);
    else
        set(fig,'Position',[2 2 o.FigSize(1) o.FigSize(2)]);
    end

    if useTiles
        tl = tiledlayout(fig, nr, nc, 'TileSpacing','compact','Padding','compact');
    end

    hLeg = gobjects(1, nSeries);   % 收集首个子图的句柄做共享图例

    for i = 1:nv
        if useTiles, ax = nexttile(tl); else, ax = subplot(nr,nc,i,'Parent',fig); end
        hold(ax,'on');

        % --- 置信带（仅单情景单冲击）---
        if ~isempty(o.Bands) && nSeries==1 && ~o.OverlayShocks
            local_draw_bands(ax, o.Bands, vars{i}, sh, o.Scale, o.Horizon);
        end

        % --- 零线 ---
        if o.ZeroLine
            if exist('yline','file')==2
                yl = yline(ax, 0, '-'); yl.Color = [0.6 0.6 0.6]; yl.LineWidth = 0.5;
                yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
            else
                plot(ax, [0 1e6], [0 0], '-', 'Color',[0.6 0.6 0.6], 'LineWidth',0.5, ...
                     'HandleVisibility','off');
            end
        end

        % --- 各 series 曲线 ---
        for k = 1:nSeries
            y = seriesGet(k, sh, vars{i});
            H = o.Horizon; if isempty(H), H = numel(y); end
            if isempty(y), y = zeros(H,1); end
            H = min(H, numel(y));
            xx = (1:H)';
            col = o.Colors(mod(k-1,size(o.Colors,1))+1, :);
            lst = o.LineStyles{mod(k-1,numel(o.LineStyles))+1};
            hl = plot(ax, xx, o.Scale*y(1:H), 'LineStyle',lst, 'Color',col, ...
                      'LineWidth',o.LineWidth);
            if i==1, hLeg(k) = hl; end
        end

        % --- 子图样式 ---
        local_style_axis(ax, o);
        if isempty(o.Horizon)
            Hax = local_irflen(scen{1}, vars{i}, local_anyshock(sh, shocks));
        else
            Hax = o.Horizon;
        end
        xlim(ax, [1, max(2, Hax)]);

        % 标题
        ttl = local_title(M_, vars{i}, o, i);
        [tstr, tint] = ttl{:};
        title(ax, tstr, 'Interpreter',tint, 'FontWeight','normal', ...
              'FontName',o.Font, 'FontSize',o.FontSize+1);

        % 轴标签：仅左列加 Y、仅末行加 X，减少冗余
        isLeftCol   = mod(i-1, nc)==0;
        isBottomRow = (i > nv-nc);
        if isLeftCol,   ylabel(ax, o.YLabel, 'FontName',o.Font,'FontSize',o.FontSize); end
        if isBottomRow, xlabel(ax, o.XLabel, 'FontName',o.Font,'FontSize',o.FontSize); end

        hold(ax,'off');
    end

    % --- 共享图例 ---
    if nSeries > 1 && any(~cellfun(@isempty, seriesNm))
        if useTiles && exist('OCTAVE_VERSION','builtin')==0
            lgd = legend(hLeg, seriesNm, 'Orientation','horizontal', ...
                         'FontName',o.Font, 'FontSize',o.FontSize, 'Box','off');
            try, lgd.Layout.Tile = 'south'; catch, end
        else
            legend(hLeg, seriesNm, 'Box','off', 'FontName',o.Font, ...
                   'FontSize',o.FontSize, 'Location','best');
        end
    end

    % --- 顶部冲击标题（多图、各图一冲击时）---
    if ~o.OverlayShocks && ~isempty(sh) && numel(shocks) > 1
        shttl = local_shock_title(M_, sh);
        if useTiles
            title(tl, shttl, 'Interpreter','none', 'FontName',o.Font, ...
                  'FontSize',o.FontSize+2, 'FontWeight','bold');
        else
            sgtitle(shttl, 'FontName',o.Font, 'FontSize',o.FontSize+2);
        end
    end

    % --- 导出 ---
    if ~isempty(o.Save)
        base = o.Save;
        if ~o.OverlayShocks && numel(shocks) > 1, base = [base '_' sh]; end %#ok<AGROW>
        local_export(fig, base, o.Formats);
    end
end
end % ===== 主函数结束 =====


% ======================================================================
% 子函数
% ======================================================================
function y = local_get(oo, var, shock)
% 取 oo_.irfs.<var>_<shock>；缺失(响应被阈值滤掉或未请求)返回空。
y = [];
if isempty(shock), return; end
fn = [var '_' shock];
if isfield(oo,'irfs') && isfield(oo.irfs, fn)
    y = oo.irfs.(fn)(:);
end
end

% ----------------------------------------------------------------------
function L = local_irflen(oo, var, shock)
% 推断 IRF 长度，给 xlim 用。
y = local_get(oo, var, shock);
if isempty(y), L = 40; else, L = numel(y); end
end

function sh = local_anyshock(curShock, shocks)
if ~isempty(curShock), sh = curShock; elseif ~isempty(shocks), sh = shocks{1}; else, sh=''; end
end

% ----------------------------------------------------------------------
function [vars, shocks] = local_infer(oo, M_)
% 从 oo_.irfs 字段名结合 M_.exo_names 反推变量与冲击集合。
vars = {}; shocks = {};
if ~isfield(oo,'irfs'), return; end
fns = fieldnames(oo.irfs);
exol = cellstr(M_.exo_names);
% 按长度降序匹配最长后缀，避免短冲击名误匹配
[~, ord] = sort(cellfun(@numel, exol), 'descend');
exol = exol(ord);
for j = 1:numel(fns)
    fn = fns{j};
    for e = 1:numel(exol)
        suf = ['_' exol{e}];
        if numel(fn) > numel(suf) && strcmp(fn(end-numel(suf)+1:end), suf)
            vars{end+1}   = fn(1:end-numel(suf)); %#ok<AGROW>
            shocks{end+1} = exol{e};              %#ok<AGROW>
            break;
        end
    end
end
vars   = unique(vars,   'stable');
shocks = unique(shocks, 'stable');
end

% ----------------------------------------------------------------------
function out = local_title(M_, var, o, i)
% 返回 {字符串, interpreter}。优先自定义 Titles，其次 LaTeX 名，再 long_name，最后变量名。
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
function s = local_shock_title(M_, shock)
% 冲击的 long_name 做图标题；无则用冲击名。
s = shock;
names = cellstr(M_.exo_names);
idx = find(strcmp(names, shock), 1);
if ~isempty(idx) && isfield(M_,'exo_names_long')
    l = M_.exo_names_long;
    if iscell(l), cand = l{idx}; else, cand = strtrim(l(idx,:)); end
    if ~isempty(cand) && ~strcmp(cand, shock), s = cand; end
end
end

% ----------------------------------------------------------------------
function local_draw_bands(ax, Bands, var, shock, scale, H)
% 画置信带(灰色阴影)。Bands 可为 {lower,upper} 或 {{l1,u1},{l2,u2}}（两段宽窄）。
if isempty(Bands), return; end
if ~iscell(Bands{1}), Bands = {Bands}; end   % 统一成段的列表
greys = [0.78 0.78 0.78; 0.62 0.62 0.62];     % 外宽浅、内窄深
for b = 1:numel(Bands)
    seg = Bands{b};
    lo = local_band_series(seg{1}, var, shock);
    hi = local_band_series(seg{2}, var, shock);
    if isempty(lo) || isempty(hi), continue; end
    if isempty(H), H = numel(lo); end
    H = min([H numel(lo) numel(hi)]);
    xx = (1:H)';
    g = greys(min(b,size(greys,1)), :);
    pa = patch(ax, [xx; flipud(xx)], scale*[lo(1:H); flipud(hi(1:H))], g, ...
               'EdgeColor','none', 'FaceAlpha',0.55);
    pa.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
end

function v = local_band_series(B, var, shock)
% 带数据可为 struct(字段 <var>_<shock>) 或直接向量。
v = [];
if isstruct(B)
    fn = [var '_' shock];
    if isfield(B, fn), v = B.(fn)(:); end
elseif isnumeric(B)
    v = B(:);
end
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
        fprintf('[plot_irfs_pub] 已导出 %s\n', fn);
    catch ME
        warning('plot_irfs_pub:export', '导出 %s 失败：%s', fn, ME.message);
    end
end
end

% ----------------------------------------------------------------------
function [vars, shocks, oo1, oo2, M] = local_demo_data()
% 合成两情景、一冲击的 RBC 风格 IRF，用于无参演示。
H = 20; t = (0:H-1)';
vars = {'y','c','invest','l'}; shocks = {'eps_z'};
shape = @(a,b,p) a*exp(-t/p) .* (1 + b*sin(t/3));
mk = @(s,p0) struct('y_eps_z',      s*shape(1.0,0.0,6*p0), ...
                    'c_eps_z',      s*shape(0.5,0.0,9*p0), ...
                    'invest_eps_z', s*shape(3.0,0.2,4*p0), ...
                    'l_eps_z',      s*shape(0.4,0.1,5*p0));
oo1 = struct('irfs', mk(1.00, 1.0));    % 基准
oo2 = struct('irfs', mk(0.95, 0.6));    % 低持续性对比
M = struct();
M.endo_names      = {'y';'c';'invest';'l'};
M.endo_names_tex  = {'y';'c';'i';'\ell'};
M.endo_names_long = {'Output';'Consumption';'Investment';'Hours'};
M.exo_names       = {'eps_z'};
M.exo_names_long  = {'Technology shock'};
end
