#!/usr/bin/make -f

# modify this if your exchange happens somewhere else
DOWNLD := ~/Downloads

# fetch latest CSV file
csv:
	cp -pi `ls 2>/dev/null -tr $(DOWNLD)/ContourCSVReport_*.csv | tail -n1` ./ || true

last:	.settings
	./last-query

exe:
	./csv2exercise `ls 2>/dev/null -tr ./ContourCSVReport_*.csv | tail -n1` last_exercise

ins:
	./csv2insulin  `ls 2>/dev/null -tr ./ContourCSVReport_*.csv | tail -n1` last_insulin

chs:
	./csv2carbs    `ls 2>/dev/null -tr ./ContourCSVReport_*.csv | tail -n1` last_carbs

# not used (handled by xDrip)
mbg:
	./csv2bloodg   `ls 2>/dev/null -tr ./ContourCSVReport_*.csv | tail -n1` last_bloodg

new:	csv last exe ins chs #mbg

up:	.settings
	./upload-data

tar:
	mkdir -p SAVE
	tar cf SAVE/all-`date +%Y%m%d-%H%M%S`.tar *.csv last_* upload_*

clean:
	echo not activated yet
	rm -i last_* upload_*


.PHONY: csv last exe ins chs mbg new up tar clean
