def test_regex(a_project, a_name):
    """ Test the `a_project'.get_tools_regex(`a_name') feature."""
    l_regex = a_project.get_tools_regex(a_name)
    l_file = open(a_project.config_file_path() +
                  "/test_python_input/" + a_name + "_regex.input", "r")
    l_result = l_regex.findall(l_file.read())
    try:
        l_compare = open(a_project.config_file_path() +
                         "/test_python_output_cmp/" + a_name +
                         "_regex.output", "r")
        if l_result != l_compare.read():
            print("Error in the Regex test: " + a_name)
            l_output = open(a_project.config_file_path() +
                            "/test_python_output/" + a_name +
                            "_regex.output", "w")
            l_output.write(l_result)

    except:
        print("Error in the Regex test: " + a_name)
        l_output = open(a_project.config_file_path() +
                        "/test_python_output/" + a_name +
                        "_regex.output", "w")
        l_output.write(str(l_result))


def execute(a_project):
    """ Testing the python fonctions."""
    test_regex(a_project, "comment")
