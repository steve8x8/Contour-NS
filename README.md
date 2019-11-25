# Contour-NS

Upload data collected by the Contour app (not only the meter) to Nightscout

## Hardware

- I'm owning a Contour blood-glucose meter by Ascensia (formerly Bayer).
  Since all the interfacing is done by Ascensia's "Contour Diabetes app", I presume the exact model doesn't matter.
- Also, an Android device where the app runs on, and is fed with BG measurements,
  and meal, injection and exercise notes.

## Software

- Ascensia's Contour app (com.ascensia.contour.$TLD available in several countries) on the Android device
- A computer running an OS unixoid enough to run Ruby and Bash scripts (Linux or MacOSX suggested)

## Preparations

- Copy `.settings.sample` to `.settings` and insert your Nightscout details.

## Procedure

1. Export your data from the app as CSV ("My care" - "Reports" - CSV).
   The file will be named `ContourCSVReport_${date}.csv` and placed in the `Downloads`
   folder of your Android device. The date representation may be different in your locale.
2. Copy the CSV file to your computer.
   There is a multitude of ways to do this. I'm using Telegram's "Saved messages" to first upload, then again download the file.
3. `make csv` will fetch the **newest** ContourCSVReport_*.csv file (again, from `~/Downloads` - modify the `Makefile` if necessary)
4. `make last` will retrieve the latest upload timestamps for carbs, insulin, and exercise.
5. `make chs ins exe` will produce uploadable `json` files, with entries newer than the respective "last" timestamp.
  (`make new` combines steps 3 through 5.)
6. `make up` will upload these files.
7. `make tar` will save the current temporary files.
8. `make clean` (not yet implemented!) would remove temporary files.
9. Rinse and repeat...

## Caveats

- This is purely experimental, and has been provided for educational purposes. (Don't flame me for my coding style.)
- I've been using this for several weeks, but since the code has been constantly changed, bugs cannot be ruled out.
- Retroactive adding of e.g. exercises (before the corresponding timestamp) inside the app will not result in an updated upload.
- My meter is using mg/dL units, and one carbohydrate unit is 12 grams (change cvs2carbs accordingly if needed).
- Starting from zero (e.g. without any previous uploads) has not been tested "but is supposed to work".
- Sometimes, the query returns an empty list, setting the timestamp to 0. Check this twice.
- I'd guess there are date representations which have not been taken into account (Japanese?).
- See below.

# Disclaimer

Although I've been, and still am, successfully using this setup to upload my own recorded data to Nightscout,
your experience may be different. This is experimental, educational-only software. Use at your own risk!

Except that, the Nightscout disclaimer holds: Never ever make medical decisions based only on the data that
have been processed through this software. If in doubt, use an approved device - like your trusted BG meter.

For feedback, use the Issues.

## Remarks

- The Contour Next One meter can store up to 800 readings, and has a limit of 64k measurements in total.
- The Contour Diabetes app keeps only the latest 1000 entries.
  Blood-glucose measurements, meal recordings, insulin injections, exercise may be combined into a single entry.
  Nevertheless, with a dozen entries per day, creating a 12-week BGDiary may force-close the app
  (since the case that the record limit has been reached isn't properly checked for). 
- All times are in the timezone of the meter, or the smartphone controlling it.
  Be extra careful when hopping timezones, or during daylight savings switches.
