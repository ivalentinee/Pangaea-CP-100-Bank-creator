# Pangaea CP-100 Bank creator

## What this script is for
Multiple times I ran into situation when I got folder `N` containing IR-files like

    Super_Amp_SM57.wav
    Super_Amp_Neumann.wav
    Super_Amp_DI.wav
    ...

I was too lazy to convert IR-files for CP-100 by hand and then move them (again, by hand) to folders `Preset_0, Preset_1 etc.`

So I wrote a script to do it automatically.

## How to use
Go to directory with our IR-files and run this script:

```bash
$ cd <whatever_folder_your_best_IRs_are>
$ <wherever_you_put_script>/make_samples_for_pangaea.sh
```

And voila, our files are converted and packed!

All preset files are put into directory named `Result` (created in current directory). You should then just clean chosen CP-100 bank(s) and copy `Result` content to CP-100:

```bash
$ rm -rfv <wherever_you_mounted_cp_100>/Bank_0/* # remove old IR-files
$ cp -rfv ./Bank_N/* <wherever_you_mounted_cp_100>/Bank_0/
```

## Questions?
If you any questions or suggestions, create an issue for this repository. Pull requests are welcome!

