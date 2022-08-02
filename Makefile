all: count.sh

clean:
	rm -r built

count.sh: count.min.pl prepare
	echo \
		"function cnt() {\n  perl -e '" \
		$$(sed -e 's/\\/\\\\/g' < built/count.min.pl) \
		"'\n}" \
		> built/count.sh

count.min.pl: prepare
	cat count.pl \
		| sed -s 's/\#.\+//g' \
		| perltidy --mangle \
		| tr -d '\n' \
		> built/count.min.pl

prepare:
	mkdir -p built/

format:
	perltidy \
		--backup-and-modify-in-place \
		--backup-file-extension='/' \
		count.pl
