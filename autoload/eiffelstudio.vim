python import vim, subprocess, fcntl, os, time


if !exists("g:eiffelstudio_compiler")
    let g:eiffelstudio_compiler = "ec"
endif

if !exists("g:eiffel_plugin_root")
    let g:eiffel_plugin_root= expand('<sfile>:p:h:h')
endif

if !exists("g:eiffelstudio_debug")
    let g:eiffelstudio_debug = 0
endif

python << endpython

ec_process = None

def empty_buffer(a_buffer):
    has_read = True
    while has_read:
	try:
	    a_buffer.readline()
	except IOError:
	    has_read = False


def print_buffer_value(a_buffer):
    has_read = True
    while has_read:
        try:
            output = a_buffer.readline()
	    print(output)
        except IOError:
	    has_read = False


def get_buffer_value(a_buffer):
    result = ""
    has_read = True
    while has_read:
        try:
            output = a_buffer.readline()
	    result = result + output + "\n"
        except IOError:
	    has_read = False
    return result

def get_err_waiting_for_command():
    result = ""
    must_exit = False
    while not must_exit:
	output = ""
	try:
	    output = ec_process.stdout.readline()
	except IOError:
	    pass
	must_exit = "Command =>" in output
	result = result + get_buffer_value(ec_process.stderr)
	time.sleep(0.2)
    result = result + get_buffer_value(ec_process.stderr)
    empty_buffer(ec_process.stdout)
    return result

def is_ec_running():
    return ec_process != None and ec_process.poll() is None


def waiting_for_command(must_print_err=False):
    must_exit = False
    output = ""
    while not must_exit:
	try:
	    output = output + ec_process.stdout.read(1024)
	    print(output)
	except IOError:
	    print("Error")
	must_exit = "Command =>" in output
	if must_print_err:
	    print_buffer(ec_process.stderr)
    if must_print_err:
	print_buffer(ec_process.stderr)
    empty_buffer(ec_process.stdout)


def eiffelstudio_freeze():
    global ec_process
    if ec_process == None or ec_process.poll() is not None:
	print("The EiffelStudio process is not running.")
    else:
	empty_buffer(ec_process.stdout)
	empty_buffer(ec_process.stderr)
	ec_process.stdin.write("I\nF\ny\n")
	waiting_for_command(True)

	
def eiffelstudio_open(config_file,target_name=None):
    compiler = vim.eval('g:eiffelstudio_compiler')
    global ec_process
    try:
	if target_name is not None:
	    ec_process = subprocess.Popen([compiler, '-stop', '-loop', 
					   '-config', config_file, "-target", 
					   target_name],
    					  stdin=subprocess.PIPE, 
					  stdout=subprocess.PIPE, 
					  stderr=subprocess.PIPE)
	else:
	    ec_process = subprocess.Popen([compiler, '-stop', '-loop', 
					   '-config', config_file],
    					  stdin=subprocess.PIPE, 
					  stdout=subprocess.PIPE, 
					  stderr=subprocess.PIPE)
    except Exception as e:
	print("Le compilateur EiffelStudio " + compiler + " est invalide")
	if not (vim.eval('g:eiffelstudio_debug') == "0"):
	    print("Error: " + str(e))
    else:
	output = ec_process.stdout.readline()
	flags = fcntl.fcntl(ec_process.stderr, fcntl.F_GETFL)
	fcntl.fcntl(ec_process.stdout, fcntl.F_SETFL, flags | os.O_NONBLOCK)
	flags = fcntl.fcntl(ec_process.stdout, fcntl.F_GETFL)
	fcntl.fcntl(ec_process.stdout, fcntl.F_SETFL, flags | os.O_NONBLOCK)
	if "This project has more than one target" in output:
	    print("You must specify the target for this project...")
	else:
	    waiting_for_command()
	    eiffelstudio_freeze() 


endpython

function! eiffelstudio#open(...)
    if !g:is_eiffelstudio_open
	let config_file = fnamemodify(bufname("%"), ':p')
	if a:0 ># 0
	    let config_file = fnamemodify(a:1,':p')
	endif
	if a:0 ># 1
	    python eiffelstudio_open(vim.eval('config_file'),vim.eval('a:2'))
	else
	    python eiffelstudio_open(vim.eval('config_file'))
	endif
	let g:is_eiffelstudio_open = 1
    else
	echo "EiffelStudio is already open"
    endif
endfunction
