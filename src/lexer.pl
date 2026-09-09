use JSON::PP;

my $string = $ARGV[0];
my $regex = qr/([=\+\-\*\/"\(\)\\,# ])/;
my @strings = split($regex, $string);
my $json_string = encode_json(\@strings);
print $json_string, "\n";