count.pl
=====

## How to use

Load `cnt` function

```bash
function cnt() {
  perl -e ' use strict;use warnings;my%counts=();my$total=0;sub showTopItems{print"\033[2J";print"\e[10A";my@sorted=sort{$counts{$b}<=>$counts{$a}}keys%counts;foreach my $key(splice@sorted,0,10){print"$key: $counts{$key}\n";}}while(<STDIN>){chomp;$total++;$counts{$_}++;if($total%1000000==0){&showTopItems();}}&showTopItems(); '
}
```

and redirect newline-separeted data into `cnt`

```
echo -e 'a\nb\na\nb' | cnt
```

show counts
```
a: 2
b: 2
```

## Development
### Requirements

- Perl v5.30.0 (?)

```sh
# For development
cpanm Perl::Tidy
```



## Reference

- scount https://github.com/oshikiri/scount
  - Equivalent implementation in Golang
