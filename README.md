SpamCop.net - Automatic approval of SpamCop.net spam reports v2.6 (2014-10-15)
Written by Monter - http://monter.techlog.pl/files/download/_Projects/Linux/spamcop/


README
======

spamcop.pl script was created because of not finding the Internet a suitable tool for wholesale approval of the report on Spamcop.net after submitting applications containing Spam, or possibly solutions found were too old/date/too big, etc).

The script for the action requires the WWW::Mechanize extension of the Perl.
Was tested on Perl version 5.10.1 and 5.14.2.

Action script in a nutshell replaces the user and the browser simulating the appropriate action on the Web sites visited by reading the content of these pages and clicking the appropriate buttons.

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

The script requires the Perl environment to work with the module WWW:Mechanize. Script does not require installation, it must be only edited after downloading and in the right place to enter your login details to Spamcop.net.
- download the script and save it to disk
- give him the right to do (chmod + x)
- Edit the script and in the right places to give your username and password to the Spamcop.net site.
 
To use the script, you must have a user account on the site and send e-mails Spamcop.net qualified by Cieie as Spam in the form of attachments to the given Spamcop your individual email address.


USAGE
=====

If the properly you gave the right to perform the script, and you have entered your login details now just run this script if there are any reports awaiting confirmation of their approval will start if it does not find anything to approve the script exits with an appropriate message.

NOTE!
Service Spamcop needs some time to process requests sent him spam, so each time you sent them you need to wait a few seconds, otherwise the script will be argued that there are no reports for approval.


CHANGELOG
=========

- v2.6 - added a new section that detects message "No body text provided, check format of submission" which makes it impossible to send a report, because submitted spam does not contain BODY section.
- v2.5 - added a new section that detects message "Sorry, this email is too old to file a spam report" which makes it impossible to send a report, because You must report spam within 2 days of receipt.
- v2.4 - added a new section that detects message "Reports regarding this spam have already been sent" which makes it impossible to send a report, because the report of the spam has been sent (spam is old).
       - added information about the address at which you can view the report
       - added a function to display the date and time
       - make script output as unbuffered
- v2.3 - added a new section that detects message "No source IP address found" which makes it impossible to send a report about the spam.
- v2.2 - added a new section that detects message "ISP resolved this issue" which makes it impossible to send a report about the spam.
- v2.1 - replacement "if" condition for the "while" loop for better detection of ads (variable duration).
- v2   - added support for advertising appearing in random moments ("Please wait - subscribe to remove this delay...")
- v1   - initial basic version
