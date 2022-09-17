within Credibility.Examples.SimpleControlledDriveNonlinear;
model SimpleControlledDrive_virtualMeasurement "Drive train for virtual measurements"
  extends Modelica.Icons.Example;
  extends Credibility.Examples.SimpleControlledDriveNonlinear.PartialDrive(
    redeclare SimpleControlledDriveNonlinear.DataVariant001 data,
    inertiaLoad(a(fixed=true, start=0)),
    damper(d=d_exact));

  parameter Units.SI.RotationalDampingConstant d_exact=100 "Exact value of damping constant used for virtual measurement";

  Modelica.Blocks.Continuous.LimPID speedController(
    k=100,
    Ti=0.1,
    yMax=12,
    Ni=0.1,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    limiter(u(start=0)),
    Td=0.1) "k, Ti, Ni: defined from control development, to be tested on control robustness ; yMax, yMin: from system spec; Init defined by optimization scenario spec" annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Mechanics.Rotational.Sources.ConstantTorque torqueLoad(
    tau_constant=10,
    useSupport=false) "tau: guess value with uncertainty, could be dynamic load (boundary condition)"
    annotation (Placement(transformation(
          extent={{102,-10},{82,10}})));
  Modelica.Blocks.Sources.SineVariableFrequencyAndAmplitude sine(
    useConstantAmplitude=true,
    constantAmplitude=0.01,
    useConstantFrequency=false) annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=30,
    duration=4,
    offset=1) annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Blocks.Noise.NormalNoise normalNoise1(samplePeriod=0.001, sigma=5e-4)
    annotation (Placement(transformation(extent={{-70,-76},{-50,-56}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{0,-50},{20,-70}})));
  Modelica.Blocks.Noise.NormalNoise normalNoise2(samplePeriod=0.001, sigma=5e-4)
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{60,-74},{80,-94}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensorLoad annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,-40})));

  Modelica.Blocks.Interfaces.RealOutput noisyMotorSpeed
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{110,-60},{110,-60}})));
  Modelica.Blocks.Interfaces.RealOutput noisyLoadSpeed
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}), iconTransformation(extent={{110,-90},{110,-90}})));

  inner Modelica.Blocks.Noise.GlobalSeed globalSeed annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
initial equation

equation
  connect(ramp.y, sine.f) annotation (Line(points={{-69,60},{-60,60},{-60,54},{-52,54}}, color={0,0,127}));
  connect(sine.y, speedController.u_s) annotation (Line(points={{-29,60},{-20,60},{-20,36},{-96,36},{-96,0},{-92,0}}, color={0,0,127}));
  connect(add1.y,noisyMotorSpeed)
    annotation (Line(points={{21,-60},{110,-60}}, color={0,0,127}));
  connect(normalNoise2.y,add2. u1)
    annotation (Line(points={{-19,-90},{58,-90}},
        color={0,0,127}));
  connect(add2.y,noisyLoadSpeed)  annotation (Line(points={{81,-84},{90,-84},{90,-90},{110,-90}},
        color={0,0,127}));
  connect(normalNoise1.y, add1.u1) annotation (Line(points={{-49,-66},{-2,-66}}, color={0,0,127}));
  connect(inertiaLoad.flange_b, torqueLoad.flange) annotation (Line(points={{78,0},{82,0}}, color={0,0,0}));
  connect(inertiaLoad.flange_a, speedSensorLoad.flange) annotation (Line(points={{58,0},{50,0},{50,-30}}, color={0,0,0}));
  connect(speedSensor.w, add1.u2) annotation (Line(points={{-9,-33},{-9,-54},{-2,-54}}, color={0,0,127}));
  connect(speedSensorLoad.w, add2.u2) annotation (Line(points={{50,-51},{50,-78},{58,-78}}, color={0,0,127}));
  connect(speedController.y, torqueMotor.tau) annotation (Line(points={{-69,0},{-57,0}}, color={0,0,127}));
  connect(add1.y, speedController.u_m) annotation (Line(points={{21,-60},{30,-60},{30,-46},{-80,-46},{-80,-12}}, color={0,0,127}));

  annotation (
    experiment(StopTime=4),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-96,76},{-24,44}},
          lineColor={255,0,0}),
        Text(
          extent={{-94,87},{-27,79}},
          textColor={255,0,0},
          textString="reference speed generation"),
        Text(
          extent={{2,-20},{34,-32}},
          textColor={255,0,0},
          textString="Exact value used 
for virtual measurement"),
        Line(
          points={{14,-20},{26,-16}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-100,24},{-62,18}},
          textColor={255,0,0},
          textString="controller"),
        Rectangle(
          extent={{-98,16},{-66,-16}},
          lineColor={255,0,0})}),
    Documentation(info="<html>
<p>
A&nbsp;controlled simple drive train to generate noisy signals of speed sensors.
The signals <code>noisyMotorSpeed</code> and <code>noisyLoadSpeed</code> can be
used as virtual mesurements for
<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.SimpleControlledDrive_forCalibration\">model calibration</a>,
whereby this example is configured in a&nbsp;way especially suitable for calibration
of the damping parameter <code>damper.d</code>. Therefore, <code>damper.d</code>
is set to its nominal value of 100&nbsp;N&middot;m&middot;s/rad here, which is the
value a&nbsp;successful calibration shall striver.
</p>
<p>
A&nbsp;suitable reference motor speed for calibration of this drive train
configuration is prescribed by block <code>sine</code> which generates a&nbsp;sine
sweep signal of constant amplitude. It is used as a&nbsp;reference value of
the feedback controller which commands a&nbsp;motor torque for the drive train.
</p>
</html>"));
end SimpleControlledDrive_virtualMeasurement;
