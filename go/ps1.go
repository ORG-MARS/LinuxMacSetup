package main

import (
	"bytes"
	"fmt"

	git "github.com/libgit2/git2go/v31"

	"os"
	"path/filepath"
	"strings"
	"time"
)

var ShortPathTruncate = 3

// ColorIt would return a function that will paint a string using a color
// specified by a name. We will try to load color from environment first.
func ColorIt(name string) func(string) string {
	var defaultColors = map[string]string{
		"COLOR_SHORTPATH":   "15",
		"COLOR_CURRENTPATH": "33",
		"COLOR_GITBRANCH":   "166",
		"COLOR_GITSTATUS":   "136",
		"COLOR_VENV":        "166",
		"COLOR_LAST_GOOD":   "34",
		"COLOR_LAST_FAIL":   "124",
	}
	color := os.Getenv(name)
	if color == "" {
		color = defaultColors[name]
	}
	return func(msg string) string {
		buf := bytes.NewBufferString("\\[\033[")
		buf.WriteString("38;5;" + color)
		buf.WriteRune('m')
		buf.WriteString("\\]" + msg)
		return buf.String()
	}
}

func Symbols(name string) string {
	var defaultSymbols = map[string]string{
		"GIT_UNCOMMITED": "+",
		"GIT_UNSTAGED":   "!",
		"GIT_UNTRACKED":  "?",
		"GIT_STASHED":    "¥",
		"HAS_VENV":       "∇",
		"START_BRACKET":  "{",
		"END_BRACKET":    "}",
	}
	symbol := os.Getenv(name)
	if symbol == "" {
		symbol = defaultSymbols[name]
	}
	return symbol
}

// GitSearch will tell us whether we are in a git root and in a git tree.
func GitSearch() (bool, string) {
	dir, _ := filepath.Abs(".")
	dir, _ = filepath.EvalSymlinks(dir)
	if dir == "" {
		// Current working directory removed
		return false, ""
	}
	for dir != "/" {
		if filepath.Base(dir) == ".git" {
			return true, filepath.Dir(dir)
		}
		if _, err := os.Stat(filepath.Join(dir, "/.git")); err == nil {
			return true, dir
		}
		dir = filepath.Dir(dir)
	}
	return false, ""
}

// Cwd would output the current path, and reduce the length of the output.
// Example:
// /usr/local/lib/python2.7/site-packages -> /us/lo/li/py/site-packages
func Cwd() string {
	ShortPath := ColorIt("COLOR_SHORTPATH")
	CurrentPath := ColorIt("COLOR_CURRENTPATH")
	var (
		shortName string
	)
	dir, _ := os.Getwd()
	dir = strings.Replace(dir, os.Getenv("HOME"), "~", 1)
	paths := strings.Split(dir, "/")
	shortPaths := make([]string, len(paths))
	for i, path := range paths {
		if (len(path) < ShortPathTruncate) || (i == len(paths)-1) {
			shortPaths[i] = path
		} else {
			if strings.HasPrefix(path, ".") {
				shortPaths[i] = path[:ShortPathTruncate+1]
			} else {
				shortPaths[i] = path[:ShortPathTruncate]
			}
		}
	}
	if len(paths) == 1 {
		shortName = shortPaths[0]
	} else {
		shortName = ShortPath(strings.Join(shortPaths[:len(paths)-1], "/") + "/")
		shortName += CurrentPath(shortPaths[len(paths)-1])
	}
	return shortName
}

// BranchName will give the name of the branch.
func BranchName(repository *git.Repository) string {
	head, err := repository.Head()
	if err == nil {
		return PrettyBranchName(head.Shorthand())
	} else {
		return "Unknown"
	}
}

// PrettyBranchName will replace repetitive names in the branch and
// truncate longer names.
func PrettyBranchName(name string) string {
	if name == "master" || name == "main" {
		return "🏠"
	}
	const truncate = 15
	name = strings.Trim(name, "\n")
	name = strings.Replace(name, "feature/", "🔨/", 1)
	// the bugfix name could have many variants.
	name = strings.Replace(name, "bugfix/", "🐛/", 1)
	name = strings.Replace(name, "bug/", "🐛/", 1)
	name = strings.Replace(name, "fix/", "🐛/", 1)
	if len(name) > truncate {
		return name[:truncate-3] + "⁁" + name[len(name)-3:]
	} else {
		return name
	}
}

// GitSt will output the current git status.
func GitSt(repository *git.Repository) string {
	opts := &git.StatusOptions{}
	opts.Show = git.StatusShowIndexAndWorkdir
	opts.Flags = git.StatusOptIncludeUntracked | git.StatusOptRenamesHeadToIndex | git.StatusOptExcludeSubmodules
	sl, _ := repository.StatusList(opts)
	ec, _ := sl.EntryCount()

	hasUncommited := false
	hasUnstaged := false
	hasUntracked := false
	for i := 0; i < ec; i++ {
		item, _ := sl.ByIndex(i)
		if item.Status%32 != 0 {
			hasUncommited = true
		}
		if item.Status == 128 {
			hasUntracked = true
		}
		if item.Status >= 256 {
			hasUnstaged = true
		}
	}

	var status string
	GitStatus := ColorIt("COLOR_GITSTATUS")

	if hasUncommited {
		status += Symbols("GIT_UNCOMMITED")
	}
	if hasUnstaged {
		status += Symbols("GIT_UNSTAGED")
	}
	if hasUntracked {
		status += Symbols("GIT_UNTRACKED")
	}
	if _, err := os.Stat(filepath.Join(repository.Path(), "refs/stash")); err == nil {
		status += Symbols("GIT_STASHED")
	}

	if len(status) != 0 {
		status = GitStatus(status)
	}
	return status
}

// GitPrompt will combine GitSt and BranchName and provide git info for prompt.
func GitPrompt() string {
	insideGit, dir := GitSearch()
	if !insideGit {
		return ""
	}
	repository, _ := git.OpenRepository(dir)
	GitBranch := ColorIt("COLOR_GITBRANCH")

	branchName := BranchName(repository)

	channel := make(chan string, 1)
	go func() {
		text := GitSt(repository)
		channel <- text
	}()

	select {
	case gitSt := <-channel:
		return GitBranch(branchName) + gitSt
	case <-time.After(400 * time.Millisecond):
		return GitBranch(branchName)
	}
}

// VenvPrompt will look for virtualenv def in environment.
func VenvPrompt() string {
	envDef := os.Getenv("VIRTUAL_ENV")
	if envDef == "" {
		return ""
	}
	path := os.Getenv("PATH")
	if !strings.HasPrefix(path, envDef) {
		return ""
	}
	return ColorIt("COLOR_VENV")(Symbols("HAS_VENV"))
}

func main() {
	var lastColorName string
	if len(os.Args) == 1 {
		lastColorName = "COLOR_LAST_GOOD"
	} else {
		if os.Args[1] == "0" {
			lastColorName = "COLOR_LAST_GOOD"
		} else {
			lastColorName = "COLOR_LAST_FAIL"
		}
	}
	prompt := VenvPrompt()
	prompt += ColorIt(lastColorName)(Symbols("START_BRACKET"))
	gitPrompt := GitPrompt()
	if len(gitPrompt) != 0 {
		prompt += gitPrompt + " "
	}
	prompt += Cwd()
	prompt += ColorIt(lastColorName)(Symbols("END_BRACKET"))
	prompt += "\\[\033[0m\\]"
	fmt.Println(prompt)
}
