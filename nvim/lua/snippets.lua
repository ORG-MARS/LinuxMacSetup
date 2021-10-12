local luasnip = require'luasnip'

local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

luasnip.snippets = {
	all = {
    luasnip.snippet("dtime", luasnip.function_node(bash, {}, "date +'%Y-%m-%d %H:%M'")),
    luasnip.snippet("date", luasnip.function_node(bash, {}, "date +'%Y-%m-%d'")),
	},
  python = {
    luasnip.snippet("exit", luasnip.text_node({"import sys", "sys.exit()"})),
    luasnip.snippet("shell", luasnip.text_node(
      {"xiaomo = locals()", "import os", "import logging", "logging.getLogger('parso').setLevel(logging.INFO)", "from prompt_toolkit.utils import DummyContext", "from ptpython.repl import PythonRepl, run_config", "repl = PythonRepl(get_globals=lambda : globals(), get_locals=lambda : xiaomo, history_filename=os.path.expanduser('~/.ptpython_history'))", "run_config(repl)", "with DummyContext():", "    repl.run()"}
      )
    ),
    luasnip.snippet("ifmain", luasnip.text_node({"if __name__ == '__main__':", "    main()"})),
  }
}