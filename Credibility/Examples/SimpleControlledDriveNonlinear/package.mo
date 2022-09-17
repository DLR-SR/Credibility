within Credibility.Examples;
package SimpleControlledDriveNonlinear "Collection of examples involving simple drive train"
  extends Modelica.Icons.ExamplesPackage;

  annotation (
    Documentation(info="<html>
<p>
This package contains an example of a&nbsp;simple 1-dim. drive train and
all classes demonstrating a&nbsp;possible usage of parameter credibility
information within the context of this drive train. Most important:
</p>

<p>
<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.PartialDrive\">PartialDrive</a>
is a partial model of a drive train with credibility information. 
The structure can be seen in the following image (from [<a href=\"modelica://Credibility.UsersGuide.References\">Otter2022</a>]):
</p>

<p>
<img src=\"modelica://Credibility/Resources/Images/CredibilityLibrary1.png\">
</p>

<p>
<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.SimpleControlledDrive_original\">SimpleControlledDrive_original</a>
uses the partial model of the drive train, adds a controller and concrete values including credibility information
by replacing the PartialData record with 
<a href=\"modelica://Credibility.Examples.SimpleControlledDriveNonlinear.DataVariant001\">DataVariant001</a>.
In particular nominal, upper/lower limit values for the table of the gear compliance are provided
(image from [<a href=\"modelica://Credibility.UsersGuide.References\">Otter2022</a>]):
</p>

<p>
<img src=\"modelica://Credibility/Resources/Images/CredibilityLibrary2.png\">
</p>

</html>"));
end SimpleControlledDriveNonlinear;
