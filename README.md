# envtpl

`envtpl` renders [Go templates](https://golang.org/pkg/text/template/) on the
command line using environment variables.

It is directly inspired by the original [envtpl](https://github.com/andreasjansson/envtpl),
a Python tool for rendering [Jinja2](http://jinja.pocoo.org/docs/dev/) templates.

This port was motivated by the desire to add templating support for template-driven
configuration files that needed to be part of a base Docker image without also
requiring the installation of Python. Despite the difference between `Jinja` and `Go`
templates, an attempt was made to match the command line syntax of the original `envtpl`.

The biggest obvious difference is that `Go` template variables represent a path within
a data context, so they need to be prepended with leading `.`.

## Usage

    envtpl [-o|--output outfile] [template]

If `template` is not provided, `envtpl` reads from `stdin`
If `outfile` is not provide, `envtpl` writes to `stdout`

## Example

`greeting.tpl`

    Hello {{.USER}}

Render the template (assume $USER is 'mary')

    envtpl greeting.tpl  # writes "Hello mary" to stdout

    USER=bob envtpl greeting.tpl  # overrides "mary" and writes "Hello bob" to stdout

    envtpl < greeting.tpl > out.txt  # writes "Hello mary" to out.txt

    cat greeting.tpl | envtpl > out.txt  # writes "Hello mary" to out.txt
