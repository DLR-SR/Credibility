within Credibility;
record Table1D "Record collecting credibility information for a Real 1D table"
  extends Credibility.Icons.CredibleBase;

  final parameter Real table[size(uncertainty.table,1),2]=
    if uncertainty.withTolerance then
      getTableLambdaByTolerance(
        uncertainty.lambda, uncertainty.table, uncertainty.relTol, uncertainty.absTol)
    else
      getTableLambdaByInterval(
        uncertainty.lambda, uncertainty.table)
    "Scaled table";
  parameter Types.Traceability traceability "Traceability";
  replaceable parameter Types.Interval1D uncertainty
    constrainedby Types.BaseUncertainty1D "Uncertainty"
    annotation (choicesAllMatching=true);
  parameter String calibration = "" "URI of calibration setup script";
protected
  function getTableLambdaByInterval "Calculate scaled table by lower and upper limits"
    extends Modelica.Icons.Function;

    input Real lambda "Convex scaling between -1 and 1 (=0: nominal)";
    input Real uncertainty[:,4] "Table uncertainty (x, y, yL, yU)";
    output Real table[size(uncertainty,1),2] "Value of table";
  algorithm
    table[:,1] := uncertainty[:,1];

    if lambda >= 0 then
      table[:,2] := lambda * uncertainty[:,4] + (1 - lambda) * uncertainty[:,2];
    else
      table[:,2] := (1 + lambda) * uncertainty[:,2] - lambda * uncertainty[:,3];
    end if;
  end getTableLambdaByInterval;

  function getTableLambdaByTolerance "Calculate scaled table by tolerances"
    extends Modelica.Icons.Function;

    input Real lambda "Convex scaling between -1 and 1 (=0: nominal)";
    input Real uncertainty[:,2] "Table uncertainty (x, nominal)";
    input Real absTol "Limits: |value[i] - uncertainty[i,2]| <= max(absTol,relTol*|uncertainty[i,2]|)";
    input Real relTol "Limits: |value[i] - uncertainty[i,2]| <= max(absTol,relTol*|uncertainty[i,2]|)";
    output Real table[size(uncertainty,1),2] "Value of table";
  protected
    Real tol[size(uncertainty,1)];
  algorithm
    table[:,1] := uncertainty[:,1];

    for i in 1:size(uncertainty,1) loop
      tol[i] :=max(absTol, relTol*abs(uncertainty[i, 2]));
    end for;
    if lambda >= 0 then
      table[:,2] := lambda * (uncertainty[:,2]+tol) + (1 - lambda) * uncertainty[:,2];
    else
      table[:,2] := (1 + lambda) * uncertainty[:,2] - lambda * (uncertainty[:,2]-tol);
    end if;
  end getTableLambdaByTolerance;

  annotation (
    Icon(graphics={
        Text(
          extent={{-80,-10},{100,-60}},
          textColor={0,140,72},
          textString="table 1D")}),
    Documentation(info="<html>
<p>
This record collects credibility information for a&nbsp;<em>1d table</em>
parameter. In particular, it contains information regarding
</p>
<ul>
  <li>
    the nominal values as [:,2] array (first column: abscissa, second column: ordinate values).
  </li>
  <li>
    traceability,
  </li>
  <li>
    uncertainty and
  </li>
  <li>
    calibration.
  </li>
</ul>
</html>"));
end Table1D;
