all: install.sh

clean:
	rm -r built

install.sh: count.min.pl
	echo \
		"function cnt() {\n  perl -e '" \
		$$(sed -e 's/\\/\\\\/g' < built/count.min.pl) \
		"' -- \"\$$@\" \n}" \
		> built/install.sh

count.min.pl:
	mkdir -p built/
	cat count.pl \
		| sed -s 's/\#.\+//g' \
		| perltidy --mangle \
		| tr -d '\n' \
		> built/count.min.pl

format:
	perltidy --profile=.perltidyrc count.pl
