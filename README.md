# Fabio
Middleware remotes.

# Current Stack
Commands
Repositories
Executors
Reporters

# Adding a new middleware
Some of the parent middlewares (Commands) also use middlewares (commands/ping.rb). Allowing functionality to be quickly added. No more giant case statements, simply respond to the env if needed.

## Example
On the middleware chain Commands will also chain through its middlewares if the :cmd env is supplied.
```
# e.g env = { :cmd => :info}
Stack
-> Commands
  -> Ping 
  -> Info *responds*
-> Repositories
  -> CVS
-> Executors
  -> Executor
-> Reporters
  -> Reporter
```


# Why?
Main goal is to create a simple and extendable remote build system. One which can easily be run in most platforms (ruby, or jruby).

# Core concepts
Always #call on, never stop the chain early.  
Default your arguments where it makes sense, use the most logical default choice (i.e git with no operation is checkout)  

