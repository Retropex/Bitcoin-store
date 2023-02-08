## This alternative store allows you to choose another version of bitcoin core.

This alternative App Store allows you to install [Bitcoin Knots](https://bitcoinknots.org)

**To install this version of bitcoin core, it is imperative to uninstall the bitcoin application from the official app store.**

> [!WARNING]
> Unfortunately, this will trigger a new IDB.
> If you are comfortable with the command lines you can save the Bitcoin Core folder and then restore it once Knots is installed 

To use this alternative app store just add the github depot link, here is a small [video](https://youtu.be/-CVE7LyzJJw) to see how to do it.

If you want to install an app that requires the bitcoin application it will fail, because it is a community app store. To overcome this you must use the following command that will force the installation of an app :

```
sudo ~/umbrel/scripts/app install <app>
```
