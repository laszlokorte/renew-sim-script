# Renew Simulation Elixir Wrapper

This a proof of concept for running a [Renew](http://www.renew.de) simulation from within elixir.

## Prerequisites

* Have Java installted to be able to run renew
* Have Elixir installed
* Some Renew plugins require the Java AWT GUI to be loadable.

## Getting started

### Download Renew

This downloads the current version of renew into the current folder

```sh
./download.sh
```

###

Run the elixir simulation wrapper:

```sh
elixir run.exs
```