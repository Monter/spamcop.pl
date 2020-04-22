#!/usr/bin/env perl
#
# SpamCop.net - Automatic approval of spam reports v3.6 (2020-04-08)
# Written by Monter - https://dev.techlog.pl/projects/Linux/spamcop/
#                     https://github.com/Monter/spamcop.pl
#
# v3.6 - a new "Too many links" message has been added when the reported spam contains too many links
# v3.5 - added a new section "Failed to load spam header"
# v3.4 - adding support for two SpamCOP server errors
#      - change SpamCOP URL to https
#      - updated project homepage URL
# v3.3 - add error handling or lack of valid login and password to log into SpamCOP
#      - allowing working in quiet mode
# v3.2 - improving the positioning of some messages and added a new section "ISP does not wish to receive reports"
# v3.1 - added information about individual e-mail address to which you should send reports of Spam
#      - change the presentation of a script (User Agent)
#      - added a new section "no routeable IP address"
#      - added a new section "Reports have already been sent"
#      - added a new section "No blank line delineating headers from body"
#      - added a new section "No valid email addresses"
#      - other minor cosmetic fixes
# v3.0 - changing the mode of action in the event of an "possible forgery" error - change the alert from an error to a warning that allows you to continue script working
# v2.9 - added a new section that detects "Bounce flag", which blocks the approval of SpamCop reports until logging on the project page and manually cancel the lock
# v2.8 - added two new sections to detect messages: "Supposed receiving system not associated with any of your mailhosts" and "Mailhost configuration problem"
# v2.7 - added debugging option (the write report on disk) and other minor improvements
# v2.6 - added a new section that detects message "No body text provided, check format of submission" which makes it impossible to send a report, because submitted spam does not contain BODY section
# v2.5 - added a new section that detects message "Sorry, this email is too old to file a spam report" which makes it impossible to send a report, because You must report spam within 2 days of receipt
# v2.4 - added a new section that detects message "Reports regarding this spam have already been sent" which makes it impossible to send a report, because the report of the spam has been sent (spam is old)
#      - added information about the address at which you can view the report
#      - added a function to display the date and time
#      - make script output as unbuffered
# v2.3 - added a new section that detects message "No source IP address found" which makes it impossible to send a report about the spam
# v2.2 - added a new section that detects message "ISP resolved this issue" which makes it impossible to send a report about the spam
# v2.1 - replacement "if" condition for the "while" loop for better detection of ads (variable duration)
# v2   - added support for advertising appearing in random moments ("Please wait - subscribe to remove this delay...")
# v1   - initial basic version
#
# Bug reports and suggestions for improvements send me by e-mail to monter [at] techlog.pl or add a report via issues

use strict;
use warnings;
use POSIX qw/strftime/;
use WWW::Mechanize;

$| = 1; # unbuffered output

my $spamcop_url = 'https://www.spamcop.net';
my $user_agent = 'Auto commit SpamCop reports v3.6 (https://github.com/Monter/spamcop.pl)';
my $mech = WWW::Mechanize->new( agent => $user_agent );
$mech->get( $spamcop_url );
die "!! Can't even get the SpamCop page: ", $mech->response->status_line unless $mech->success;
$mech->submit_form (
  form_number => 1,
  fields      => {
    username    => $ENV{'USERNAME'},
    password    => $ENV{'PASSWORD'},
  }
);
die "!! Couldn't submit form. Exit.\n" unless $mech->success;

if ($mech->content =~ /Login.failed/) {
  print "\n@@ ".strftime('%F %T',localtime)."\n";
  die "!! Login failed. Check your username, password, and try again. Also check whether the size of characters is correct.\n";
}

if ($mech->content =~ /an.error.occurred.while.processing.this.directive/) {
  print "\n@@ ".strftime('%F %T',localtime)."\n";
  die "!! [an error occurred while processing this directive] - SpamCOP server problem - please re-try the operation in a minute or two.\n";
}

if ($mech->content =~ /500.Internal.Server.Error/) {
  print "\n@@ ".strftime('%F %T',localtime)."\n";
  die "!! 500 Internal Server Error - Please re-try the operation which caused this error in a minute or two.\n";
}

my $foundLink = $mech->find_link( text => 'Report Now' );
if (defined $foundLink) {
  print "\n@@ ".strftime('%F %T',localtime)."\n";

  my @emails = ($mech->content =~ /spam.to:.<a.href=\"mailto:(.*)\">/cgim);
  foreach my $email (@emails) {
    print "-- Forward your spam to: " . $email . "\n";
  }

  print ":: Report(s) found! Processing...\n";
  my $stop = 0;
  while(not $stop) {
    my $foundLink = $mech->find_link( text => 'Report Now' );
    if (defined $foundLink) {
      $mech->follow_link( text => 'Report Now' );
      while ($mech->content =~ /subscribe.to.remove/) {
        print "## Delay to bypas advertisement...\n";
        sleep(3);
        $mech->get($mech->uri());
      }
      if ($mech->content =~ /resolved.this.issue/) {
        print "## ISP resolved this issue, no report needed. Skipping... (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /Mailhost.configuration.problem/) {
        print "## Mailhost configuration problem. Register every email address where you receive spam (see: ".$mech->uri().")\n";
      } elsif ($mech->content =~ /No.source.IP.address.found/) {
        print "## No source IP address found, cannot proceed. Ignored... (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /No.blank.line.delineating/) {
        print "## No blank line delineating headers from body - abort... (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /No.valid.email.addresses/) {
        print "## No valid email addresses, sorry! (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /spam.have.already.been.sent/) {
        print "## Reports regarding this spam have already been sent. Message is old (see: ".$mech->uri().")\n";
      } elsif ($mech->content =~ /Reports.have.already.been.sent/) {
        print "## Reports have already been sent. Skipping...\n";
      } elsif ($mech->content =~ /this.email.is.too.old.to/) {
        print "## Sorry, this email is too old to file a spam report. You must report spam within 2 days of receipt. See: ".$mech->uri()."\n";
      } elsif ($mech->content =~ /No.body.text.provided/) {
        print "## No body text provided, check format of submission. Spam must have body text. See: ".$mech->uri()."\n";
      } elsif ($mech->content =~ /Bounce.error/) {
        print "!! Your email address has returned a bounce. Visit ".$spamcop_url." to resolve this problem and reset bounce flag. Accepting of reports has been stopped until the clarification of the matter.\n";
      } elsif ($mech->content =~ /Failed.to.load.spam.header/) {
        print "!! Failed to load spam header - abort... (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /Send.Spam.Report/) {
        my $form = $mech->form_name( 'sendreport' );
        print "-> Sent report: ".$mech->value('reports')." - see this report at: ".$mech->uri()."\n";
        if ($mech->content =~ /Possible.forgery/) {
          print "  \\-> Possible forgery. Supposed receiving system not associated with any of your mailhosts\n";
        }
        if ($mech->content =~ /is.not.a.routeable.IP.address/) {
          print "  \\-> Tracking / Parsing input - no routeable IP address\n";
        }
        if ($mech->content =~ /ISP.does.not.wish.to.receive.reports.regarding/) {
          print "  \\-> ISP does not wish to receive reports regarding ... (see ".$mech->uri().")\n";
        }
        if ($mech->content =~ /Too.many.links/) {
          print "  \\-> The reported spam contains a lot of links\n";
        }
        $mech->click_button( 'value' => 'Send Spam Report(s) Now' );
      } else {
        print "!! An unknown error occurred. Please try after some time. If the problem persists, report it to the spamcop.pl author.\n";
      }
    } else {
      print ":: No more report(s) found. Done!\n";
      $stop = 1;
    }
  }
# comment out or remove below lines if you expect quiet mode
} else {
  print "\n@@ ".strftime('%F %T',localtime)."\n";
  die ":: No report(s) found. Exit.\n";
# comment out or remove above lines if you expect quiet mode
}
