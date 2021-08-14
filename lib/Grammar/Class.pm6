grammar Grammar::ClassName {
    regex TOP { .*? <unit>? <class_tag> <name> <inheritance>* <implement>* .* }

    token unit { 'unit' \s+ }
    token class_tag { 'class' \s+ }
    token name { <-[\s { ; \n]>+ \s* }
    token inheritance { 'is' \s+ <name> \s* }
    token implement { 'does' \s+ <name> }
}

class Action::ClassName {
    method TOP($/) {
        make %(
            name => $<name>.made,
            inheritance => [$<inheritance>>>.made],
            implement => [$<implement>>>.made],
        )
    }

    method name($/) {
        make $/.Str.trim;
    }

    method inheritance($/) {
        make $<name>.Str.trim;
    }

    method implement($/) {
        make $<name>.Str.trim;
    }
}

grammar Grammar::Dependencies {
    regex TOP { <dependency>* }

    token dependency { .*? <keyword> \s+ <name> <-[\n]>+ \n }
    token keyword {[ | 'use' | 'need' ] }
    token name { <-[\s;]>+ }
}

grammar Grammar::Attributes {
    regex TOP { <attribute>* }

    token attribute { .*? <has> \s+ <type>? \s* <name> \s* <modifier>? ';' }
    token has {  'has' }
    token type { <-[\s $ @ % &]>+ }
    token name { ['$'|'@'|'%'|'&']<-[;\s]>+ }
    token modifier { <-[;]>+ }
}

class Action::Attributes {
    method TOP($/) { make $<attribute>.map(*.made).Array  }

    method attribute($/) { make %(name => $<name>.made, type => ($<type>.made ?? $<type>.made !! ''), modifier => ($<modifier>.made ?? $<modifier>.made !! '')) }
    method type($/) { make ~$/ }
    method name($/) { make ~$/ }
    method modifier($/) { make ~$/ }
}

grammar Grammar::Methods {
    token TOP { <method>* }

    token method { .*? <keyword> <name> .*? }
    token keyword { 'method' }
    token name { \s* <-[\s\(\{]>+ }
}

class Action::Methods {
    method TOP($/) { make [$<method>>>.made] }
    method method($/) { make $<name>.made }
    method name($/) { make $/.Str }
}