var solution = new Solution('mountain-lobster');
var project = new Project('mountain-lobster');
project.targetOptions = {"flash":{},"android":{}};
project.setDebugDir('build/windows');
project.addSubProject(Solution.createProject('build/windows-build'));
project.addSubProject(Solution.createProject('D:/Projects/personal/mountain-lobster/Kha'));
project.addSubProject(Solution.createProject('D:/Projects/personal/mountain-lobster/Kha/Kore'));
solution.addProject(project);
return solution;
