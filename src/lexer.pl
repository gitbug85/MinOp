use feature 'class';
use JSON::PP;
no warnings 'experimental::class';

class Segment {
    field $val :param;
    field $col :param;
    field $ln :param;

    method val { return $val; }
    method set_val ($new_val) { $val = $new_val; }
    method col { return $col; }
    method ln  { return $ln;  }

    method TO_JSON {
        return {
            val => $val,
            col => $col,
            ln  => $ln,
        };
    }
}

use constant {
    JOINING_STRING => 0,
    JOINING_PATH => 1,
    JOINING_REGEX => 2,
    NOT_JOINING => 3,
};

sub print_segments {
    my @segs = @_; 
    for $i (0 .. $#segs) {
        $seg = $segs[$i];
        print "\"" . $seg->val . "\" ";
    }
}

sub lex {
    my $filename = shift;
    our @fragments;
    
    open(my $fh, '<:encoding(UTF-8)', $filename) 
        or die "Could not open file '$filename': $!";

    my $current_fragment = "";

    # Make fragments based on spaces
    while (my $line = <$fh>) {
        chomp $line;
        print "Processing: $line\n";

        my @chars = split('', $line);
        my $space = " ";

        for my $i (0 .. $#chars) {
            if ($chars[$i] eq $space) {
                if (current_fragment ne "") {
                    push @fragments, Segment->new(col => $i, ln => $., val => $current_fragment);
                    $current_fragment = "";
                }
                push @fragments, Segment->new(col => $i, ln => $., val => $space);
            } else {
                $current_fragment .= $chars[$i];
            }
        }
        push @fragments, Segment->new(col => $i, ln => $., val => $current_fragment);
        $current_fragment = "";
    }

    our @new_fragments;

    # Make more fragments using regex
    for my $i (0 .. $#fragments) {
        my $fragment = $fragments[$i];
        my $string = $fragment->val;
        my $ln = $fragment->ln;
        my $col = $fragment->col;
        my $regex = qr/([=\+\-\*\/"\(\)\\,#])/;
        my @strings = split($regex, $string);
        @strings = grep { length($_) > 0 } @strings;
        for my $str (@strings) {
            push @new_fragments, Segment->new(
                val => $str, 
                ln  => $ln, 
                col => $col
            );
        }
    }

    @fragments = @new_fragments;

=pod
    Join fragments together to make lexemes:
     - Strings ""
     - Paths ''
     - Regex ``
     Everything else is one to one.
=cut

    my $lexing_status = NOT_JOINING;
    my @lexemes;
    my $current_lexeme;
    my $previous_backslash = 0;

    for my $i (0 .. $#fragments) {
        my $fragment = $fragments[$i];
        my $string = $fragment->val;

        if ($string eq "\\") {
            # Backslash

        } elsif ($string eq '"') {
            # String start or end

        } elsif ($string eq "'") {
            # Path start or end

        } elsif ($string eq "`") {
            # Regex start or end

        } else {
            # Normal fragment

        }
    }

    print_segments(@lexemes);

    # # Convert and return JSON string
    # my $json_encoder = JSON::PP->new->convert_blessed(1);
    # my $json_string  = $json_encoder->encode(\@lexemes);

    # print $json_string, "\n";
    print '';
}

my $input_file = $ARGV[0]; 

if ($input_file) {
    lex($input_file);
} else {
    die "No input file path was provided to the Perl script.\n";
}