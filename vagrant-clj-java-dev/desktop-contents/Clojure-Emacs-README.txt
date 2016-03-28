These instructions are for doing Clojure development on this sytem using Emacs.

===
Things you should know:
* Emacs is configured to use EVIL, a vim emulator. See
  http://www.emacswiki.org/emacs/Evil and a vim cheatsheet such as
  http://vim.rtorr.com/ for more information.
* Emacs is configured to use the 'clj-repl fn (located in your
* ~/.emacs.d/init.el configuration file) to start a Clojure REPL in your
  editor. 'clj-repl DOES NOT use cider or nREPL.
* 'clj-repl depends upon the script 'clojure-repl being in your $PATH, which it
  is. See ~/bin/clojure-repl.
* The clojure-repl script walks up the filesystem tree from `pwd` to / looking
  for a .classpath file, so you'll almost always want to create one in your
  project directory, and be sure you keep it updated whenever you change
  dependencies.

===
To start a new project:
* open a terminal (the Terminal icon on the desktop will work)
$ lein new projname
$ cd projname
$ lein classpath > .classpath
$ emacs src/projname/core.clj

===
To work on an existing project:
* open a terminal
$ git clone <project URL>
  # You may need to copy an SSH private key into ~/.ssh/id_rsa to access
  # a key-protected repository.
$ cd <repo-name>
$ lein classpath > .classpath
$ emacs path/to/source.clj

===
REPL in Emacs:
* meta-X (usually alt-x) and type 'clj-repl', then press Enter to launch an
  inferior-lisp that executes 'clojure-repl', which will find your .classpath
  file (if you made one!) and start your REPL with all your classpaths loaded.
* Use vim window movement (ESC C-w <h,j,k,l>) to switch between your code and
  your REPL. (C-c C-z also works to switch from your code to your REPL.)
