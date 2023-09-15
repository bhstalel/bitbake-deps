# Bitbake On Recipe Dependencies

This project provides tools that perform custom tasks or full build on a given recipe's dependencies which are recipes also.

## What ?

The idea is the following:

1. Generate a recipe's dependencies list
2. Remove the recipe itself from the list to avoid `bitbake`ing it
3. Loop through the list and run the full or given task on the recipe

## How ?

This project provide two scripts that do the same thing:

* `bitbake-deps.sh`: Can be ran from anywhere.
* `bitbake-deps`: Must be copied to `poky/bitbake/bin` to be able to use `bitbake` library

## Shell Solution

* Usage:

```sh
./bitbake-deps.sh target [task]
```

The shell script provide a `DEBUG` level that you can activate by setting the variable `ENABLE_DEBUG` to `1`:

```sh
ENABLE_DEBUG=1 ./bitbake-deps.sh core-image-minimal
```

When enabling `DEBUG`, `bitbake` output will be shown along side the `[DEBUG]` log message.

## Python Solution

You need to copy the `bitbake-deps` script to `poky/bitbake/bin` and re`source` the `oe-ini-build-env` script again. Then you can use it like follows:

* Usage:

```sh
bitbake-deps --help
usage: bitbake-deps [-h] -r RECIPE [-t TASK]

Run Tasks on Dependencies

optional arguments:
  -h, --help            show this help message and exit
  -r RECIPE, --recipe RECIPE
                        Recipe name
  -t TASK, --task TASK  Custom task to run on deps
```

* Fetch all dependencies of `core-image-minimal`

```sh
bitbake-deps -r core-image-minimal -t do_fetch
```

## Use case examples

* Fetch all dependencies of an image:

```sh
./bitbake-deps.sh core-image-minimal do_fetch
```

* Build all dependencies of a given package:

```sh
./bitbake-deps.sh virtual/kernel
```

## TODO

- [X] Complete the Python `bitbake-dep` script