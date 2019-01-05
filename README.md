
[![Docker Pulls](https://img.shields.io/docker/pulls/subfuzion/envtpl.svg)](https://hub.docker.com/r/subfuzion/envtpl/)


# envtpl

`envtpl` renders [Go templates] on the command line using environment variables.

It is directly inspired by the original [envtpl], a Python tool for rendering
[Jinja2] templates.

This port was motivated by the desire to add templating support for template-driven
configuration files that needed to be part of a base Docker image without also
requiring the installation of Python. For the same reason, I decided not to add
variable support to my previous template utility [njx], which depends on Node.js.

Despite the difference between `Jinja` and `Go` templates, an attempt was made
to match the command line syntax of the original `envtpl`.

The biggest obvious difference is that `Go` template variables represent a path within
a data context, so `envtpl` variables will need to be prepended with a leading `.` to
match the keys of the internal environment variable map object (see example).

## Get it

    $ go get github.com/subfuzion/envtpl/...

## Usage

    envtpl [-o|--output outfile] [-m|--missingkey option] [template]

* If `template` is not provided, `envtpl` reads from `stdin`
* If `outfile` is not provided, `envtpl` writes to `stdout`
* If `missingkey` is unset or set to either `default` or `invalid`,
  `envtpl` follows the default behavior of
  [the golang template library](https://golang.org/pkg/text/template/#Template.Option)
  and missing keys in the template will be filled in with the string
  `<no value>`.  If `missingkey` is set to `zero`, missing keys will be
  filled in with the zero value for their data type (ie: an empty
  string).  If `missingkey` is set to `error`, `envtpl` will fail and
  an error returned to the caller.

## Example

`greeting.tpl`

    Hello {{.USER}}

Render the template (assume the value of `$USER` is 'mary')

    envtpl greeting.tpl  # writes "Hello mary" to stdout

    USER=bob envtpl greeting.tpl  # overrides "mary" and writes "Hello bob" to stdout

    echo "greetings {{.USER}}" | envtpl  # writes "greetings mary" to stdout

    envtpl < greeting.tpl > out.txt  # writes "Hello mary" to out.txt
    envtpl > out.txt < greeting.tpl  # same thing
    cat greeting.tpl | envtpl > out.txt  # same thing

    unset USER; envtpl greeting.tpl            # => "Hello <no value>"
    unset USER; envtpl -m zero greeting.tpl    # => "Hello "
    unset USER; envtpl -m error greeting.tpl   # => "map has no entry for key "USER"", aborts

`test/test.tpl` tests conditional functions as well as loop on environment variables. the `test/test/sh` script compares the output of envtpl with the expected output and can be used as unit test.

## Template Functions

### sprig
In addition to the [standard set of template actions and functions][standard-templates]
that come with Go, `envtpl` also incorporates [sprig] for additional, commonly used functions.

For example:

    echo "Greetings, {{.USER | title}}" | envtpl  # writes "Greetings, Mary" to stdout

In the example, the environment name of the user `mary` is converted to `Mary` by the `title` template function.

For reference, see [sprig functions].

### environment

To mimic the environment function for the original envtpl, an `environment` function allows to filter the environment with a prefix string

    {{ range $key, $value := environment "TAG_"  }}{{ $key }}="{{ $value }}"{{ end }}

filters all environment variables starting with TAG_.

For example:

```bash
$ echo '{{ range $key, $value := environment "GO"  }}{{ $key }} => {{ $value }} {{ "\n" }}{{ end }}' | envtpl
GOPATH => /Users/tony/go
GOROOT => /usr/local/go
```

## Building an envtpl Docker image

[![Docker Build Status](https://img.shields.io/docker/build/subfuzion/envtpl.svg)](https://hub.docker.com/r/subfuzion/envtpl/)

An image is available on Docker Hub [subfuzion/envtpl](https://hub.docker.com/r/subfuzion/envtpl/)

You can use run a container like this:

    $ echo 'Hello {{ .NAME | title | printf "%s\n" }}' | docker run -i --rm -e NAME=world subfuzion/envtpl
    Hello World

To build your own local container:

	$ make docker

The final image is based on `scratch` and weighs in at less than 7MB:

```bash
$ docker images --format "{{ .Repository }}:{{ .Tag }} => {{ .Size }}" subfuzion/envtpl
subfuzion/envtpl:latest => 6.65MB
```
	
## Test

    $ make test

## Similar Tools

As mentioned above, this tool was inspired by the original [envtpl] project and
motivated to provide something similar without adding a Python dependency to
Docker base images.

A search for similar Go-based tools turns up the following:

 * [mattrobenolt/envtpl]
 * [arschles/envtpl]

I haven't spent any time evaluating either yet. However, [mattrobenolt/envtpl] looks elegantly simple and [arschles/envtpl] offers tests, [glide] package management support and more template functionality using [sprig].

Neither of these two packages appear to conform to the original `envtpl` command line syntax, which was one of my goals, although I don't think this is a big deal since all of these spin-off versions use an entirely different template syntax anyway. However, at first glance at least, this variant does offer more input/output options modeled after the original.

~~I'm inspired by [arschles/envtpl] to add [sprig] support for extended template functions, potentially [glide] support, and definitely tests.~~ This version now has [sprig] template support, tests, and uses Go 1.1. modules instead of glide.

## License

[MIT](https://raw.githubusercontent.com/subfuzion/envtpl/master/LICENSE)


[arschles/envtpl]:     https://github.com/arschles/envtpl
[envtpl]:              https://github.com/andreasjansson/envtpl
[glide]:               https://github.com/Masterminds/glide
[Go templates]:        https://golang.org/pkg/text/template/
[Jinja2]:              http://jinja.pocoo.org/docs/dev/
[mattrobenolt/envtpl]: https://github.com/mattrobenolt/envtpl
[njx]:                 https://github.com/subfuzion/njx
[sprig]:               https://github.com/Masterminds/sprig
[sprig functions]:     http://masterminds.github.io/sprig/
[standard-templates]:  https://golang.org/pkg/text/template/
