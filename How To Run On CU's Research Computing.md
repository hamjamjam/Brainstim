### How to run Matlab Scripts on CU's Research Computing Resources FROM WINDOWS

There is a lot of information [here](https://curc.readthedocs.io/en/latest/software/matlab.html)

For when I forget the details:

First request an account at [the RC website](https://rcamp.rc.colorado.edu/accounts/account-request/create/organization)
Unfortunately, it requires duo.

Next, follow the steps [here](https://curc.readthedocs.io/en/latest/access/logging-in.html) to download Putty and sign in.

Once you have ssh-ed into a login node:

There are steps [here](https://curc.readthedocs.io/en/latest/software/matlab.html) to run matlab scripts.

More specifically, I have left a 'runScripts.sh' file in the Analysis Scripts folder which will take user input when running to run a specific script. e.g.

`sh runScripts filename`

Note that no `.m` is needed.
