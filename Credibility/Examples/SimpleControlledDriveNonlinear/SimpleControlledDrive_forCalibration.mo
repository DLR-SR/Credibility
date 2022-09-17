within Credibility.Examples.SimpleControlledDriveNonlinear;
model SimpleControlledDrive_forCalibration "Base model for calibration"
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
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensorLoad annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,-40})));
  Modelica.Blocks.Sources.CombiTimeTable measurementsTable(
    tableOnFile=true,
    table=[0.0,0.0; 1.0,0.0],
    tableName="motor_load_speed",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Credibility/Resources/Tables/driveMeasurementsNonLin.txt"),
    columns=2:3) annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Math.Feedback diffSpeedMotor "Input for criteria 1: Difference between simulated and measured angular velocities of motor" annotation (Placement(transformation(extent={{-20,-50},{0,-70}})));
  Modelica.Blocks.Math.Feedback diffSpeedLoad "Input for criteria 2: Difference between simulated and measured angular velocities of load" annotation (Placement(transformation(extent={{40,-60},{60,-80}})));
initial equation

equation
  connect(ramp.y, sine.f) annotation (Line(points={{-69,60},{-60,60},{-60,54},{-52,54}}, color={0,0,127}));
  connect(sine.y, speedController.u_s) annotation (Line(points={{-29,60},{-20,60},{-20,36},{-96,36},{-96,0},{-92,0}}, color={0,0,127}));
  connect(inertiaLoad.flange_b, torqueLoad.flange) annotation (Line(points={{78,0},{82,0}}, color={0,0,0}));
  connect(inertiaLoad.flange_a, speedSensorLoad.flange) annotation (Line(points={{58,0},{50,0},{50,-30}}, color={0,0,0}));
  connect(speedSensor.w, speedController.u_m) annotation (Line(points={{-9,-33},{-9,-40},{-80,-40},{-80,-12}},
        color={0,0,127}));
  connect(speedController.y, torqueMotor.tau) annotation (Line(points={{-69,0},{-57,0}}, color={0,0,127}));
  connect(measurementsTable.y[1], diffSpeedMotor.u1) annotation (Line(points={{-59,-60},{-18,-60}}, color={0,0,127}));
  connect(measurementsTable.y[2], diffSpeedLoad.u1) annotation (Line(points={{-59,-60},{-30,-60},{-30,-70},{42,-70}}, color={0,0,127}));
  connect(speedSensor.w, diffSpeedMotor.u2) annotation (Line(points={{-9,-33},{-9,-40},{-10,-40},{-10,-52}}, color={0,0,127}));
  connect(speedSensorLoad.w, diffSpeedLoad.u2) annotation (Line(points={{50,-51},{50,-62}}, color={0,0,127}));

  annotation (
    experiment(StopTime=4),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-96,76},{-24,44}},
          lineColor={255,0,0}),
        Text(
          extent={{-92,84},{-26,78}},
          textColor={255,0,0},
          textString="sweep excitation"),
        Text(
          extent={{-100,24},{-62,18}},
          textColor={255,0,0},
          textString="controller"),
        Rectangle(
          extent={{-98,16},{-66,-16}},
          lineColor={255,0,0})}),
    Documentation(info="<html>
<p>
A&nbsp;controlled simple drive train to be used for calibration, see also 
<a href=\"modelica://Credibility.UsersGuide.ParameterCredibility.CalibrationInfo\">User&apos;s Guide</a>.
It consists of an excitation block <code>sine</code> that generates a&nbsp;sine
sweep signal with constant amplitude and increasing frequency as reference
value for the feedback controller <code>speedController</code>. The controller
commands a&nbsp;motor torque for the drive train. Two sensors measure the
angular velocities of the motor and load inertias.
Measurement data, generated in a&nbsp;preprocessing step by means of
a&nbsp;<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.SimpleControlledDrive_virtualMeasurement\">virtual test rig</a>,
is provided as table <code>measurementsTable</code>.
</p>


<h4>Calibration setup</h4>
<p>
The calibration criteria itself are not defined here and shall be composed by the
user for the optimization-based calibration. As criteria input, the differences
between simulated and measured data of motor and load angular velocities can be
utilized, calculated in <code>diffSpeedMotor</code> and <code>diffSpeedLoad</code>,
respectively.
</p>
<p>
To further configure the calibration optimization setup, the predefined calibration
data of the drive train parameters, stored directly in the record <code>data</code>,
shall be widely used. Let us demonstrate this on the calibration of the damping
parameter <code>damper.d</code> as follows.
</p>
<p>
The calibration optimization setup consists of the nominal model with a&nbsp;starting
value for the damping parameter of 300&nbsp;N&middot;m&middot;s/rad and an assumed
possible range for the parameter of [1,&nbsp;1000]&nbsp;N&middot;m&middot;s/rad.
Then, the optimization tuner setting shall be
</p>
<ul>
  <li>
    tuner1.value = <code>data.damping.calibration.start</code> (=&nbsp;300),
  </li>
  <li>
    tuner1.min = <code>data.damping.calibration.lower</code> (=&nbsp;1),
  </li>
  <li>
    tuner1.max = <code>data.damping.calibration.upper</code> (=&nbsp;1000).
  </li>
</ul>

<p>
After a&nbsp;successful optimization run, the resulting optimal parameter value shall
be stored (manually) in <code>data.damping.value</code>, together with its assumed
uncertainty.
</p>
</html>"));
end SimpleControlledDrive_forCalibration;
