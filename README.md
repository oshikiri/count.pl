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

```sh
cnt() {
  perl -e ' use strict;use warnings;my$topk=10;my$show_progress=1;my$reflesh_interval=0.5;foreach my $arg(@ARGV){if($arg=~/^-(\d+)$/){$topk=$1;next;}if($arg=~/^(?:-np|--no-progress)$/){$show_progress=0;next;}if($arg=~/^-t=(\d(?:\.\d)?)$/){$reflesh_interval=$1;next;}}my%counts=();my$total=0;my$last_update=time();sub print_sorted{my$n=$_[0];if($n==-1){$n=keys%counts;}my@sorted=sort{$counts{$b}<=>$counts{$a}}keys%counts;foreach my $key(splice@sorted,0,$n){print"$key: $counts{$key}\n";}}sub clear_console{print"\033[2J";}sub up{my$n=$_[0];print"\e[${n}A";}while(<STDIN>){chomp;$total++;$counts{$_}++;if($show_progress&&time()-$last_update>$reflesh_interval){$last_update=time();&clear_console();&up($topk);&print_sorted($topk);}}if($show_progress){&clear_console();}&print_sorted(-1); ' -- "$@"
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
