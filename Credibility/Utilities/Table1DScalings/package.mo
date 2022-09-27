within Credibility.Utilities;
package Table1DScalings "Functions for evaluation of credible 1D tables"
  extends Modelica.Icons.Package;

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
    annotation (Documentation(info="<html>
<p>
Evaluate <code>table</code> from the <code>uncertainty</code> matrix
by a&nbsp;convex combination utilizing attribute <code>lambda</code>.
Hereby, the matrix <code>uncertainty</code> contains
</p>
<ul>
  <li>
    col. 1: grid values,
  </li>
  <li>
    col. 2: vector of <em>nominal values</em>,
  </li>
  <li>
    col. 3: vector of <em>lower</em> limits and
  </li>
  <li>
    col. 4: vector of <em>upper</em> limits.
  </li>
</ul>
<p>
The convex combination is defined for the Real <code>lambda</code> in a&nbsp;way that 
</p>
<ul>
  <li>
    <var>&lambda;</var>&nbsp;= −1 results in
    <code>table[:,&nbsp;2]</code>&nbsp;= <code>uncertainty[:,&nbsp;3]</code>,
  </li>
  <li>
    <var>&lambda;</var>&nbsp;= 0 results in
    <code>table[:,&nbsp;2]</code>&nbsp;= <code>uncertainty[:,&nbsp;2]</code> and
  </li>
  <li>
    <var>&lambda;</var>&nbsp;= 1 results in
    <code>table[:,&nbsp;2]</code>&nbsp;= <code>uncertainty[:,&nbsp;4]</code>.
  </li>
</ul>

<p>
This function is called in <a href=\"modelica://Credibility.Table1D\">Table1D</a>
to evaluate &quot;table[i,j]&quot;.
For further details, refer to 
<a href=\"modelica://Credibility.UsersGuide.ParameterCredibility.UncertaintyInfo\">User&apos;s Guide</a>
&ndash; &quot;Convex scaling by uncertain parameter <var>&lambda;</var>&quot;.
</p>
</html>"));
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
    Documentation(info="<html>
<p>
This package contains scaling functions used in
<a href=\"modelica://Credibility.Table1D\">Table1D</a>
to compute &quot;table[i,j]&quot; from the given&quot;uncertainty&quot;
matrix. For further details, refer to 
<a href=\"modelica://Credibility.UsersGuide.ParameterCredibility.UncertaintyInfo\">User&apos;s Guide</a>
&ndash; &quot;Convex scaling by uncertain parameter <var>&lambda;</var>&quot;.
</p>
</html>"));
end Table1DScalings;
