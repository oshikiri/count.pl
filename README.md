count.pl
=====

<a href="https://github.com/oshikiri/count.pl/actions?query=workflow%3Atest">
  <img
    src="https://github.com/oshikiri/count.pl/workflows/test/badge.svg"
    alt="Build Status"
  >
</a>

## How to use

Load `cnt` function

```bash
function cnt() {
  perl -e ' use strict;use warnings;my$topk=10;my$no_progress=grep(/^--no-progress$/,@ARGV);my%counts=();my$total=0;my$last_update=time();sub showTopk{my@sorted=sort{$counts{$b}<=>$counts{$a}}keys%counts;foreach my $key(splice@sorted,0,$topk){print"$key: $counts{$key}\n";}}sub clear_console{print"\033[2J";}sub up{print"\e[${topk}A";}while(<STDIN>){chomp;$total++;$counts{$_}++;if(!$no_progress&&time()-$last_update>0.5){$last_update=time();&clear_console();&up();&showTopk();}}if(!$no_progress){&clear_console();}&showTopk(); ' -- "$@"
}
```

and redirect newline-separeted data into `cnt`.

```sh
echo -e 'a\nb\na\nb' | cnt
```

It will show counts.

```
a: 2
b: 2
```

## Requirements

- Perl v5.30.0 (?)

```sh
# For development
cpanm Perl::Tidy
```

## Development

```sh
# Format count.pl
make format
```


## Reference

- scount https://github.com/oshikiri/scount
  - Equivalent implementation in Golang
