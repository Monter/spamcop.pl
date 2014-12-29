#!/usr/bin/perl
#
# SpamCop.net - Automatic approval of spam reports v2.7 (2014-12-29)
# Written by Monter - http://monter.techlog.pl/files/download/_Projects/Linux/spamcop/
#                     https://github.com/Monter/spamcop.pl
#
# v2.7 - added debugging option (the write report on disk) and other minor improvements
# v2.6 - added a new section that detects message "No body text provided, check format of submission" which makes it impossible to send a report, because submitted spam does not contain BODY section.
# v2.5 - added a new section that detects message "Sorry, this email is too old to file a spam report" which makes it impossible to send a report, because You must report spam within 2 days of receipt.
# v2.4 - added a new section that detects message "Reports regarding this spam have already been sent" which makes it impossible to send a report, because the report of the spam has been sent (spam is old).
#      - added information about the address at which you can view the report
#      - added a function to display the date and time
#      - make script output as unbuffered
# v2.3 - added a new section that detects message "No source IP address found" which makes it impossible to send a report about the spam.
# v2.2 - added a new section that detects message "ISP resolved this issue" which makes it impossible to send a report about the spam.
# v2.1 - replacement "if" condition for the "while" loop for better detection of ads (variable duration).
# v2   - added support for advertising appearing in random moments ("Please wait - subscribe to remove this delay...")
# v1   - initial basic version
#
# Bug reports and suggestions for improvements send an email monter[at]techlog.pl

use strict;
use warnings;
use POSIX qw/strftime/;
use WWW::Mechanize;

$| = 1; # unbuffered output
print "\n@@ ".strftime('%F %T',localtime)."\n";

my $spamcop_url = 'http://www.spamcop.net';

my $mech = WWW::Mechanize->new();
$mech->get( $spamcop_url );
die "!! Can't even get the SpamCop page: ", $mech->response->status_line unless $mech->success;
$mech->submit_form (
  form_number => 1,
  fields      => {
    username    => 'YOUR_SPAMCOP_LOGIN',
    password    => 'YOUR_SPAMCOP_PASSWORD',
  }
);
die "!! Couldn't submit form. Exit.\n" unless $mech->success;

my $foundLink = $mech->find_link( text => 'Report Now' );
if (defined $foundLink) {
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
      } elsif ($mech->content =~ /No.source.IP.address.found/) {
        print "## No source IP address found, cannot proceed. Ignored... (see ".$mech->uri().")\n";
      } elsif ($mech->content =~ /spam.have.already.been.sent/) {
        print "## Reports regarding this spam have already been sent. Message is old, see: ".$mech->uri()."\n";
      } elsif ($mech->content =~ /this.email.is.too.old.to/) {
        print "## Sorry, this email is too old to file a spam report. You must report spam within 2 days of receipt. See: ".$mech->uri()."\n";
      } elsif ($mech->content =~ /No.body.text.provided/) {
        print "## No body text provided, check format of submission. Spam must have body text. See: ".$mech->uri()."\n";
      } elsif ($mech->content =~ /Send.Spam.Report/) {
        my $form = $mech->form_name( 'sendreport' );
        print "-> Send report: ".$mech->value('reports')." - see this report at: ".$mech->uri()."\n";
        $mech->click_button( 'value' => 'Send Spam Report(s) Now' );
      } else {
        print "!! An unknown error occurred. Please try after some time. If the problem persists, report it to the spamcop.pl author.\n";
        # debug
        #$mech->save_content("error_report");
      }
    } else {
      print ":: No more report(s) found. Done!\n";
      $stop = 1;
    }
  }
} else {
  die ":: No report(s) found. Exit.\n";
}
