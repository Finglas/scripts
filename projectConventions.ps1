function CheckProjectName($projectName) {
    $projectName = ProjectName $project

    if ($projectName.Contains("Test")) {
        if (!$projectName.EndsWith("UnitTests") -and !$projectName.EndsWith("IntegrationTests")) {
            echo $projectName
        }
    } 
}

function CheckRootNamespace($project) {
    $projectName = ProjectName $project
    $rootNamespace = cat $project.FullName | Select-string "<RootNamespace>"
    $expectedRootNamespace = ("<RootNamespace>" + $projectName + "</RootNamespace>")

    if (!$rootNamespace.Line.Trim().Equals($expectedRootNamespace.Trim())) {
        echo $projectName
    }

}

function CheckAssemblyName($project) {
    $projectName = ProjectName $project
    $assemblyName = cat $project.FullName | Select-string "<AssemblyName>"
    $expectedAssemblyName = ("<AssemblyName>" + $projectName + "</AssemblyName>")

    if (!$assemblyName.Line.Trim().Equals($expectedAssemblyName.Trim())) {
        echo $projectName
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