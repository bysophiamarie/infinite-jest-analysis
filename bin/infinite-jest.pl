use 5.14.2;
use warnings;
use Text::CSV_XS;
my $csv = Text::CSV_XS->new({ binary => 1, auto_diag => 1 });
open my $fh, "<:encoding(utf8)", "infinite-jest.csv" or die "infinite-jest.csv: $!";
say '[';
while (my $row = $csv->getline($fh)) {
    next if $row->[0] eq 'Chapter';
    s/(\x{201c}|\x{201d})/"/g for @$row;
    my $characters_present = $row->[6];
    my $synopsis = $row->[7];
    s/"/\\"/g for $characters_present, $synopsis;
    $characters_present = join '", "', split /;/, $characters_present;
    my $comma = $row->[1] eq 189 ? '' : ',';
    my $json = <<JSON;
    {
        "chapter": "$row->[0]",
        "section": "$row->[1]",
        "date": [ "$row->[3]", "$row->[5]", "$row->[4]" ],
        "location": "",
        "synopsis": "$synopsis",
        "characters": {
            "present": [ "$characters_present" ],
            "absent": [ ]
        },
        "narrator": [ ],
        "motifs": [ ],
        "footnotes": [ ]
    }$comma
JSON
    utf8::encode $json;
    print $json;
}
say ']';
