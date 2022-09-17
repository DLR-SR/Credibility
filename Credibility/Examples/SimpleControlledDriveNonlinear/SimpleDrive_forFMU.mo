within Credibility.Examples.SimpleControlledDriveNonlinear;
model SimpleDrive_forFMU
  "Original model parameterized with DataVariant001 for FMU generation"
  extends Modelica.Blocks.Icons.Block;
  extends Credibility.Examples.SimpleControlledDriveNonlinear.PartialDrive(
    redeclare SimpleControlledDriveNonlinear.DataVariant001 data);

  parameter Modelica.Units.SI.Angle driveAngle=1.570796326794897 "Reference distance to move";

  Modelica.Mechanics.Rotational.Sources.ConstantTorque loadTorque(tau_constant=10, useSupport=false)
    annotation (Placement(transformation(extent={{102,-10},{82,10}})));

  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensorLoad annotation (
     Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={80,60})));
  Modelica.Blocks.Interfaces.RealInput tau(start=0.0)
    "Accelerating torque acting at flange (= -flange.tau)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput wm
    "Absolute angular velocity of motor inertia" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40})));
  Modelica.Blocks.Interfaces.RealOutput wa
    "Absolute angular velocity of load inertia" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,60})));
equation
  connect(inertiaLoad.flange_b, loadTorque.flange) annotation (Line(points={{78,0},{82,0}}, color={0,0,0}));
  connect(torqueMotor.tau, tau)
    annotation (Line(points={{-57,0},{-100,0}},color={0,0,127}));
  connect(speedSensor.w, wm)
    annotation (Line(points={{-9,-33},{-9,-40},{110,-40}},
        color={0,0,127}));
  connect(speedSensorLoad.w, wa)
    annotation (Line(points={{91,60},{110,60}}, color={0,0,127}));
  connect(inertiaLoad.flange_a, speedSensorLoad.flange) annotation (Line(points={{58,0},{50,0},{50,60},{70,60}},
        color={0,0,0}));

  annotation (
    experiment(StopTime=4),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
          Text(
            extent={{-48,16},{48,-16}},
            textColor={135,135,135},
            textString="to FMU")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Example model for the geration of an FMU for
<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.SimpleControlledDrive_original\">SimpleControlledDrive_original</a>.
</p>
</html>"));
end SimpleDrive_forFMU;
