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

- [ ] Complete the Python `bitbake-dep` script