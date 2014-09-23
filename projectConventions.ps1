function CheckProjectName($projectName) {
    $projectName = ProjectName $project

    if ($projectName.Contains("Test")) {
        if (!$projectName.EndsWith("UnitTests") -and !$projectName.EndsWith("IntegrationTests")) {
            echo ($projectName + " is not named correctly. Must end with UnitTests or IntegrationTests.")
        }
    } 
}

function CheckRootNamespace($project) {
    $projectName = ProjectName $project
    $rootNamespace = cat $project.FullName | Select-string "<RootNamespace>"
    $expectedRootNamespace = ("<RootNamespace>" + $projectName + "</RootNamespace>")

    if (!$rootNamespace.Line.Trim().Equals($expectedRootNamespace)) {
        echo ($projectName + " root namespaces is not named correctly. Should match project name.")
    }

}

function CheckAssemblyName($project) {
    $projectName = ProjectName $project
    $assemblyName = cat $project.FullName | Select-string "<AssemblyName>"
    $expectedAssemblyName = ("<AssemblyName>" + $projectName + "</AssemblyName>")

    if (!$assemblyName.Line.Trim().Equals($expectedAssemblyName)) {
        echo ($projectName + " assembly name is not named correctly. Should match project name.")
    }
}

function CheckWarningsAsErrors($project) {
    $projectName = ProjectName $project
    $assemblyName = cat $project.FullName | Select-string "<TreatWarningsAsErrors>"
    $expectedAssemblyName = ("<TreatWarningsAsErrors>true</TreatWarningsAsErrors>")

    if (!$assemblyName.Line) {
        echo ($projectName + " needs to have warnings as errors enabled.")
    }

    foreach ($line in $assemblyName.Line) {

        if (!$line.Trim().Equals($expectedAssemblyName)) {
            echo ($projectName + " should have warnings as errors enabled for Debug and Release builds.")
            return
        } 
    }
}

function ProjectName($project) {
    return $project.Name.Replace(".csproj", "")
}

function CheckProjectFiles() {
    $projects = Get-ChildItem .\ -Recurse -Filter "*.csproj" | Where-Object { $_.Name -match "Asos.*"}

    foreach ($project in $projects) {
        CheckProjectName $project
        CheckAssemblyName $project
        CheckRootNamespace $project
        CheckWarningsAsErrors $project
    }
}

CheckProjectFiles