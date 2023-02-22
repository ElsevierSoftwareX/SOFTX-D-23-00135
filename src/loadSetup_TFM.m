%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% general panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.flowopt.ax = evalin('base','flowopt.ax'); ax = h.flowopt.ax;
h.flowopt.g  = evalin('base','flowopt.g');
h.V_r        = evalin('base','V_r');
h.NS         = evalin('base','NS');
h.selectedLiquid = evalin('base','selectedLiquid');
h.selectedGas    = evalin('base','selectedGas');
h.flowopt.energy = evalin('base','flowopt.energy');
% --------------------------------------------------------------------- %
if ax == 0
    set(h.gl.rb.planar,'value',1)
else
    set(h.gl.rb.axisymmetric,'value',1)
end
set(h.gl.et.g,'string',num2str(h.flowopt.g/9.81,15))
set(h.gl.et.Vr,'string',num2str(h.V_r,15))
switch h.NS
    case 1
        set(h.gl.rb.NS1,'value',1)
    case 2
        set(h.gl.rb.NS2,'value',1)
    case 3
        set(h.gl.rb.NS3,'value',1)
end
if h.flowopt.energy == 0
    set([h.gl.rb.NS1 h.gl.rb.NS2 h.gl.rb.NS3],'Enable','Off')
else
    set([h.gl.rb.NS1 h.gl.rb.NS2 h.gl.rb.NS3],'Enable','On')
end
str_liq = get(h.gl.pm.liquid,'String');
str_gas = get(h.gl.pm.gas,'String');
if evalin('base','exist(''my_fluids'',''var'')')
    my_fluids = evalin('base','my_fluids');
    fluids = fieldnames(my_fluids);
    for i = 1:size(fluids,1)
        eval([fluids{i} '= my_fluids .' fluids{i} ';'])
        if isfile([tempdir 'my_fluids.mat'])
            save([tempdir 'my_fluids.mat'],fluids{i},'-append')
        else
            save([tempdir 'my_fluids.mat'],fluids{i})
        end
        if isfield(my_fluids.(fluids{i}),'sigma') && max(contains(str_liq,fluids{i}))==0
            str_liq = [fluids{i}; str_liq];
            h.liquid_list = {fluids{i}, h.liquid_list{1:end}};
        elseif ~isfield(my_fluids.(fluids{i}),'sigma') && max(contains(str_gas,fluids{i})) == 0
            str_gas = [fluids{i}; str_gas];
            h.gas_list = {fluids{i}, h.gas_list{1:end}};
        end
    end
    if max(ismember(fluids,h.selectedLiquid)) || max(ismember(fluids,h.selectedGas)) || h.flowopt.energy == 0
        set(h.gl.rb.NS3,'enable','off')
    else
        set(h.gl.rb.NS3,'enable','on')
    end
end
if max(ismember(str_liq,h.selectedLiquid))
    idx = find(ismember(str_liq,h.selectedLiquid));
    set(h.gl.pm.liquid,'Value',idx,'String',str_liq)                
else
    str_liq=[str_liq(1:end-1); h.selectedLiquid; str_liq(end)];
    set(h.gl.pm.liquid,'String',str_liq,'Value',size(str_liq,1)-1);
end
if max(ismember(str_gas,h.selectedGas))
    idx = find(ismember(str_gas,h.selectedGas));
    set(h.gl.pm.gas,'Value',idx,'String',str_gas)
else
    str_gas=[str_gas(1:end-1); h.selectedGas; str_gas(end)];
    set(h.gl.pm.gas,'String',str_gas,'Value',size(str_gas,1)-1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% geometry panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.r_c  = evalin('base','r_c');  set(h.gy.et.rc,'string',num2str(h.r_c*1000,15));
h.r_i  = evalin('base','r_i');  set(h.gy.et.ri,'string',num2str(h.r_i*1000,15));
h.r_o  = evalin('base','r_o');  set(h.gy.et.ro,'string',num2str(h.r_o*1000,15));
h.l_lb = evalin('base','l_lb'); set(h.gy.et.llb,'string',num2str(h.l_lb*1000,15));
h.l_d1 = evalin('base','l_d1'); set(h.gy.et.ld1,'string',num2str(h.l_d1*1000,15));
h.l_d2 = evalin('base','l_d2'); set(h.gy.et.ld2,'string',num2str(h.l_d2*1000,15));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% mesh panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.mesh.r.delta.start = evalin('base','mesh.r.delta_start*100/l_lb');
h.mesh.r.delta.fit   = evalin('base','mesh.r.delta_fit');
h.mesh.r.delta.end   = evalin('base','mesh.r.delta_end');
h.mesh.r.delta.fit(1) = h.mesh.r.delta.fit(1)*100/h.l_lb;
h.mesh.r.delta.fit(2) = h.mesh.r.delta.fit(2)*100/(h.r_o-h.r_i);
h.mesh.r.delta.end(1) = h.mesh.r.delta.end(1)*100/h.l_lb;
h.mesh.r.delta.end(2) = h.mesh.r.delta.end(2)*100/(h.r_o-h.r_i);
h.mesh.r.f           = evalin('base','mesh.r.f_start');
h.mesh.r.f           = [h.mesh.r.f evalin('base','mesh.r.f_end')];
h.mesh.r.sf          = evalin('base','mesh.r.sf');
h.mesh.z.delta.start = evalin('base','mesh.z.delta_start');
h.mesh.z.delta.fit   = evalin('base','mesh.z.delta_fit');
h.mesh.z.delta.end   = evalin('base','mesh.z.delta_end');
h.mesh.z.delta.start(1) = h.mesh.z.delta.start(1)*100/h.l_d1;
h.mesh.z.delta.start(2:3) = h.mesh.z.delta.start(2:3)*100/h.l_lb;
h.mesh.z.delta.fit(1) = h.mesh.z.delta.fit(1)*100/h.l_d1;
h.mesh.z.delta.fit(2) = h.mesh.z.delta.fit(2)*100/h.l_lb;
h.mesh.z.delta.fit(3) = h.mesh.z.delta.fit(3)*100/h.l_d2;
h.mesh.z.delta.end(1:2) = h.mesh.z.delta.end(1:2)*100/h.l_lb;
h.mesh.z.delta.end(3) = h.mesh.z.delta.end(3)*100/h.l_d2;
h.mesh.z.f           = evalin('base','mesh.z.f_start');
h.mesh.z.f           = [h.mesh.z.f evalin('base','mesh.z.f_end(end)')];
h.mesh.z.sf          = evalin('base','mesh.z.sf');
% --------------------------------------------------------------------- %
set(h.mh.et.radialLB.spacing(1),'string',num2str(h.mesh.r.delta.start(1),15))
set(h.mh.et.radialLB.spacing(2),'string',num2str(h.mesh.r.delta.fit(1),15))
set(h.mh.et.radialLB.spacing(3),'string',num2str(h.mesh.r.delta.end(1),15))
set(h.mh.et.radialSG.spacing(1),'string',num2str(h.mesh.r.delta.start(2),15))
set(h.mh.et.radialSG.spacing(2),'string',num2str(h.mesh.r.delta.fit(2),15))
set(h.mh.et.radialSG.spacing(3),'string',num2str(h.mesh.r.delta.end(2),15))
set(h.mh.et.axialSG.spacing(1),'string',num2str(h.mesh.z.delta.start(1),15))
set(h.mh.et.axialSG.spacing(2),'string',num2str(h.mesh.z.delta.fit(1),15))
set([h.mh.et.axialLB.spacing(1) h.mh.et.axialSG.spacing(3)],'string',num2str(h.mesh.z.delta.start(2),15))
set([h.mh.et.axialLB.spacing(2) h.mh.et.axialSG.spacing(4)],'string',num2str(h.mesh.z.delta.fit(2),15))
set([h.mh.et.axialLB.spacing(3) h.mh.et.axialSG.spacing(5)],'string',num2str(h.mesh.z.delta.end(2),15))
set(h.mh.et.axialSG.spacing(6),'string',num2str(h.mesh.z.delta.fit(3),15))
set(h.mh.et.axialSG.spacing(7),'string',num2str(h.mesh.z.delta.end(3),15))
%
set(h.mh.et.radialLB.stretchingC(1),'string',num2str(h.mesh.r.f(1),15))
set(h.mh.et.radialLB.stretchingC(3),'string',num2str(h.mesh.r.f(2),15))
set(h.mh.et.radialSG.stretchingC(1),'string',num2str(h.mesh.r.f(3),15))
set(h.mh.et.radialSG.stretchingC(3),'string',num2str(h.mesh.r.f(4),15))
set(h.mh.et.axialSG.stretchingC(1),'string',num2str(h.mesh.z.f(1),15))
set(h.mh.et.axialSG.stretchingC(2),'string',num2str(h.mesh.z.f(2),15))
set([h.mh.et.axialLB.stretchingC(1) h.mh.et.axialSG.stretchingC(3)],'string',num2str(h.mesh.z.f(2),15))
set([h.mh.et.axialLB.stretchingC(3) h.mh.et.axialSG.stretchingC(5)],'string',num2str(h.mesh.z.f(3),15))
set(h.mh.et.axialSG.stretchingC(6),'string',num2str(h.mesh.z.f(3),15))
set(h.mh.et.axialSG.stretchingC(7),'string',num2str(h.mesh.z.f(4),15))
if h.mesh.r.f(1) == 1
    set(h.mh.rb.radialLB(1).lin,'Value',1);
    set(h.mh.et.radialLB.spacing(1),'enable','off')
else
    if strcmp(h.mesh.r.sf{1},'gp')
        set(h.mh.rb.radialLB(1).gp,'Value',1);
    else
        set(h.mh.rb.radialLB(1).tanh,'Value',1);
    end
    set(h.mh.et.radialLB.spacing(1),'enable','on')
end
if h.mesh.r.f(2) == 1
    set(h.mh.rb.radialLB(3).lin,'Value',1);
    set(h.mh.et.radialLB.spacing(3),'enable','off')
else
    if strcmp(h.mesh.r.sf{1},'gp')
        set(h.mh.rb.radialLB(3).gp,'Value',1);
    else
        set(h.mh.rb.radialLB(3).tanh,'Value',1);
    end
    set(h.mh.et.radialLB.spacing(3),'enable','on')
end
if h.mesh.r.f(3) == 1
    set(h.mh.rb.radialSG(1).lin,'Value',1);
    set(h.mh.et.radialSG.spacing(1),'enable','off')
else
    if strcmp(h.mesh.r.sf{1},'gp')
        set(h.mh.rb.radialSG(1).gp,'Value',1);
    else
        set(h.mh.rb.radialSG(1).tanh,'Value',1);
    end
    set(h.mh.et.radialSG.spacing(1),'enable','on')
end
if h.mesh.r.f(4) == 1
    set(h.mh.rb.radialSG(3).lin,'Value',1);
    set(h.mh.et.radialSG.spacing(3),'enable','off')
else
    if strcmp(h.mesh.r.sf{2},'gp')
        set(h.mh.rb.radialSG(3).gp,'Value',1);
    else
        set(h.mh.rb.radialSG(3).tanh,'Value',1);
    end
    set(h.mh.et.radialSG.spacing(3),'enable','on')
end
if h.mesh.z.f(1) == 1
    set(h.mh.rb.axialSG(1).lin,'Value',1);
    set(h.mh.et.axialSG.spacing(1),'enable','off')
else
    if strcmp(h.mesh.z.sf{1},'gp')
        set(h.mh.rb.axialSG(1).gp,'Value',1);
    else
        set(h.mh.rb.axialSG(1).tanh,'Value',1);
    end
    set(h.mh.et.axialSG.spacing(1),'enable','on')
end
if h.mesh.z.f(2) == 1
    set([h.mh.rb.axialLB(1).lin h.mh.rb.axialSG(3).lin],'Value',1);
    set([h.mh.et.axialLB.spacing(1) h.mh.et.axialSG.spacing(2) h.mh.et.axialSG.spacing(3)],'enable','off')
else
    if strcmp(h.mesh.z.sf{2},'gp')
        set([h.mh.rb.axialLB(1).gp h.mh.rb.axialSG(3).gp],'Value',1);
    else
        set([h.mh.rb.axialLB(1).tanh h.mh.rb.axialSG(3).tanh],'Value',1);
    end
    set([h.mh.et.axialLB.spacing(1) h.mh.et.axialSG.spacing(2) h.mh.et.axialSG.spacing(3)],'enable','on')
end
if h.mesh.z.f(3) == 1
    set([h.mh.rb.axialLB(3).lin h.mh.rb.axialSG(5).lin],'Value',1);
    set([h.mh.et.axialLB.spacing(3) h.mh.et.axialSG.spacing(5) h.mh.et.axialSG.spacing(6)],'enable','off')
else
    if strcmp(h.mesh.z.sf{2},'gp')
        set([h.mh.rb.axialLB(3).gp h.mh.rb.axialSG(5).gp],'Value',1);
    else
        set([h.mh.rb.axialLB(3).tanh h.mh.rb.axialSG(5).tanh],'Value',1);
    end
    set([h.mh.et.axialLB.spacing(3) h.mh.et.axialSG.spacing(5) h.mh.et.axialSG.spacing(6)],'enable','on')
end
if h.mesh.z.f(4) == 1
    set(h.mh.rb.axialSG(7).lin,'Value',1);
    set(h.mh.et.axialSG.spacing(7),'enable','off')
else
    if strcmp(h.mesh.z.sf{3},'gp')
        set(h.mh.rb.axialSG(7).gp,'Value',1);
    else
        set(h.mh.rb.axialSG(7).tanh,'Value',1);
    end
    set(h.mh.et.axialSG.spacing(7),'enable','on')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% equations panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.flowopt.creeping    = evalin('base','flowopt.creeping');
h.flowopt.thermcapcon = evalin('base','flowopt.thermcapcon');
%
set(h.es.cb.stokes,'Value',h.flowopt.creeping)
set(h.es.cb.energy,'value',h.flowopt.energy)
set(h.es.cb.marangoni,'value',h.flowopt.thermcapcon)
if h.flowopt.energy == 1
    set(h.es.cb.energy,'String','On')
    
    % copied from es_bg_energy function
    % set visibility on of everything that is connected to temperature
        % Liquid Bridge - radial Direction
        if h.r_c ~= 0 && strcmp(h.b1.bc.z(1,3),'c')
            set([h.bc.et.radialLB.rc.temperature h.bc.pm.radialLB.rc.temperature h.bc.st.radialLB.rc.temperature],'visible','on')
        end
        % Liquid Bridge - axial Direction
        if strcmp(h.b1.bc.r(1,3),'c')
            set([h.bc.et.axialLB.d1.temperature h.bc.pm.axialLB.d1.temperature h.bc.st.axialLB.d1.temperature],'visible','on')
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b1.bc.r(2,3),'c')
            set([h.bc.et.axialLB.d2.temperature h.bc.pm.axialLB.d2.temperature h.bc.st.axialLB.d2.temperature],'visible','on')
        end
        % Surrounding Gas - radial Direction
        if strcmp(h.b2.bc.z(1,3),'c')
            set([h.bc.et.radialSG.d1.temperature h.bc.pm.radialSG.d1.temperature h.bc.st.radialSG.d1.temperature],'visible','on')
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b2.bc.z(3,3),'c')
            set([h.bc.et.radialSG.d2.temperature h.bc.pm.radialSG.d2.temperature h.bc.st.radialSG.d2.temperature],'visible','on')
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b2.bc.z(4,3),'c')
            set([h.bc.et.radialSG.ro.temperature h.bc.pm.radialSG.ro.temperature h.bc.st.radialSG.ro.temperature],'visible','on')
        end
        % Surrounding Gas - axial Direction
        if strcmp(h.b2.bc.r(1,3),'c')
            set([h.bc.et.axialSG.d1.temperature h.bc.pm.axialSG.d1.temperature h.bc.st.axialSG.d1.temperature],'visible','on')
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b2.bc.r(2,3),'c')
            set([h.bc.et.axialSG.d2.temperature h.bc.pm.axialSG.d2.temperature h.bc.st.axialSG.d2.temperature],'visible','on')
        end

    % change radio buttons that are connected to temperature
        % Liquid Bridge - radial Direction
        if h.r_c ~= 0
            if strcmp(h.b1.bc.z(1,3),'c')
                set(h.bc.rb.radialLB.rc.adiabatic,'Value',0,'Enable','on')
                set(h.bc.rb.radialLB.rc.conductive,'Value',1,'Enable','on')
            else
                set(h.bc.rb.radialLB.rc.adiabatic,'Value',1,'Enable','on')
                set(h.bc.rb.radialLB.rc.conductive,'Value',0,'Enable','on')
            end
        end
        % ---------------------------------------------------------- %
        set([h.bc.rb.radialLB.ri.conductive h.bc.rb.axialLB.d1.adiabatic h.bc.rb.axialLB.d1.conductive h.bc.rb.axialLB.d2.adiabatic h.bc.rb.axialLB.d2.conductive h.bc.rb.radialSG.d1.adiabatic h.bc.rb.radialSG.d1.conductive h.bc.rb.radialSG.d2.adiabatic h.bc.rb.radialSG.d2.conductive h.bc.rb.radialSG.ro.adiabatic h.bc.rb.radialSG.ro.conductive h.bc.rb.axialSG.d1.adiabatic h.bc.rb.axialSG.d1.conductive h.bc.rb.axialSG.d2.adiabatic h.bc.rb.axialSG.d2.conductive],'Enable','on')
        set(h.bc.rb.radialLB.ri.conductive,'Value',1)
        % Liquid Bridge - axial Direction
        if strcmp(h.b1.bc.r(1,3),'c')
            set(h.bc.rb.axialLB.d1.conductive,'Value',1)
        else
            set(h.bc.rb.axialLB.d1.adiabatic,'Value',1)
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b1.bc.r(2,3),'c')
            set(h.bc.rb.axialLB.d2.conductive,'Value',1)
        else
            set(h.bc.rb.axialLB.d2.adiabatic,'Value',1)
        end
        % Surrounding Gas - radial Direction
        if strcmp(h.b2.bc.z(1,3),'c')
            set(h.bc.rb.radialSG.d1.conductive,'Value',1)
        else
            set(h.bc.rb.radialSG.d1.adiabatic,'Value',1)
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b2.bc.z(3,3),'c')
            set(h.bc.rb.radialSG.d2.conductive,'Value',1)
        else
            set(h.bc.rb.radialSG.d2.adiabatic,'Value',1)
        end
        % ---------------------------------------------------------- %
        if strcmp(h.b2.bc.z(4,3),'c')
            set(h.bc.rb.radialSG.ro.conductive,'Value',1)
        else
            set(h.bc.rb.radialSG.ro.adiabatic,'Value',1)
        end
        % Surrounding Gas - axial Direction
        if strcmp(h.b2.bc.r(1,3),'c')
            set(h.bc.rb.axialSG.d1.conductive,'Value',1)
        else
            set(h.bc.rb.axialSG.d1.adiabatic,'Value',1)
        end
        % ------------------------------------------------------ %
        if strcmp(h.b2.bc.r(2,3),'c')
            set(h.bc.rb.axialSG.d2.conductive,'Value',1)
        else
            set(h.bc.rb.axialSG.d2.adiabatic,'Value',1)
        end
else
    set(h.es.cb.energy,'String','Off')
    
    % copied from es_bg_energy function
    % set visibility off of everything that is connected to temperature
        set([h.bc.et.radialLB.rc.temperature h.bc.pm.radialLB.rc.temperature h.bc.st.radialLB.rc.temperature h.bc.et.axialLB.d1.temperature h.bc.pm.axialLB.d1.temperature h.bc.st.axialLB.d1.temperature h.bc.et.axialLB.d2.temperature h.bc.pm.axialLB.d2.temperature h.bc.st.axialLB.d2.temperature h.bc.et.radialSG.d1.temperature h.bc.pm.radialSG.d1.temperature h.bc.st.radialSG.d1.temperature h.bc.et.radialSG.d2.temperature h.bc.pm.radialSG.d2.temperature h.bc.st.radialSG.d2.temperature h.bc.et.radialSG.ro.temperature h.bc.pm.radialSG.ro.temperature h.bc.st.radialSG.ro.temperature h.bc.et.axialSG.d1.temperature h.bc.pm.axialSG.d1.temperature h.bc.st.axialSG.d1.temperature h.bc.et.axialSG.d2.temperature h.bc.pm.axialSG.d2.temperature h.bc.st.axialSG.d2.temperature],'visible','off')
        cla(h.bc.as.radialLB.rc(2),'reset'); set(h.bc.as.radialLB.rc(2),'visible','off')
        cla(h.bc.as.axialLB.d1(2),'reset'); set(h.bc.as.axialLB.d1(2),'visible','off')
        cla(h.bc.as.axialLB.d2(2),'reset'); set(h.bc.as.axialLB.d2(2),'visible','off')
        cla(h.bc.as.radialSG.d1(2),'reset'); set(h.bc.as.radialSG.d1(2),'visible','off')
        cla(h.bc.as.radialSG.d2(2),'reset'); set(h.bc.as.radialSG.d2(2),'visible','off')
        cla(h.bc.as.radialSG.ro(2),'reset'); set(h.bc.as.radialSG.ro(2),'visible','off')
        cla(h.bc.as.axialSG.d1(2),'reset'); set(h.bc.as.axialSG.d1(2),'visible','off')
        cla(h.bc.as.axialSG.d2(2),'reset'); set(h.bc.as.axialSG.d2(2),'visible','off')

    % change radio buttons that are connected to temperature
        set([h.bc.rb.radialLB.rc.adiabatic h.bc.rb.radialLB.rc.conductive h.bc.rb.axialLB.d1.adiabatic h.bc.rb.axialLB.d1.conductive h.bc.rb.radialLB.ri.conductive h.bc.rb.axialLB.d2.adiabatic h.bc.rb.axialLB.d2.conductive h.bc.rb.radialSG.d1.adiabatic h.bc.rb.radialSG.d1.conductive h.bc.rb.radialSG.d2.adiabatic h.bc.rb.radialSG.d2.conductive h.bc.rb.radialSG.ro.adiabatic h.bc.rb.radialSG.ro.conductive h.bc.rb.axialSG.d1.adiabatic h.bc.rb.axialSG.d1.conductive h.bc.rb.axialSG.d2.adiabatic h.bc.rb.axialSG.d2.conductive],'Value',0,'Enable','off')
end
set(h.es.cb.marangoni,'Enable',get(h.es.cb.energy,'String'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% boundary conditions panel %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = h.flowopt.ax + 1; rx = 'xr'; zy = 'yz';
%
h.b1.bc.z = evalin('base','b1.bc.z');
h.b1.bc.r = evalin('base','b1.bc.r');
h.b2.bc.z = evalin('base','b2.bc.z');
h.b2.bc.r = evalin('base','b2.bc.r');
if h.r_c == 0
    h.b1.bc.z = ['a   '; h.b1.bc.z{2}];
else
    h.b1.bc.z = [[h.b1.bc.z{1} ' ']; h.b1.bc.z{2}];
end
h.b1.bc.r = [h.b1.bc.r{1}; h.b1.bc.r{2}];
h.b2.bc.z = [h.b2.bc.z{1}; '   '; h.b2.bc.z{3}; h.b2.bc.z{4}];
h.b2.bc.r = [h.b2.bc.r{1}; h.b2.bc.r{2}];
%
h.b1.bc.rhs.T.z = evalin('base','b1.bc.rhs.T.z');
h.b1.bc.rhs.T.r = evalin('base','b1.bc.rhs.T.r');
h.b2.bc.rhs.T.z = evalin('base','b2.bc.rhs.T.z');
h.b2.bc.rhs.T.r = evalin('base','b2.bc.rhs.T.r');
h.b2.bc.rhs.w.r = evalin('base','b2.bc.rhs.w.r');
%
if strcmp(h.b1.bc.r(1,2),'s')
    set(h.bc.rb.axialLB.d1.slip,'Value',1)
else
    set(h.bc.rb.axialLB.d1.noSlip,'Value',1)
end
%
if strcmp(h.b1.bc.r(2,2),'s')
    set(h.bc.rb.axialLB.d2.slip,'Value',1)
else
    set(h.bc.rb.axialLB.d2.noSlip,'Value',1)
end
%
if strcmp(h.b2.bc.z(1,2),'s')
    set(h.bc.rb.radialSG.d1.slip,'Value',1)
else
    set(h.bc.rb.radialSG.d1.noSlip,'Value',1)
end
%
if strcmp(h.b2.bc.z(3,2),'s')
    set(h.bc.rb.radialSG.d2.slip,'Value',1)
else
    set(h.bc.rb.radialSG.d2.noSlip,'Value',1)
end
%
if strcmp(h.b2.bc.z(4,2),'s')
    set(h.bc.rb.radialSG.ro.slip,'Value',1)
else
    set(h.bc.rb.radialSG.ro.noSlip,'Value',1)
end
%
switch h.b1.bc.z(2,2)
    case 's'
        set(h.bc.rb.radialLB.ri.dynamic,'Value',1)
    case 'i'
        set(h.bc.rb.radialLB.ri.static,'Value',1)
    case 'r'
        set(h.bc.rb.radialLB.ri.rigid,'Value',1)
end
%
str_func = h.b1.bc.rhs.T.r{1};
func = str2func(str_func);
[h.T_d1l, flg] = str2num(str_func(5:end)); %#ok<*ST2NM>
if strcmp(h.b1.bc.r(1,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.axialLB.d1.adiabatic,'value',1)
    cla(h.bc.as.axialLB.d1(2),'reset'); set(h.bc.as.axialLB.d1(2),'visible','off')
    set([h.bc.et.axialLB.d1.temperature h.bc.pm.axialLB.d1.temperature h.bc.st.axialLB.d1.temperature],'visible','off')
else
    set(h.bc.rb.axialLB.d1.conductive,'value',1)
    set([h.bc.et.axialLB.d1.temperature h.bc.pm.axialLB.d1.temperature h.bc.st.axialLB.d1.temperature],'visible','on')
    if flg == 0
        h.T_d1l = integral(@(r)func(r).*r.^ax,h.r_c,h.r_i)*2/(h.r_i^2-h.r_c^2);
        set(h.bc.pm.axialLB.d1.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'r','x');
        end
        set(h.bc.et.axialLB.d1.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.axialLB.d1.temperature,'value',1)
        set(h.bc.et.axialLB.d1.temperature,'string',num2str(h.T_d1l,15))
    end
end
h.temperature.rc_d1 = func(h.r_c);
h.temperature.ri_d1 = func(h.r_i);
%
str_func = h.b1.bc.rhs.T.r{2};
func = str2func(str_func);
[h.T_d2l, flg] = str2num(str_func(5:end));
if strcmp(h.b1.bc.r(2,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.axialLB.d2.adiabatic,'value',1)
    cla(h.bc.as.axialLB.d2(2),'reset'); set(h.bc.as.axialLB.d2(2),'visible','off')
    set([h.bc.et.axialLB.d2.temperature h.bc.pm.axialLB.d2.temperature h.bc.st.axialLB.d2.temperature],'visible','off')
else
    set(h.bc.rb.axialLB.d2.conductive,'value',1)
    set([h.bc.et.axialLB.d2.temperature h.bc.pm.axialLB.d2.temperature h.bc.st.axialLB.d2.temperature],'visible','on')
    if flg == 0
        h.T_d2l = integral(@(r)func(r).*r.^ax,h.r_c,h.r_i)*2/(h.r_i^2-h.r_c^2);
        set(h.bc.pm.axialLB.d2.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'r','x');
        end
        set(h.bc.et.axialLB.d2.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.axialLB.d2.temperature,'value',1)
        set(h.bc.et.axialLB.d2.temperature,'string',num2str(h.T_d2l,15))
    end
end
h.temperature.rc_d2 = func(h.r_c);
h.temperature.ri_d2 = func(h.r_i);
h.delta_T = h.T_d1l-h.T_d2l;
h.T_0     = (h.T_d1l+h.T_d2l)/2;
%
str_func = h.b2.bc.rhs.T.r{1};
func = str2func(str_func);
[h.T_p1, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.r(1,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.axialSG.d1.adiabatic,'value',1)
    cla(h.bc.as.axialSG.d1(2),'reset'); set(h.bc.as.axialSG.d1(2),'visible','off')
    set([h.bc.et.axialSG.d1.temperature h.bc.pm.axialSG.d1.temperature h.bc.st.axialSG.d1.temperature],'visible','off')
else
    set(h.bc.rb.axialSG.d1.conductive,'value',1)
    set([h.bc.et.axialSG.d1.temperature h.bc.pm.axialSG.d1.temperature h.bc.st.axialSG.d1.temperature],'visible','on')
    if flg == 0
        h.T_p1 = integral(@(r)func(r).*r.^ax,h.r_c,h.r_i)*2/(h.r_i^2-h.r_c^2);
        set(h.bc.pm.axialSG.d1.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'r','x');
        end
        set(h.bc.et.axialSG.d1.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.axialSG.d1.temperature,'value',1)
        set(h.bc.et.axialSG.d1.temperature,'string',num2str(h.T_p1,15))
    end
end
%
str_func = h.b2.bc.rhs.T.r{2};
func = str2func(str_func);
[h.T_p2, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.r(2,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.axialSG.d2.adiabatic,'value',1)
    cla(h.bc.as.axialSG.d2(2),'reset'); set(h.bc.as.axialSG.d2(2),'visible','off')
    set([h.bc.et.axialSG.d2.temperature h.bc.pm.axialSG.d2.temperature h.bc.st.axialSG.d2.temperature],'visible','off')
else
    set(h.bc.rb.axialSG.d2.conductive,'value',1)
    set([h.bc.et.axialSG.d2.temperature h.bc.pm.axialSG.d2.temperature h.bc.st.axialSG.d2.temperature],'visible','on')
    if flg == 0
        h.T_p2 = integral(@(r)func(r).*r.^ax,h.r_c,h.r_i)*2/(h.r_i^2-h.r_c^2);
        set(h.bc.pm.axialSG.d2.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'r','x');
        end
        set(h.bc.et.axialSG.d2.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.axialSG.d2.temperature,'value',1)
        set(h.bc.et.axialSG.d2.temperature,'string',num2str(h.T_p2,15))
    end
end
%
str_func = h.b2.bc.rhs.T.z{1};
func = str2func(str_func);
[h.T_d1g, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.z(1,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.radialSG.d1.adiabatic,'value',1)
    cla(h.bc.as.radialSG.d1(2),'reset'); set(h.bc.as.radialSG.d1(2),'visible','off')
    set([h.bc.et.radialSG.d1.temperature h.bc.pm.radialSG.d1.temperature h.bc.st.radialSG.d1.temperature],'visible','off')
else
    set(h.bc.rb.radialSG.d1.conductive,'value',1)
    set([h.bc.et.radialSG.d1.temperature h.bc.pm.radialSG.d1.temperature h.bc.st.radialSG.d1.temperature],'visible','on')
    if flg == 0
        h.T_d1g = integral(@(z)func(z),0,h.l_d1)/h.l_d1;
        set(h.bc.pm.radialSG.d1.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'z','y');
        end
        set(h.bc.et.radialSG.d1.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.radialSG.d1.temperature,'value',1)
        set(h.bc.et.radialSG.d1.temperature,'string',num2str(h.T_d1g,15))
    end
end
%
str_func = h.b2.bc.rhs.T.z{3};
func = str2func(str_func);
[h.T_d2g, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.z(3,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.radialSG.d2.adiabatic,'value',1)
    cla(h.bc.as.radialSG.d2(2),'reset'); set(h.bc.as.radialSG.d2(2),'visible','off')
    set([h.bc.et.radialSG.d2.temperature h.bc.pm.radialSG.d2.temperature h.bc.st.radialSG.d2.temperature],'visible','off')
else
    set(h.bc.rb.radialSG.d2.conductive,'value',1)
    set([h.bc.et.radialSG.d2.temperature h.bc.pm.radialSG.d2.temperature h.bc.st.radialSG.d2.temperature],'visible','on')
    if flg == 0
        h.T_d2g = integral(@(z)func(z),h.l_d1+h.l_lb,h.l_d1+h.l_lb+h.l_d2)/h.l_d2;
        set(h.bc.pm.radialSG.d2.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'z','y');
        end
        set(h.bc.et.radialSG.d2.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.radialSG.d2.temperature,'value',1)
        set(h.bc.et.radialSG.d2.temperature,'string',num2str(h.T_d2g,15))
    end
end
%
if h.r_c == 0
    set(h.bc.rb.radialLB.rc.axis,'Value',1,'Enable','inactive')
    set([h.bc.rb.radialLB.rc.wall h.bc.rb.radialLB.rc.noSlip h.bc.rb.radialLB.rc.slip h.bc.rb.radialLB.rc.adiabatic h.bc.rb.radialLB.rc.conductive],'Value',0,'Enable','off')
    cla(h.bc.as.radialLB.rc(2),'reset');
    set([h.bc.as.radialLB.rc(2) h.bc.et.radialLB.rc.temperature h.bc.pm.radialLB.rc.temperature h.bc.st.radialLB.rc.temperature],'visible','off')
else
    set(h.bc.rb.radialLB.rc.axis,'Value',0,'Enable','off')
    set(h.bc.rb.radialLB.rc.wall,'Value',1,'Enable','inactive')
    set([h.bc.rb.radialLB.rc.noSlip h.bc.rb.radialLB.rc.slip],'Enable','on')
    if strcmp(h.b1.bc.z(1,2),'s')
        set(h.bc.rb.radialLB.rc.slip,'Value',1)
    else
        set(h.bc.rb.radialLB.rc.noSlip,'Value',1)
    end
    str_func = h.b1.bc.rhs.T.z{1};
    [T_c, flg] = str2num(str_func(5:end));
    if strcmp(h.b1.bc.z(1,3),'a') || h.flowopt.energy == 0
        set(h.bc.rb.radialLB.rc.adiabatic,'value',1)
        cla(h.bc.as.radialLB.rc(2),'reset'); set(h.bc.as.radialLB.rc(2),'visible','off')
        set([h.bc.et.radialLB.rc.temperature h.bc.pm.radialLB.rc.temperature h.bc.st.radialLB.rc.temperature],'visible','off')
    else
        set(h.bc.rb.radialLB.rc.conductive,'value',1)
        set([h.bc.et.radialLB.rc.temperature h.bc.pm.radialLB.rc.temperature h.bc.st.radialLB.rc.temperature],'visible','on')
        if flg == 0
            set(h.bc.pm.radialLB.rc.temperature,'value',2)
            str_func = strrep(str_func(5:end),'.^','^');
            if ax == 0
                str_func = strrep(str_func,'z','y');
            end
            set(h.bc.et.radialLB.rc.temperature,'string',str_func,'enable','inactive')
        else
            set(h.bc.pm.radialLB.rc.temperature,'value',1)
            set(h.bc.et.radialLB.rc.temperature,'string',num2str(T_c,15))
        end
    end
end
%
str_func = h.b2.bc.rhs.T.z{4};
[T_o, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.z(4,3),'a') || h.flowopt.energy == 0
    set(h.bc.rb.radialSG.ro.adiabatic,'value',1)
    cla(h.bc.as.radialSG.ro(2),'reset'); set(h.bc.as.radialSG.ro(2),'visible','off')
    set([h.bc.et.radialSG.ro.temperature h.bc.pm.radialSG.ro.temperature h.bc.st.radialSG.ro.temperature],'visible','off')
else
    set(h.bc.rb.radialSG.ro.conductive,'value',1)
    set([h.bc.et.radialSG.ro.temperature h.bc.pm.radialSG.ro.temperature h.bc.st.radialSG.ro.temperature],'visible','on')
    if flg == 0
        set(h.bc.pm.radialSG.ro.temperature,'value',2)
        str_func = strrep(str_func(5:end),'.^','^');
        if ax == 0
            str_func = strrep(str_func,'z','y');
        end
        set(h.bc.et.radialSG.ro.temperature,'string',str_func,'enable','inactive')
    else
        set(h.bc.pm.radialSG.ro.temperature,'value',1)
        set(h.bc.et.radialSG.ro.temperature,'string',num2str(T_o,15))
    end
end
%
str_func = h.b2.bc.rhs.w.r{1};
func = str2func(str_func);
[h.w_in, flg] = str2num(str_func(5:end));
if strcmp(h.b2.bc.r(1,1),'i')
    str_func = h.b2.bc.rhs.w.r{1};
    set([h.bc.rb.axialSG.d1.inflow h.bc.rb.axialSG.d2.outflow],'value',1)
    set([h.bc.et.axialSG.d1.velocity h.bc.pm.axialSG.d1.velocity h.bc.st.axialSG.d1.velocity],'visible','on')
    set(h.bc.et.axialSG.d1.velocity,'enable','inactive')
    set([h.bc.rb.axialSG.d1.noSlip h.bc.rb.axialSG.d1.slip h.bc.rb.axialSG.d2.noSlip h.bc.rb.axialSG.d2.slip],'value',0,'enable','off')
    cla(h.bc.as.axialSG.d2(3),'reset'); set(h.bc.as.axialSG.d2(3),'visible','off')
    set([h.bc.et.axialSG.d2.velocity h.bc.pm.axialSG.d2.velocity h.bc.st.axialSG.d2.velocity],'visible','off')
elseif strcmp(h.b2.bc.r(2,1),'i')
    str_func = h.b2.bc.rhs.w.r{2};
    set([h.bc.rb.axialSG.d1.outflow h.bc.rb.axialSG.d2.inflow],'value',1)
    set([h.bc.rb.axialSG.d1.noSlip h.bc.rb.axialSG.d1.slip h.bc.rb.axialSG.d2.noSlip h.bc.rb.axialSG.d2.slip],'value',0,'enable','off')
    cla(h.bc.as.axialSG.d1(3),'reset'); set(h.bc.as.axialSG.d1(3),'visible','off')
    set([h.bc.et.axialSG.d1.velocity h.bc.pm.axialSG.d1.velocity h.bc.st.axialSG.d1.velocity],'visible','off')
    set([h.bc.et.axialSG.d2.velocity h.bc.pm.axialSG.d2.velocity h.bc.st.axialSG.d2.velocity],'visible','on')
    set(h.bc.et.axialSG.d2.velocity,'enable','inactive')
else
    h.w_in = 0;
    set([h.bc.rb.axialSG.d1.wall h.bc.rb.axialSG.d2.wall],'value',1)
    set([h.bc.rb.axialSG.d1.noSlip h.bc.rb.axialSG.d1.slip h.bc.rb.axialSG.d2.noSlip h.bc.rb.axialSG.d2.slip],'enable','on')
    if strcmp(h.b2.bc.r(1,2),'s')
        set(h.bc.rb.axialSG.d1.slip,'Value',1)
    else
        set(h.bc.rb.axialSG.d1.noSlip,'Value',1)
    end
    if strcmp(h.b2.bc.r(2,2),'s')
        set(h.bc.rb.axialSG.d2.slip,'Value',1)
    else
        set(h.bc.rb.axialSG.d2.noSlip,'Value',1)
    end
    cla(h.bc.as.axialSG.d1(3),'reset'); set(h.bc.as.axialSG.d1(3),'visible','off')
    cla(h.bc.as.axialSG.d2(3),'reset'); set(h.bc.as.axialSG.d2(3),'visible','off')
    set([h.bc.et.axialSG.d1.velocity h.bc.pm.axialSG.d1.velocity h.bc.st.axialSG.d1.velocity h.bc.et.axialSG.d2.velocity h.bc.pm.axialSG.d2.velocity h.bc.st.axialSG.d2.velocity],'visible','off')
end
if ~strcmp(h.b2.bc.r(1,1),'w')
    func = str2func(str_func);
    [h.w_in, flg] = str2num(str_func(5:end));
    if flg == 0
        h.w_in = integral(@(r)func(r).*r.^ax,h.r_i,h.r_o)*2/(h.r_o^2-h.r_i^2);
        str_func = strrep(str_func(5:end),'.^','^');
        str_func = strrep(str_func,'log(','ln(');
        if ax == 0
            str_func = strrep(str_func,'r','x');
        end
        if strcmp(h.b2.bc.r(1,1),'i')
            set(h.bc.pm.axialSG.d1.velocity,'value',2)
            set(h.bc.et.axialSG.d1.velocity,'string',str_func(5:end-1))
        else
            set(h.bc.pm.axialSG.d2.velocity,'value',2)
            set(h.bc.et.axialSG.d2.velocity,'string',str_func(5:end-1))
        end
    else
        if strcmp(h.b2.bc.r(1,1),'i')
            set(h.bc.pm.axialSG.d1.velocity,'value',1)
            set(h.bc.et.axialSG.d1.velocity,'string',num2str(-h.w_in,15))
        else
            set(h.bc.pm.axialSG.d2.velocity,'value',1)
            set(h.bc.et.axialSG.d2.velocity,'string',num2str(-h.w_in,15))
        end
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% basic state panel %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.flowopt.tolerance.residuals = evalin('base','flowopt.tolerance.residuals');
h.flowopt.tolerance.newton = evalin('base','flowopt.tolerance.newton');
%
set(h.sn.et.residuals(1),'string',num2str(h.flowopt.tolerance.residuals,15));
set(h.sn.et.residuals(2),'string',num2str(h.flowopt.tolerance.newton,15));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% optical ray panel %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.r_0 = evalin('base','r_0*l_lb/r_i');
h.z_p = evalin('base','z_p-0.5');
h.N_coeff = evalin('base','N_coeff');
%
set(h.or.et.ray,'string',num2str(h.r_0,15));
set(h.or.et.particle,'string',num2str(h.z_p,15));
set(h.or.et.N(1),'string',num2str(h.N_coeff(1),15));
set(h.or.et.N(2),'string',num2str(h.N_coeff(2),15));
set(h.or.et.N(3),'string',num2str(h.N_coeff(3),15));
%
flg = evalin('base','exist(''ray'',''var'')');
if flg == 1
    T = evalin('base','b1.T.T');
    R = evalin('base','b1.R.T');
    Z = evalin('base','b1.Z.T');
    Z = (h.l_d1+h.l_lb/2-Z);
    %
    N = h.N_coeff(1) - h.N_coeff(2)*(T-h.N_coeff(3));
    %
    ray = evalin('base','ray');
    % plot the index of refraction
    axes(h.or.as.plot(1))
    cla(h.or.as.plot(1),'reset');
    [~, c] = contourf(R*1000,Z*1000,N,256);
    set(c,'Edgecolor','none');
    colormap(h.or.as.plot(1),'pink')
    axis equal
    cb = colorbar; set(get(cb,'ylabel'),'String','Index of refraction $\mathcal{N}(T)$','Interpreter','latex','FontSize',12)
    xlabel('$r$ [mm]','Interpreter','latex','FontSize',12)
    ylabel('$z$ [mm]','Interpreter','latex','FontSize',12)
    hold on
    plot(ray.path_real(:,1)*h.l_lb*1000,(ray.path_real(:,2)-0.5)*h.l_lb*1000,'color',h.selectedTabColor)
    plot(ray.path_fict(:,1)*h.l_lb*1000,(ray.path_fict(:,2)-0.5)*h.l_lb*1000,'LineStyle','--','Color',h.unselectedTabColor)
    
    % plot the real and the fictional path of the ray
    axes(h.or.as.plot(2))
    cla(h.or.as.plot(2),'reset');
    plot(ray.path_real(:,1)*h.l_lb*1000,(ray.path_real(:,2)-0.5)*h.l_lb*1000,'Color',h.selectedTabColor)
    hold on
    plot(ray.path_fict(:,1)*h.l_lb*1000,(ray.path_fict(:,2)-0.5)*h.l_lb*1000,'LineStyle','--','Color',h.unselectedTabColor)
    xlabel('$r$ [mm]','Interpreter','latex','FontSize',12)
    ylabel('$z$ [mm]','Interpreter','latex','FontSize',12)
    % adjust xlim because otherwise the vertical line is always at the border
    x_lim = xlim;
    delta_r = (ray.path_real(end,1)-ray.r_0)*h.l_lb*1000;
    if delta_r < 0
        xlim([x_lim(1) x_lim(2)+diff(x_lim)*0.05])
    else
        xlim([x_lim(1)-diff(x_lim)*0.05 x_lim(2)])
    end
    % adjust ylim such that upper bound = 0.5*l_lb
    y_lim = ylim;
    ylim([y_lim(1) h.l_lb*1000/2])
    legend({'$\mathcal{N}=\mathcal{N}(T)$','$\mathcal{N}=\mathrm{const}.$'},'location','best','Interpreter','latex','FontSize',12)
    
    % print the actual position of the particle
    axes(h.or.as.particle(1)); cla(h.or.as.particle(1))
    if isnan(ray.r_p)
        text(-0.53,h.tp_y,'$r_\mathrm{p}=$',h.latex_r{:})
        helpdlg('The ray reached the free surface.','Info')
    else
        text(-0.53,h.tp_y,['$r_\mathrm{p}=' num2str(ray.r_p*h.l_lb/h.r_i) '\cdot\, r_i$'],h.latex_r{:})
    end
    
else
    axes(h.or.as.plot(1)); cla(h.or.as.plot(1),'reset');
    set(h.or.as.plot(1),'visible','off')
    %
    axes(h.or.as.plot(2)); cla(h.or.as.plot(2),'reset');
    legend(h.or.as.plot(2),'off');
    set(h.or.as.plot(2),'visible','off')
    %
    axes(h.or.as.particle(1)); cla(h.or.as.particle(1))
    text(-0.53,h.tp_y,'$r_\mathrm{p}=$',h.latex_r{:})
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% stability panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.m_start = evalin('base','m_start');
h.m_delta = evalin('base','m_delta');
h.m_end = evalin('base','m_end');
h.flowopt.eigs.n = evalin('base','flowopt.eigs.n');
h.flowopt.eigs.n_cayley = evalin('base','flowopt.eigs.n_cayley');
h.dependent = evalin('base','dependent');
switch h.dependent
    case 'delta_T'
        h.T_init = h.T_d1l-h.T_d2l;
        set(h.sy.rb.delta_T,'value',1)
    case 'T_d1l'
        h.T_init = h.T_d1l;
        set(h.sy.rb.T_d1,'value',1)
    case 'T_d2l'
        h.T_init = h.T_d2l;
        set(h.sy.rb.T_d2,'value',1)
end
%
set(h.sy.et.m_start,'string',num2str(h.m_start,15))
set(h.sy.et.m_delta,'string',num2str(h.m_delta,15))
set(h.sy.et.m_end,'string',num2str(h.m_end,15))
set(h.sy.et.n_eig,'string',num2str(h.flowopt.eigs.n))
set(h.sy.et.n_eig_c,'string',num2str(h.flowopt.eigs.n_cayley))
if ax == 1
    set(h.sy.et.m_delta,'enable','off')
else
    set(h.sy.et.m_delta,'enable','on')
end

% plot residuals
    flg = evalin('base','exist(''b1'',''var'') && isfield(b1,''w'')');
    axes(h.sn.as.residuals); cla(h.sn.as.residuals);
    if flg == 1
        set(h.sn.as.residuals,'visible','on')
        evalin('base','plotResiduals')
    else
        legend(h.sn.as.residuals,'off');
        set(h.sn.as.residuals,'visible','off')
    end

% plot eigenvalues
    gamma_flg = evalin('base','exist(''gamma'',''var'')');
    axes(h.sy.as.eigs), cla(h.sy.as.eigs,'reset');
    if gamma_flg == 1
        ax = gca; ax.Box = 'on'; xlabel('$s=\Re(\gamma)$ [1/s]','interpreter','latex'); ylabel('$\omega=\Im(\gamma)$ [1/s]','interpreter','latex'); hold on
        i = 0;
        x_lim = [];
        for m = h.m_start:h.m_delta:h.m_end
            i = i+1;
            gamma_p = evalin('base',['-complex(gamma_' strrep(num2str(m),'.','_') ')']);
            p = plot(complex(gamma_p),'o','DisplayName',['m=' num2str(m)],'color',h.colors(mod(i-1,size(h.colors,1))+1,:)); set(p,'MarkerFaceColor',get(p,'Color'));
            legend('show'); legend('Location','northwest')
            x_lim = [min([xlim x_lim]) max([xlim x_lim])];
        end
        plot(x_lim,[0 0],'k-.','HandleVisibility','off');
        y_lim = ylim; y_lim = max(abs(y_lim))*[-1 1]; ylim(y_lim)
        if x_lim(1)*x_lim(2)<0
            plot([0 0],y_lim,'k--','HandleVisibility','off');
        end
    else
        legend(h.sy.as.eigs,'off');
        set(h.sy.as.eigs,'visible','off')
    end

updateSketch_TFM
updateText_TFM