within Credibility.Examples.SimpleControlledDriveNonlinear;
model SimpleControlledDrive_original "Controlled drive train"
  extends Modelica.Icons.Example;
  extends Credibility.Examples.SimpleControlledDriveNonlinear.PartialDrive(
    redeclare SimpleControlledDriveNonlinear.DataVariant001 data,
    inertiaLoad(a(fixed=true, start=0)));

  parameter Modelica.Units.SI.Angle driveAngle=1.570796326794897 "Reference distance to move";
  Modelica.Blocks.Continuous.LimPID speedController(
    k=100,
    Ti=0.1,
    yMax=12,
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.Init.NoInit,
    limiter(u(start=0)),
    Td=0.1) "k, Ti, Ni: defined from control development, to be tested on control robustness ; yMax, yMin: from system spec; Init defined by optimization scenario spec" annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Blocks.Continuous.Integrator integrator(initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{-56,50},{-36,70}})));
  Modelica.Blocks.Sources.KinematicPTP kinematicPTP(
    startTime=0.5,
    deltaq={driveAngle},
    qd_max={1},
    qdd_max={1}) annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque torqueLoad(tau_constant=10, useSupport=false)
    annotation (Placement(transformation(
          extent={{102,-10},{82,10}})));

equation
  connect(kinematicPTP.y[1], integrator.u)
    annotation (Line(points={{-69,60},{-58,60}}, color={0,0,127}));
  connect(integrator.y, speedController.u_s) annotation (Line(points={{-35,60},{-31,60},{-31,30},{-96,30},{-96,0},{-92,0}}, color={0,0,127}));
  connect(speedSensor.w, speedController.u_m) annotation (Line(points={{-9,-33},{-9,-40},{-80,-40},{-80,-12}},
        color={0,0,127}));
  connect(speedController.y, torqueMotor.tau) annotation (Line(points={{-69,0},{-57,0}}, color={0,0,127}));
  connect(inertiaLoad.flange_b,torqueLoad. flange) annotation (Line(points={{78,0},{82,0}}, color={0,0,0}));

  annotation (
    experiment(StopTime=4),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-96,76},{-28,44}},
          lineColor={255,0,0}),
        Text(
          extent={{-93,84},{-27,78}},
          textColor={255,0,0},
          textString="reference"),
        Text(
          extent={{-100,24},{-62,18}},
          textColor={255,0,0},
          textString="controller"),
        Rectangle(
          extent={{-98,16},{-66,-16}},
          lineColor={255,0,0})}),
    Documentation(info="<html>
<p>
This is a&nbsp;simple nonlinear drive train controlled by a&nbsp;PI controller,
based on 
<a href=\"modelica://Modelica.Blocks.Examples.PID_Controller\">Modelica.Blocks.Examples.PID_Controller</a>.
</p>
<p>
It serves as an example for the use of the Credibility library.
</p>
<p>
Detailed information can be found in
[<a href=\"modelica://Credibility.UsersGuide.References\">Otter2022</a>]).
</p>
</html>"));
end SimpleControlledDrive_original;
