[![Build Status](https://secure.travis-ci.org/dekz/fabio.png)](http://travis-ci.org/dekz/fabio)
# Fabio
Middleware build worker.


# Current Stack
```
  Commands  
  Environments
  Repositories
  Executors
  Reporters
```

# Adding a new middleware
Some of the parent middlewares (Commands) also use middlewares (commands/ping.rb). Allowing functionality to be quickly added. Simply respond to the env if needed.

## Example
Let us take Commands as an example. Commands has also been implemented as a middlware, it's middleware all the way down. Any call to Fabio-Worker will pass through Commands, it will also pass through Ping and Info. It will pass through all included Middlewares, so only act if required. 
```
# e.g env = { :cmd => :info }
Stack
-> Commands
  -> Ping 
  -> Info *responds*
-> Environment
  -> RVM
  -> Bundler
-> Repositories
  -> CVS
  -> Git
-> Executors
  -> Ant
  -> Rake
-> Reporters
  -> Reporter
```
Note: this the global stack example, a Top level stack may pass messages differently. (Not currently the case)

# Why?
Main goal is to create a simple and extendable remote build system. One which can easily be executed on most platforms (ruby, or jruby).

# Core concepts
Always #call on, never stop the chain early. Call with empty if required.  
Default your arguments where it makes sense, use the most logical default choice (i.e git with no operation is checkout)  

