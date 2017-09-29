use lib <t/spec/packages/>;
use Test;
use Test::Util;

plan 5;

# XXX TODO: swap v6.d.PREVIEW to v6.d, once the latter is available
constant $v6d = 'v6.d.PREVIEW';

################### HELPER ROUTINES ###################################

sub test-deprecation (Str:D $lang, Str:D $code, Bool :$is-visible) {
    is_run '
        use \qq[$lang];
        %*ENV<RAKUDO_NO_DEPRECATIONS>:delete;
        \qq[$code]
    ', { :out(''), :err($is-visible ?? /deprecated/ !! ''), :0status },
        ($is-visible ?? 'shows' !! 'no   ')
    ~ " deprecation message using $lang";
}
sub    is-deprecated (|c) { test-deprecation |c, :is-visible }
sub isn't-deprecated (|c) { test-deprecation |c              }
sub is-newly-deprecated (Str:D $code, Str:D $desc = "with `$code`") {
    subtest $desc => {
        plan 2;
        test-deprecation $v6d,   $code, :is-visible;
        test-deprecation 'v6.c', $code;
    }
}

######################################################################

is-newly-deprecated ｢$ = 4.2.Rat: 42｣;
is-newly-deprecated ｢$ = 4.2.FatRat: 42｣;
is-newly-deprecated ｢$ = FatRat.new(4,2).Rat: 42｣;
is-newly-deprecated ｢$ = FatRat.new(4,2).FatRat: 42｣;
is-newly-deprecated ｢".".IO.chdir: "."｣;