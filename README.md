SpamCop.net - Automatic approval of SpamCop.net spam reports v3.5 (2019-06-09)
- Written by Monter - https://dev.techlog.pl/projects/Linux/spamcop/


README
======

spamcop.pl script was created because of not finding the Internet a suitable tool for wholesale approval of the report on Spamcop.net after submitting applications containing Spam, or possibly solutions found were too old/date/too big, etc).

The script for the action requires the WWW::Mechanize extension of the Perl.
Was tested on Perl version 5.10.1, 5.14.2 and 5.20.2

Action script in a nutshell replaces the user and the browser simulating the appropriate action on the Web sites visited by reading the content of these pages and clicking the appropriate buttons.

Spamcop.pl in action:
<img src="https://raw.githubusercontent.com/Monter/spamcop.pl/master/screenshot.png">

To be able to use this script You must have an with Spamcop.net account. Website Spamcop.net is conducted by Cisco and enables IT administrators to report and/or guardians of networks and servers, incidents of sending users their machines / network unsolicited junk mail or viruses. Use of Spamcop.net is free.

Incident reporting (Spam) takes place in the following manner:
- assume Spamcop.net account and receive individual e-mail address to which we can forward the spam
- to send unwanted email address consignment as attachments (this is very important not to undermine the headers sent us, Spam), where you can send the application group, but in a single consignment should not be placed more than 20 attachments, and one mail with attachments should be no larger than 50kb.
- Subject of the message is optional, but must be sent in plain text (not HTML). Email content also do not have to type it.
- in the case of larger volume Spam copy the message headers only, along with the content (body) without encoded attachments and use the report form available on the Spam Spamcop.net (visible after logging in)
- the processing of our Spam submissions Spamcop.net service requires confirmation of any Spam in the form of sending the report - Spamcop.net server analyzes the headers and content and offers up a form with data on Spam and allows you to send notifications to Abuse with the click of a button - unfortunately for all you need to do Spam separately, which is time-consuming - and here is where the script comes my ;-)
- spamcop.pl fire up the script on any server (having completed it previously on your account information in Spamcop.net) and observe the result of his work :-)

NOTE!
- Spamcop.net server is sometimes overloaded and of the transmission of Spam submissions need to wait several minutes before any reports for approval. If the script reports a lack of reports to be sent, wait a moment and try again.
- Spamcop.net free account allows you to send up to 3,000 entries per day, above this limit, we either have to buy an account payable, or our account will be locked and you need to write a request to unlock.


HOW TO INSTALL
==============

The script requires the Perl environment to work with the module WWW:Mechanize. Script does not require installation.

- download the script and save it to disk
- give him the right to do (chmod + x)
- Run the script providing the `USERNAME` and `PASSWORD` environment variables. These are the credentials of you Spamcop.net account.
 
To use the script, you must have a user account on the site and send e-mails Spamcop.net qualified by you as Spam in the form of attachments to the given Spamcop your individual email address.


USAGE
=====

If the properly you gave the right to perform the script, and you have entered your login details now just run this script if there are any reports awaiting confirmation of their approval will start if it does not find anything to approve the script exits with an appropriate message.

NOTE!
- If you run a script when an error occurs on an HTTPS connection, you must install on your system packages "libssl-dev" and "liblwp-protocol-https-perl",
- Service Spamcop needs some time to process requests sent him spam, so each time you sent them you need to wait a few seconds, otherwise the script will be argued that there are no reports for approval.


CHANGELOG
=========
Look at the header of the spamcop.pl script ;o)
