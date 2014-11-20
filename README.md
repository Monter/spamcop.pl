SpamCop.net - Automatic approval of SpamCop.net spam reports v2.6 (2014-10-15)
Written by Monter - http://monter.techlog.pl/files/download/_Projects/Linux/spamcop/

History:
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
