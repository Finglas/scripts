function CheckProjectName($projectName) {
    $projectName = ProjectName $project

    if ($projectName.Contains("Test")) {
        if (!$projectName.EndsWith("UnitTests") -and !$projectName.EndsWith("IntegrationTests")) {
            $message = $projectName + " is not named correctly. Must end with UnitTests or IntegrationTests."
            echo $message
        }
    } 
}

function CheckRootNamespace($project) {
    $projectName = ProjectName $project
    $rootNamespace = cat $project.FullName | Select-string "<RootNamespace>"
    $expectedRootNamespace = ("<RootNamespace>" + $projectName + "</RootNamespace>")

    if (!$rootNamespace.Line.Trim().Equals($expectedRootNamespace.Trim())) {
        $message = $projectName + " root namespaces is not named correctly. Should match project name."
        echo $message
    }

}

function CheckAssemblyName($project) {
    $projectName = ProjectName $project
    $assemblyName = cat $project.FullName | Select-string "<AssemblyName>"
    $expectedAssemblyName = ("<AssemblyName>" + $projectName + "</AssemblyName>")

    if (!$assemblyName.Line.Trim().Equals($expectedAssemblyName.Trim())) {
        $message = $projectName + " assembly name is not named correctly. Should match project name."
        echo $message
    }
}

function ProjectName($project) {
    return $project.Name.Replace(".csproj", "")
}

function CheckProjectFiles() {
    $projects = Get-ChildItem .\ -Recurse -Filter "*.csproj"

    foreach ($project in $projects) {
        CheckProjectName $project
        CheckAssemblyName $project
        CheckRootNamespace $project
    }
}

CheckProjectFiles