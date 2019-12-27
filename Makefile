#!/usr/bin/make -f

# modify this if your exchange happens somewhere else
DOWNLD := ~/Downloads

# fetch latest CSV file, do not sort by name!
csv:
	cp -pi `ls 2>/dev/null -tr $(DOWNLD)/ContourCSVReport_*.csv | tail -n1` ./Contour.csv || true

last:	.settings
	./last-query

exe:	upload_exercise.json

upload_exercise.json:	Contour.csv last_exercise
	./csv2exercise ./Contour.csv last_exercise

ins:	upload_insulin.json

upload_insulin.json:	Contour.csv last_insulin
	./csv2insulin  ./Contour.csv last_insulin

chs:	upload_carbs.json

upload_carbs.json:	Contour.csv last_carbs
	./csv2carbs    ./Contour.csv last_carbs

# not used (handled by xDrip)
mbg:	upload_bloodg.json

upload_bloodg.json:	Contour.csv last_bloodg
	./csv2bloodg   ./Contour.csv last_bloodg

new:	csv last exe ins chs #mbg

up:	.settings
	./upload-data

tar:
	mkdir -p SAVE
	tar cf SAVE/all-`date +%Y%m%d-%H%M%S`.tar *.csv last_* upload_*

clean:
	rm last_* upload_* Contour.csv

.PHONY: csv last exe ins chs mbg new up tar clean
